import 'package:flutter/material.dart';

class OnboardContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        double imageHeight = maxHeight * 0.4;
        if (imageHeight > 350) imageHeight = 350;

        double titleFontSize = maxWidth * 0.08;
        if (titleFontSize > 32) titleFontSize = 32;

        double descFontSize = maxWidth * 0.05;
        if (descFontSize > 20) descFontSize = 20;

        return Column(
          children: [
            const Spacer(),
            Image.asset(image, height: imageHeight),
            const SizedBox(height: 24),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: descFontSize),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
