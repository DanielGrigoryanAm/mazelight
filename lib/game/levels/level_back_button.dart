import 'package:flutter/material.dart';

/// Back button using the same carved-stone frame art as the level cells;
/// pops the current route if there's somewhere to go back to.
class LevelBackButton extends StatelessWidget {
  const LevelBackButton({super.key});

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Image.asset(
        'assets/images/back_button.png',
        width: _size,
        height: _size,
        fit: BoxFit.contain,
      ),
    );
  }
}
