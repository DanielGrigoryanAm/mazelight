import 'dart:ui';

import 'package:flame/components.dart';

import '../../maze/direction.dart';
import '../../maze/grid_position.dart';
import '../../maze/maze.dart';
import 'board_assets.dart';
import 'board_theme.dart';
import 'wall_shadow_painter.dart';
import 'wall_sprite_painter.dart';

typedef _WallSegment = ({Rect rect, bool vertical, int seed});

/// Renders a [Maze]'s brick-textured walls along the open/closed edges of
/// each cell (the floor is a separate static backdrop layer — see
/// [FloorBackdropComponent] — so it can cover the full screen independently
/// of the maze's own zoom). Walls are drawn in three passes (shadow, side
/// face, then brick top) across every segment so a wall never gets its top
/// course dimmed by a neighbouring segment's shadow drawn later.
class MazeBoardComponent extends PositionComponent {
  MazeBoardComponent({required this.maze, required this.assets})
      : super(
          size: Vector2(
            maze.cols * BoardTheme.cellSize,
            maze.rows * BoardTheme.cellSize,
          ),
        );

  final Maze maze;
  final BoardAssets assets;

  static const double _cellSize = BoardTheme.cellSize;
  static const double _wallThickness = _cellSize * BoardTheme.wallThicknessRatio;
  static const double _wallHeight = _cellSize * BoardTheme.wallHeightRatio;

  @override
  void render(Canvas canvas) {
    final segments = _collectWallSegments();
    for (final segment in segments) {
      paintWallShadow(canvas, segment.rect, _wallHeight);
    }
    for (final segment in segments) {
      paintWallSideFace(canvas, segment.rect, _wallHeight);
    }
    for (final segment in segments) {
      paintBrickWall(
        canvas,
        segment.rect,
        assets.bricks,
        vertical: segment.vertical,
        seed: segment.seed,
      );
    }
  }

  // Each interior wall is shared by two cells; visiting only a cell's
  // north/west edges (plus the outer south/east border) covers every
  // segment exactly once.
  List<_WallSegment> _collectWallSegments() {
    final segments = <_WallSegment>[];
    for (var row = 0; row < maze.rows; row++) {
      for (var col = 0; col < maze.cols; col++) {
        final cell = maze.cellAt(GridPosition(row, col));
        final left = col * _cellSize;
        final top = row * _cellSize;

        if (cell.hasWall(Direction.north)) {
          segments.add(_horizontalSegment(left, top, row, col, 0));
        }
        if (cell.hasWall(Direction.west)) {
          segments.add(_verticalSegment(left, top, row, col, 1));
        }
        if (row == maze.rows - 1 && cell.hasWall(Direction.south)) {
          segments.add(_horizontalSegment(left, top + _cellSize, row, col, 2));
        }
        if (col == maze.cols - 1 && cell.hasWall(Direction.east)) {
          segments.add(_verticalSegment(left + _cellSize, top, row, col, 3));
        }
      }
    }
    return segments;
  }

  _WallSegment _horizontalSegment(
    double left,
    double edgeY,
    int row,
    int col,
    int edgeSalt,
  ) {
    final rect = Rect.fromLTWH(
      left - _wallThickness / 2,
      edgeY - _wallThickness / 2,
      _cellSize + _wallThickness,
      _wallThickness,
    );
    return (rect: rect, vertical: false, seed: _seedFor(row, col, edgeSalt));
  }

  _WallSegment _verticalSegment(
    double edgeX,
    double top,
    int row,
    int col,
    int edgeSalt,
  ) {
    final rect = Rect.fromLTWH(
      edgeX - _wallThickness / 2,
      top - _wallThickness / 2,
      _wallThickness,
      _cellSize + _wallThickness,
    );
    return (rect: rect, vertical: true, seed: _seedFor(row, col, edgeSalt));
  }

  // Deterministic seed so each wall segment's brick course stays the same
  // across rebuilds/frames, while still varying between segments.
  int _seedFor(int row, int col, int edgeSalt) => row * 7 + col * 13 + edgeSalt * 5;
}
