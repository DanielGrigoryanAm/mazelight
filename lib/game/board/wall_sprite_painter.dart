import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';

/// Lays bricks end-to-end along [footprint] like a real course of masonry —
/// each brick keeps its own width/height ratio (uniform scale, no squish).
/// The run is filled by placing successive bricks (picked pseudo-randomly
/// from [bricks], seeded so a given wall segment always looks the same)
/// until the length is covered; only the last brick is cropped — never
/// stretched — to fit exactly.
///
/// [vertical] rotates the whole run 90 degrees around the footprint's
/// center so the same (horizontal) textures can be reused for vertical
/// walls without distortion.
void paintBrickWall(
  Canvas canvas,
  Rect footprint,
  List<Sprite> bricks, {
  required bool vertical,
  required int seed,
}) {
  if (!vertical) {
    _paintBrickRun(canvas, footprint, bricks, seed);
    return;
  }

  canvas.save();
  canvas.translate(footprint.center.dx, footprint.center.dy);
  canvas.rotate(pi / 2);
  final rotatedRect = Rect.fromCenter(
    center: Offset.zero,
    width: footprint.height,
    height: footprint.width,
  );
  _paintBrickRun(canvas, rotatedRect, bricks, seed);
  canvas.restore();
}

void _paintBrickRun(Canvas canvas, Rect run, List<Sprite> bricks, int seed) {
  final random = Random(seed);
  final paint = Paint();
  var x = run.left;

  while (x < run.right - 0.01) {
    final brick = bricks[random.nextInt(bricks.length)];
    final scale = run.height / brick.src.height;
    final fullWidth = brick.src.width * scale;
    final remaining = run.right - x;
    final destWidth = fullWidth <= remaining ? fullWidth : remaining;
    final srcWidth = destWidth / scale;

    final srcRect = Rect.fromLTWH(
      brick.src.left,
      brick.src.top,
      srcWidth,
      brick.src.height,
    );
    final destRect = Rect.fromLTWH(x, run.top, destWidth, run.height);

    canvas.drawImageRect(brick.image, srcRect, destRect, paint);
    x += destWidth;
  }
}
