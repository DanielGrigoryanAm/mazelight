import 'package:flutter/material.dart';

import 'level_select_theme.dart';

/// "LEVELS" title: the same carved-stone frame art as the wide reference
/// banner, with the caption overlaid on top.
class LevelTitleBanner extends StatelessWidget {
  const LevelTitleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/title_frame.png', fit: BoxFit.contain),
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            'LEVELS',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: LevelSelectTheme.titleColor,
              shadows: [
                Shadow(
                  color: Color(0xFF2A1B10),
                  offset: Offset(0, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
