import 'package:flutter/material.dart';
import 'package:mazelight/game/board/board_theme.dart';

import 'joystick_widget.dart';

/// Bottom control strip: the joystick rests on the same stone floor texture
/// (assets/images/floor.png) as the maze's own backdrop, darkened the same
/// way, so it reads as part of the dungeon floor rather than a plain UI bar.
class JoystickDock extends StatelessWidget {
  const JoystickDock({super.key, required this.onStep});

  final JoystickStepCallback onStep;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BoardTheme.wallSideColor.withAlpha(200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Center(
          child: JoystickWidget(onStep: onStep),
        ),
      ),
    );
  }
}
