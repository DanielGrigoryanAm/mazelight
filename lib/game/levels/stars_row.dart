import 'package:flutter/material.dart';

/// Row of three star icons — [count] of them lit, the rest dimmed.
class StarsRow extends StatelessWidget {
  const StarsRow({super.key, required this.count, this.size = 16});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Opacity(
              opacity: i < count ? 1 : 0.25,
              child: Image.asset(
                'assets/images/star_icon.png',
                width: size,
                height: size,
              ),
            ),
          ),
      ],
    );
  }
}
