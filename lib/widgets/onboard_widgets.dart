import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.screenWidth = 400,
  });

  final bool isActive;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    double activeHeight = screenWidth * 0.04;
    double inactiveHeight = screenWidth * 0.015;
    double width = screenWidth * 0.015;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? activeHeight : inactiveHeight,
      width: width,
      decoration: BoxDecoration(
        color: isActive ? Colors.amber.withOpacity(0.7) : Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// class OnboardContent extends StatelessWidget {
//   const OnboardContent({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.description,
//   });

//   final String image;
//   final String title;
//   final String description;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double screenWidth = constraints.maxWidth;
//         final double screenHeight = constraints.maxHeight;

//         // Image height scales with screen height
//         double imageHeight = screenHeight * 0.4;
//         if (imageHeight > 350) imageHeight = 350;

//         // Title text scales with width
//         double titleFontSize = screenWidth * 0.08;
//         if (titleFontSize > 32) titleFontSize = 32;

//         double descriptionFontSize = screenWidth * 0.05;
//         if (descriptionFontSize > 20) descriptionFontSize = 20;

//         return Column(
//           children: [
//             const Spacer(),
//             Image.asset(image, height: imageHeight),
//             const SizedBox(height: 24),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: titleFontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               description,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: descriptionFontSize),
//             ),
//             const Spacer(),
//           ],
//         );
//       },
//     );
//   }
// }

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxHeight = constraints.maxHeight;
        final double maxWidth = constraints.maxWidth;

        // Image height: scale with maxSide but cap to 50% of total height
        final double maxSide = maxHeight > maxWidth ? maxHeight : maxWidth;
        double imageHeight = maxSide * 0.4;
        // Ensure image does not exceed 50% of the column height
        if (imageHeight > maxHeight * 0.5) imageHeight = maxHeight * 0.5;

        // Title and description scale with smaller side
        final double minSide = maxHeight < maxWidth ? maxHeight : maxWidth;
        double titleFontSize = minSide * 0.08;
        if (titleFontSize > 32) titleFontSize = 32;

        double descriptionFontSize = minSide * 0.05;
        if (descriptionFontSize > 20) descriptionFontSize = 20;

        return Column(
          children: [
            const Spacer(flex: 1),
            Image.asset(image, height: imageHeight),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: titleFontSize),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              // style: TextStyle(fontSize: descriptionFontSize),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: titleFontSize),
            ),
            const Spacer(flex: 1),
          ],
        );
      },
    );
  }
}
