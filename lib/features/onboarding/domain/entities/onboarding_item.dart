import 'package:flutter_svg/svg.dart';

class OnboardingItem {
  final SvgPicture image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
