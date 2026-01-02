import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 16 : 6,
      width: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
