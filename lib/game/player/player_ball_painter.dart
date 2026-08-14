import 'dart:ui';

/// Green glowing ball for the player marker — a soft blurred halo behind a
/// solid disc, plus a small highlight so it reads as a sphere rather than a
/// flat circle.
void paintPlayerBall(Canvas canvas, Offset center, double radius) {
  final glowPaint = Paint()
    ..color = const Color(0x5539FF6A)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
  canvas.drawCircle(center, radius * 1.4, glowPaint);

  canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF2ECC55));

  final highlightCenter = center - Offset(radius * 0.3, radius * 0.3);
  canvas.drawCircle(
    highlightCenter,
    radius * 0.30,
    Paint()..color = const Color(0x99FFFFFF),
  );
}
