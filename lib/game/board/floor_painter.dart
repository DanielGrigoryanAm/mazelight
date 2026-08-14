import 'dart:ui';

import 'package:flame/sprite.dart';

import 'board_theme.dart';

/// Fills [bounds] with [floor] using a "cover" crop: the texture is scaled
/// uniformly (same factor on both axes) and centred, cropping whatever
/// overflows — never stretched non-uniformly, which would distort it. A
/// dark overlay is blended on top so the floor reads as dim stone rather
/// than a bright flat texture.
void paintFloorBackground(Canvas canvas, Rect bounds, Sprite floor) {
  final srcWidth = floor.src.width;
  final srcHeight = floor.src.height;

  final scaleX = bounds.width / srcWidth;
  final scaleY = bounds.height / srcHeight;
  final scale = scaleX > scaleY ? scaleX : scaleY;

  final cropWidth = bounds.width / scale;
  final cropHeight = bounds.height / scale;

  final srcRect = Rect.fromLTWH(
    floor.src.left + (srcWidth - cropWidth) / 2,
    floor.src.top + (srcHeight - cropHeight) / 2,
    cropWidth,
    cropHeight,
  );

  canvas.drawImageRect(floor.image, srcRect, bounds, Paint());
  canvas.drawRect(bounds, Paint()..color = BoardTheme.floorDarkenColor);
}
