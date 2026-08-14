import 'direction.dart';
import 'grid_position.dart';
import 'maze_cell.dart';

class Maze {
  final int rows;
  final int cols;
  final List<List<MazeCell>> grid;
  final GridPosition entrance;
  final GridPosition exit;

  Maze({
    required this.rows,
    required this.cols,
    required this.grid,
    required this.entrance,
    required this.exit,
  });

  MazeCell cellAt(GridPosition position) => grid[position.row][position.col];

  bool inBounds(GridPosition position) =>
      position.row >= 0 &&
      position.row < rows &&
      position.col >= 0 &&
      position.col < cols;

  bool canMove(GridPosition from, Direction direction) {
    if (!inBounds(from)) return false;
    final to = GridPosition(from.row + direction.dRow, from.col + direction.dCol);
    if (!inBounds(to)) return false;
    return cellAt(from).isOpen(direction);
  }
}
