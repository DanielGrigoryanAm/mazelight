import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/controls/joystick_dock.dart';
import '../game/levels/level_back_button.dart';
import '../game/levels/level_info.dart';
import '../game/levels/level_progress_store.dart';
import '../game/levels/win_dialog.dart';
import '../game/maze_game.dart';
import '../maze/maze_generator.dart';

/// Plays a single [LevelInfo]: its board size and seed decide the maze.
/// Reaching the exit saves stars to [LevelProgressStore] and shows
/// [WinDialog].
class MazeScreen extends StatelessWidget {
  const MazeScreen({super.key, required this.level});

  final LevelInfo level;

  @override
  Widget build(BuildContext context) {
    final maze = MazeGenerator(
      rows: level.rows,
      cols: level.cols,
      seed: level.seed,
    ).generate();
    final game = MazeGame(maze: maze, onWin: (stars) => _handleWin(context, stars));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: GameWidget(game: game)),
              JoystickDock(onStep: game.movePlayer),
            ],
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: LevelBackButton(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleWin(BuildContext context, int stars) async {
    await LevelProgressStore.saveStars(level.number, stars);
    if (!context.mounted) return;

    final hasNextLevel = level.number < levelCount;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => WinDialog(
        level: level,
        stars: stars,
        hasNextLevel: hasNextLevel,
        onNextLevel: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MazeScreen(level: levelInfoFor(level.number + 1)),
            ),
          );
        },
        onBackToLevels: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}
