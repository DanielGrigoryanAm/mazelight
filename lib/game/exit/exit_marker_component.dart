import 'dart:ui';

import 'package:flame/components.dart';

import '../../maze/grid_position.dart';
import '../board/board_theme.dart';
import 'exit_marker_painter.dart';

/// Static marker for the maze's exit cell — an amber glowing ring, always
/// in place (unlike [PlayerComponent], it never moves).
class ExitMarkerComponent extends PositionComponent {
  ExitMarkerComponent({required GridPosition gridPosition})
      : super(
          size: Vector2.all(_diameter),
          anchor: Anchor.center,
          position: _pixelCenter(gridPosition),
        );

  static const double _diameter = BoardTheme.cellSize * 0.6;

  static Vector2 _pixelCenter(GridPosition position) => Vector2(
        position.col * BoardTheme.cellSize + BoardTheme.cellSize / 2,
        position.row * BoardTheme.cellSize + BoardTheme.cellSize / 2,
      );

  @override
  void render(Canvas canvas) {
    final center = (size / 2).toOffset();
    paintExitMarker(canvas, center, _diameter / 2);
  }
}
