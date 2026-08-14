import 'dart:ui';

/// Amber glowing ring for the maze's exit cell — a soft halo behind a
/// hollow ring with a small core, visually distinct from the player's solid
/// ball so it reads as a goal beacon rather than something you carry.
void paintExitMarker(Canvas canvas, Offset center, double radius) {
  final glowPaint = Paint()
    ..color = const Color(0x66FFC107)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
  canvas.drawCircle(center, radius * 1.5, glowPaint);

  final ringPaint = Paint()
    ..color = const Color(0xFFFFC107)
    ..style = PaintingStyle.stroke
    ..strokeWidth = radius * 0.35;
  canvas.drawCircle(center, radius * 0.7, ringPaint);

  canvas.drawCircle(center, radius * 0.25, Paint()..color = const Color(0xFFFFE082));
}
