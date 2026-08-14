import 'dart:ui';

import 'package:flame/components.dart';

import '../../maze/grid_position.dart';
import '../board/board_theme.dart';
import 'player_ball_painter.dart';

/// The player marker: a green ball that glides smoothly between grid cells
/// instead of snapping, so [moveTo] steps still read as continuous motion
/// under the joystick's repeated-step input. Each move's [speedFactor] lets
/// the caller make a gentle joystick push roll the ball more slowly than a
/// full-deflection push.
class PlayerComponent extends PositionComponent {
  PlayerComponent({required GridPosition gridPosition})
      : _gridPosition = gridPosition,
        super(
          size: Vector2.all(_diameter),
          anchor: Anchor.center,
          position: _pixelCenter(gridPosition),
        );

  static const double _diameter = BoardTheme.cellSize * 0.4;
  static const double _baseSpeed = BoardTheme.cellSize * 6;

  GridPosition _gridPosition;
  GridPosition get gridPosition => _gridPosition;

  Vector2? _moveTarget;
  double _speedFactor = 1;
  bool get isMoving => _moveTarget != null;

  static Vector2 _pixelCenter(GridPosition position) => Vector2(
        position.col * BoardTheme.cellSize + BoardTheme.cellSize / 2,
        position.row * BoardTheme.cellSize + BoardTheme.cellSize / 2,
      );

  void moveTo(GridPosition target, {double speedFactor = 1}) {
    _gridPosition = target;
    _moveTarget = _pixelCenter(target);
    _speedFactor = speedFactor;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final target = _moveTarget;
    if (target == null) return;

    final toTarget = target - position;
    final step = _baseSpeed * _speedFactor * dt;
    if (toTarget.length <= step) {
      position = target;
      _moveTarget = null;
    } else {
      position += toTarget.normalized() * step;
    }
  }

  @override
  void render(Canvas canvas) {
    final center = (size / 2).toOffset();
    paintPlayerBall(canvas, center, _diameter / 2);
  }
}
