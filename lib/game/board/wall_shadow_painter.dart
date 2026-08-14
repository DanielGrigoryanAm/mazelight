import 'dart:ui';

import 'board_theme.dart';

/// Wall height is faked with a fixed top-down light convention: every wall
/// segment casts a soft blurred contact shadow onto the floor below it,
/// independent of whether the segment itself runs horizontally or is a
/// rotated-vertical brick run — see [paintWallSideFace] for the matching
/// solid face.
void paintWallShadow(Canvas canvas, Rect footprint, double wallHeight) {
  final shadowRect = Rect.fromLTWH(
    footprint.left + 2,
    footprint.bottom + wallHeight * 0.35,
    footprint.width,
    wallHeight * 0.7,
  );
  final paint = Paint()
    ..color = BoardTheme.wallShadowColor
    ..maskFilter = const MaskFilter.blur(
      BlurStyle.normal,
      BoardTheme.wallShadowBlurSigma,
    );
  canvas.drawRect(shadowRect, paint);
}

/// Solid "side" face below the wall's top brick course — the visible
/// vertical stone face that makes the wall read as raised off the floor.
void paintWallSideFace(Canvas canvas, Rect footprint, double wallHeight) {
  final sideRect = Rect.fromLTWH(
    footprint.left,
    footprint.bottom,
    footprint.width,
    wallHeight,
  );
  final sideRRect = RRect.fromRectAndCorners(
    sideRect,
    bottomLeft: const Radius.circular(BoardTheme.wallSideRadius),
    bottomRight: const Radius.circular(BoardTheme.wallSideRadius),
  );
  canvas.drawRRect(sideRRect, Paint()..color = BoardTheme.wallSideColor);
}
