import 'package:flutter/material.dart';

import '../game/board/board_theme.dart';
import '../game/levels/level_grid.dart';
import '../game/levels/level_info.dart';
import '../game/levels/level_progress_store.dart';
import '../game/levels/level_title_banner.dart';
import 'maze_screen.dart';

/// Level-select screen, matching the user's reference mockup. Loads stars
/// from [LevelProgressStore] to build the real 20-level catalog via
/// [buildLevels], and reloads them whenever a play session returns here, so
/// newly-earned stars/unlocks show up immediately. Single page, no
/// pagination dots yet.
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  late Future<Map<int, int>> _starsFuture;

  @override
  void initState() {
    super.initState();
    _starsFuture = LevelProgressStore.loadStars(levelCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BoardTheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/floor.png', fit: BoxFit.cover),
          const ColoredBox(color: BoardTheme.floorDarkenColor),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<Map<int, int>>(
                future: _starsFuture,
                builder: (context, snapshot) {
                  final levels = buildLevels(snapshot.data ?? const {});
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: const SizedBox(
                                height: 90, child: LevelTitleBanner())),
                        const SizedBox(height: 24),
                        LevelGrid(
                          levels: levels,
                          onLevelTap: (level) => _openLevel(context, level),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLevel(BuildContext context, LevelInfo level) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MazeScreen(level: level)),
    );
    setState(() {
      _starsFuture = LevelProgressStore.loadStars(levelCount);
    });
  }
}
