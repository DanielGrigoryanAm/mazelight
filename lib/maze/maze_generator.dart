import 'dart:math';

import 'direction.dart';
import 'grid_position.dart';
import 'maze.dart';
import 'maze_cell.dart';

/// Generates a perfect maze (exactly one path between any two cells) using
/// the iterative Recursive Backtracker algorithm. Same [seed] + [rows] +
/// [cols] always produces the same maze, so a level's seed can be its
/// level number.
class MazeGenerator {
  final int rows;
  final int cols;
  final int seed;

  MazeGenerator({
    required this.rows,
    required this.cols,
    required this.seed,
  })  : assert(rows > 0),
        assert(cols > 0);

  Maze generate() {
    final random = Random(seed);
    final grid = List.generate(
      rows,
      (row) => List.generate(cols, (col) => MazeCell(row, col)),
    );
    final visited = List.generate(rows, (_) => List.filled(cols, false));

    final stack = <GridPosition>[];
    var current = const GridPosition(0, 0);
    visited[current.row][current.col] = true;
    stack.add(current);

    while (stack.isNotEmpty) {
      current = stack.last;
      final unvisitedDirections = _unvisitedNeighborDirections(current, visited);

      if (unvisitedDirections.isEmpty) {
        stack.removeLast();
        continue;
      }

      final direction =
          unvisitedDirections[random.nextInt(unvisitedDirections.length)];
      final next = GridPosition(
        current.row + direction.dRow,
        current.col + direction.dCol,
      );

      _carvePassage(grid, current, direction, next);
      visited[next.row][next.col] = true;
      stack.add(next);
    }

    return Maze(
      rows: rows,
      cols: cols,
      grid: grid,
      entrance: const GridPosition(0, 0),
      exit: GridPosition(rows - 1, cols - 1),
    );
  }

  List<Direction> _unvisitedNeighborDirections(
    GridPosition cell,
    List<List<bool>> visited,
  ) {
    final result = <Direction>[];
    for (final direction in Direction.values) {
      final row = cell.row + direction.dRow;
      final col = cell.col + direction.dCol;
      if (row >= 0 && row < rows && col >= 0 && col < cols && !visited[row][col]) {
        result.add(direction);
      }
    }
    return result;
  }

  void _carvePassage(
    List<List<MazeCell>> grid,
    GridPosition from,
    Direction direction,
    GridPosition to,
  ) {
    grid[from.row][from.col].walls.remove(direction);
    grid[to.row][to.col].walls.remove(direction.opposite);
  }
}
