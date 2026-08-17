import 'package:flutter/material.dart';

import 'level_info.dart';
import 'level_select_theme.dart';
import 'stars_row.dart';

typedef LevelTapCallback = void Function(LevelInfo level);

/// One tile in the level grid. A locked cell shows only the padlock frame
/// (which already carries its own border art); an unlocked cell shows its
/// frame — the glowing variant if [LevelInfo.isCurrent] — plus the level
/// number and earned stars.
class LevelCell extends StatelessWidget {
  const LevelCell({super.key, required this.level, this.onTap});

  final LevelInfo level;
  final LevelTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: level.locked ? null : () => onTap?.call(level),
      child: level.locked ? _lockedFrame() : _unlockedFrame(),
    );
  }

  Widget _lockedFrame() {
    return Image.asset('assets/images/lock_frame.png', fit: BoxFit.contain);
  }

  Widget _unlockedFrame() {
    final frameAsset = level.isCurrent
        ? 'assets/images/level_frame_selected.png'
        : 'assets/images/level_frame.png';
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(frameAsset, fit: BoxFit.contain),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${level.number}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: LevelSelectTheme.numberColor,
                shadows: [
                  Shadow(
                    color: LevelSelectTheme.numberShadow,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            StarsRow(count: level.stars),
          ],
        ),
      ],
    );
  }
}
