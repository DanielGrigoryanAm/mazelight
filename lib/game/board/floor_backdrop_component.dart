import 'dart:ui';

import 'package:flame/components.dart';

import 'floor_painter.dart';

/// Static full-screen floor behind the maze. Lives in the camera's backdrop
/// layer, which isn't affected by the viewfinder's zoom/position, so it
/// always fills the whole viewport — the letterbox margins around a maze
/// that doesn't match the screen's aspect ratio show floor texture instead
/// of the plain background colour.
class FloorBackdropComponent extends PositionComponent {
  FloorBackdropComponent({required this.floor});

  final Sprite floor;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    paintFloorBackground(canvas, Rect.fromLTWH(0, 0, size.x, size.y), floor);
  }
}
