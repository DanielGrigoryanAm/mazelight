import 'direction.dart';

class MazeCell {
  final int row;
  final int col;
  final Set<Direction> walls;

  MazeCell(this.row, this.col) : walls = {...Direction.values};

  bool hasWall(Direction direction) => walls.contains(direction);

  bool isOpen(Direction direction) => !walls.contains(direction);
}
