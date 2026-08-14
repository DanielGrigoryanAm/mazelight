import 'package:flutter_test/flutter_test.dart';
import 'package:mazelight/maze/direction.dart';
import 'package:mazelight/maze/grid_position.dart';
import 'package:mazelight/maze/maze.dart';
import 'package:mazelight/maze/maze_generator.dart';

/// BFS over open passages, returns every cell reachable from [start].
Set<GridPosition> _reachableCells(Maze maze, GridPosition start) {
  final visited = <GridPosition>{start};
  final queue = <GridPosition>[start];

  while (queue.isNotEmpty) {
    final current = queue.removeLast();
    for (final direction in Direction.values) {
      if (!maze.canMove(current, direction)) continue;
      final next = GridPosition(
        current.row + direction.dRow,
        current.col + direction.dCol,
      );
      if (visited.add(next)) queue.add(next);
    }
  }

  return visited;
}

int _totalOpenPassages(Maze maze) {
  var count = 0;
  for (final row in maze.grid) {
    for (final cell in row) {
      // Count each open wall once by only looking east/south, so shared
      // passages between neighbors aren't double-counted.
      if (cell.isOpen(Direction.east)) count++;
      if (cell.isOpen(Direction.south)) count++;
    }
  }
  return count;
}

void main() {
  group('MazeGenerator', () {
    test('produces a grid with the requested dimensions', () {
      final maze = MazeGenerator(rows: 7, cols: 7, seed: 1).generate();

      expect(maze.rows, 7);
      expect(maze.cols, 7);
      expect(maze.grid.length, 7);
      expect(maze.grid.every((row) => row.length == 7), isTrue);
    });

    test('every cell is reachable from the entrance (fully connected)', () {
      final maze = MazeGenerator(rows: 11, cols: 9, seed: 42).generate();

      final reachable = _reachableCells(maze, maze.entrance);

      expect(reachable.length, maze.rows * maze.cols);
    });

    test('the exit is reachable from the entrance (solvable)', () {
      final maze = MazeGenerator(rows: 15, cols: 15, seed: 7).generate();

      final reachable = _reachableCells(maze, maze.entrance);

      expect(reachable.contains(maze.exit), isTrue);
    });

    test('is a perfect maze: exactly rows*cols - 1 passages, no loops', () {
      final maze = MazeGenerator(rows: 8, cols: 6, seed: 3).generate();

      expect(_totalOpenPassages(maze), maze.rows * maze.cols - 1);
    });

    test('same seed and dimensions produce an identical maze', () {
      final mazeA = MazeGenerator(rows: 9, cols: 9, seed: 123).generate();
      final mazeB = MazeGenerator(rows: 9, cols: 9, seed: 123).generate();

      for (var row = 0; row < mazeA.rows; row++) {
        for (var col = 0; col < mazeA.cols; col++) {
          final position = GridPosition(row, col);
          expect(
            mazeA.cellAt(position).walls,
            mazeB.cellAt(position).walls,
            reason: 'cell ($row, $col) walls differ',
          );
        }
      }
    });

    test('different seeds produce different mazes', () {
      final mazeA = MazeGenerator(rows: 9, cols: 9, seed: 1).generate();
      final mazeB = MazeGenerator(rows: 9, cols: 9, seed: 2).generate();

      final anyDifferentCell = List.generate(mazeA.rows, (row) => row).any(
        (row) => List.generate(mazeA.cols, (col) => col).any((col) {
          final position = GridPosition(row, col);
          return mazeA.cellAt(position).walls !=
              mazeB.cellAt(position).walls;
        }),
      );

      expect(anyDifferentCell, isTrue);
    });

    test('boundary cells keep outer walls (no passage leads off-grid)', () {
      final maze = MazeGenerator(rows: 5, cols: 5, seed: 9).generate();

      for (var col = 0; col < maze.cols; col++) {
        expect(maze.cellAt(GridPosition(0, col)).hasWall(Direction.north), isTrue);
        expect(
          maze.cellAt(GridPosition(maze.rows - 1, col)).hasWall(Direction.south),
          isTrue,
        );
      }
      for (var row = 0; row < maze.rows; row++) {
        expect(maze.cellAt(GridPosition(row, 0)).hasWall(Direction.west), isTrue);
        expect(
          maze.cellAt(GridPosition(row, maze.cols - 1)).hasWall(Direction.east),
          isTrue,
        );
      }
    });

    test('handles a 1x1 maze without error', () {
      final maze = MazeGenerator(rows: 1, cols: 1, seed: 0).generate();

      expect(maze.entrance, maze.exit);
      expect(maze.cellAt(const GridPosition(0, 0)).walls.length, 4);
    });
  });
}
