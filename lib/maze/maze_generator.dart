import 'dart:math';

import 'direction.dart';
import 'grid_position.dart';
import 'maze.dart';
import 'maze_cell.dart';

/// Generates a perfect maze (exactly one path between any two cells) using
/// randomized Prim's algorithm. Same [seed] + [rows] + [cols] always
/// produces the same maze, so a level's seed can be its level number.
///
/// Prim's spreads passages outward from many frontier cells at once, rather
/// than carving one corridor at a time to its end (recursive backtracker),
/// so it produces frequent short dead-ends instead of one long winding
/// corridor — a maze that reads as having real branch points, even though
/// it's still a perfect maze with exactly one solution.
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
    final inMaze = List.generate(rows, (_) => List.filled(cols, false));

    const start = GridPosition(0, 0);
    inMaze[start.row][start.col] = true;

    final frontier = <_WallCandidate>[];
    _addFrontier(frontier, start, inMaze);

    while (frontier.isNotEmpty) {
      final candidate = frontier.removeAt(random.nextInt(frontier.length));
      if (inMaze[candidate.to.row][candidate.to.col]) continue;

      _carvePassage(grid, candidate.from, candidate.direction, candidate.to);
      inMaze[candidate.to.row][candidate.to.col] = true;
      _addFrontier(frontier, candidate.to, inMaze);
    }

    return Maze(
      rows: rows,
      cols: cols,
      grid: grid,
      entrance: const GridPosition(0, 0),
      exit: GridPosition(rows - 1, cols - 1),
    );
  }

  void _addFrontier(
    List<_WallCandidate> frontier,
    GridPosition cell,
    List<List<bool>> inMaze,
  ) {
    for (final direction in Direction.values) {
      final row = cell.row + direction.dRow;
      final col = cell.col + direction.dCol;
      if (row >= 0 && row < rows && col >= 0 && col < cols && !inMaze[row][col]) {
        frontier.add(_WallCandidate(cell, direction, GridPosition(row, col)));
      }
    }
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

/// A candidate passage from an already-carved cell to an [to] neighbor
/// that may or may not still be unvisited by the time it's drawn.
class _WallCandidate {
  const _WallCandidate(this.from, this.direction, this.to);

  final GridPosition from;
  final Direction direction;
  final GridPosition to;
}
