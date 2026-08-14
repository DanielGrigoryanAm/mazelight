import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../maze/direction.dart';
import 'joystick_theme.dart';

/// Fired on each repeated step. [intensity] is how far the knob is pushed
/// past the dead zone toward the edge (`0`..`1`) — the caller uses it to
/// scale how fast the ball actually glides, on top of the repeat rate
/// already slowing down here.
typedef JoystickStepCallback = void Function(Direction direction, double intensity);

/// Analog joystick for driving the player through the maze. Dragging the
/// knob picks a [Direction] and fires [onStep] once immediately, then again
/// — at a rate that scales with how far the knob is pushed, see
/// [JoystickTheme.stepIntervalSlow]/[stepIntervalFast] — while held that
/// way. Each step is just a request; [MazeGame.movePlayer] is the one that
/// checks walls, so holding the knob against a wall simply stops moving
/// without extra logic here.
class JoystickWidget extends StatefulWidget {
  const JoystickWidget({super.key, required this.onStep});

  final JoystickStepCallback onStep;

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  static const double _size = JoystickTheme.baseRadius * 2;

  Offset _knobOffset = Offset.zero;
  Direction? _heldDirection;
  double _intensity = 0;
  Timer? _repeatTimer;

  void _onPanUpdate(DragUpdateDetails details) {
    const center = Offset(_size / 2, _size / 2);
    final raw = details.localPosition - center;
    final clamped = raw.distance > JoystickTheme.baseRadius
        ? raw * (JoystickTheme.baseRadius / raw.distance)
        : raw;
    setState(() => _knobOffset = clamped);
    _updateHeld(_directionFor(clamped), _intensityFor(clamped));
  }

  Direction? _directionFor(Offset offset) {
    if (offset.distance < JoystickTheme.deadZone) return null;
    final degrees = offset.direction * 180 / math.pi;
    if (degrees >= -45 && degrees < 45) return Direction.east;
    if (degrees >= 45 && degrees < 135) return Direction.south;
    if (degrees >= -135 && degrees < -45) return Direction.north;
    return Direction.west;
  }

  // 0 right at the dead zone edge, 1 at full deflection.
  double _intensityFor(Offset offset) {
    final usable = JoystickTheme.baseRadius - JoystickTheme.deadZone;
    if (usable <= 0) return 1;
    final pushed = (offset.distance - JoystickTheme.deadZone).clamp(0.0, usable);
    return pushed / usable;
  }

  void _updateHeld(Direction? direction, double intensity) {
    _intensity = intensity;
    if (direction == _heldDirection) return;
    _heldDirection = direction;
    _repeatTimer?.cancel();
    _repeatTimer = null;
    if (direction != null) _fireStep();
  }

  // Reschedules itself with a fresh interval each time, rather than a fixed
  // Timer.periodic, so the repeat rate keeps tracking the current intensity
  // even while the knob stays pushed in the same direction.
  void _fireStep() {
    final direction = _heldDirection;
    if (direction == null) return;
    widget.onStep(direction, _intensity);
    _repeatTimer = Timer(_intervalFor(_intensity), _fireStep);
  }

  Duration _intervalFor(double intensity) {
    final slow = JoystickTheme.stepIntervalSlow.inMicroseconds;
    final fast = JoystickTheme.stepIntervalFast.inMicroseconds;
    return Duration(microseconds: (slow + (fast - slow) * intensity).round());
  }

  void _onPanEnd([Object? _]) {
    _updateHeld(null, 0);
    setState(() => _knobOffset = Offset.zero);
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanEnd,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: JoystickTheme.baseColor,
          border: Border.all(color: JoystickTheme.borderColor, width: 2),
        ),
        child: Center(
          child: Transform.translate(
            offset: _knobOffset,
            child: Container(
              width: JoystickTheme.knobDiameter,
              height: JoystickTheme.knobDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: JoystickTheme.knobColor,
                boxShadow: [
                  BoxShadow(
                    color: JoystickTheme.knobGlow,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
