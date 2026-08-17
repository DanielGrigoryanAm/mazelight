import 'package:flutter/material.dart';

import '../board/board_theme.dart';
import 'level_info.dart';
import 'stars_row.dart';

/// Modal shown when the player reaches the maze exit. Purely presentational
/// — navigation is up to the caller via [onNextLevel]/[onBackToLevels].
class WinDialog extends StatelessWidget {
  const WinDialog({
    super.key,
    required this.level,
    required this.stars,
    required this.hasNextLevel,
    required this.onNextLevel,
    required this.onBackToLevels,
  });

  final LevelInfo level;
  final int stars;
  final bool hasNextLevel;
  final VoidCallback onNextLevel;
  final VoidCallback onBackToLevels;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
        decoration: BoxDecoration(
          color: BoardTheme.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7A5A3A), width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'LEVEL COMPLETE',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Color(0xFFE8C89A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Level ${level.number}',
              style: const TextStyle(fontSize: 15, color: Color(0xFFBFA98A)),
            ),
            const SizedBox(height: 18),
            StarsRow(count: stars, size: 40),
            const SizedBox(height: 26),
            _DialogButton(
              label: hasNextLevel ? 'NEXT LEVEL' : 'DONE',
              onTap: hasNextLevel ? onNextLevel : onBackToLevels,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onBackToLevels,
              child: const Text(
                'Back to levels',
                style: TextStyle(color: Color(0xFFBFA98A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2ECC55),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }
}
