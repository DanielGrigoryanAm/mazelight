import 'dart:ui';

/// Board sizing shared across the maze renderer.
class BoardTheme {
  BoardTheme._();

  static const double cellSize = 48.0;
  static const double wallThicknessRatio = 0.32;
  static const double wallHeightRatio = 0.15;

  static const Color background = Color(0xFF0C0A08);
  static const Color floorDarkenColor = Color(0x57000000);
  static const Color wallSideColor = Color(0x84241C16);
  static const Color wallShadowColor = Color(0x8A000000);
  static const double wallShadowBlurSigma = 3.5;
  static const double wallSideRadius = 4.0;
}
