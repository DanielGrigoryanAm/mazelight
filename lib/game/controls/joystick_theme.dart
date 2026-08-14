import 'dart:ui';

/// Visual + timing constants for [JoystickWidget].
class JoystickTheme {
  JoystickTheme._();

  static const double baseRadius = 55.0;
  static const double knobDiameter = 56.0;
  static const double deadZone = 12.0;

  // How often a held direction repeats scales with how far the knob is
  // pushed: barely past the dead zone repeats at [stepIntervalSlow], full
  // deflection repeats at [stepIntervalFast].
  static const Duration stepIntervalSlow = Duration(milliseconds: 480);
  static const Duration stepIntervalFast = Duration(milliseconds: 110);

  static const Color baseColor = Color(0x33FFFFFF);
  static const Color borderColor = Color(0x66FFFFFF);
  static const Color knobColor = Color(0xFF2ECC55);
  static const Color knobGlow = Color(0x992ECC55);
}
