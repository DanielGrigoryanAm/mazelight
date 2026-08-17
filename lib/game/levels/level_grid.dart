import 'package:flutter/material.dart';

import 'level_cell.dart';
import 'level_info.dart';
import 'level_select_theme.dart';

/// Grid of [LevelCell]s. Single page for now — no pagination — so it
/// scrolls if the level count overflows the screen.
class LevelGrid extends StatelessWidget {
  const LevelGrid({super.key, required this.levels, this.onLevelTap});

  final List<LevelInfo> levels;
  final LevelTapCallback? onLevelTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: LevelSelectTheme.columns,
        mainAxisSpacing: LevelSelectTheme.gridSpacing,
        crossAxisSpacing: LevelSelectTheme.gridSpacing,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) =>
          LevelCell(level: levels[index], onTap: onLevelTap),
    );
  }
}
