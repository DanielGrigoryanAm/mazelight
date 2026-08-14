import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/controls/joystick_dock.dart';
import '../game/maze_game.dart';
import '../maze/maze_generator.dart';

/// Temporary screen for visually verifying board rendering.
/// Will be replaced by the real level flow in a later stage.
class MazeScreen extends StatelessWidget {
  const MazeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maze = MazeGenerator(rows: 7, cols: 7, seed: 1).generate();
    final game = MazeGame(maze: maze);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(child: GameWidget(game: game)),
          JoystickDock(onStep: game.movePlayer),
        ],
      ),
    );
  }
}
