import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/onboarding_item.dart';
import '../widgets/dot_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  int _pageIndex = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: SvgPicture.asset("assets/images/onboardingmanagemoney.svg"),
      title: 'Manage Money Easily ',
      description:
          'Check wallet balance, load money, and track transactions instantly. ',
    ),
    OnboardingItem(
      image: SvgPicture.asset("assets/images/onboardingQR.svg"),
      title: 'Fast & Easy Payments',
      description:
          'Transfer money to anyone or scan QR codes for quick payments.',
    ),
    OnboardingItem(
      image: SvgPicture.asset("assets/images/onboardingsafe.svg"),
      title: ' Safe & Secure',
      description:
          'Wallet is protected with PIN, encryption, and secure login.',
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_pageIndex == _items.length - 1) {
      ref.read(userSessionServiceProvider).setHasSeenOnboarding(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (_, index) {
                  final item = _items[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight = constraints.maxHeight;
                      final maxWidth = constraints.maxWidth;

                      final minSide = maxHeight < maxWidth
                          ? maxHeight
                          : maxWidth;

                      // Responsive image height: 30-40% of screen height
                      double imageHeight = maxHeight * 0.35;
                      if (imageHeight > 300) imageHeight = 300;

                      // Responsive title font
                      double titleFontSize = minSide * 0.08;
                      if (titleFontSize > 28) titleFontSize = 28;

                      // Responsive description font
                      double descriptionFontSize = minSide * 0.045;
                      if (descriptionFontSize > 18) descriptionFontSize = 18;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: imageHeight, child: item.image),
                          const SizedBox(height: 32),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: descriptionFontSize,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            Row(
              children: [
                ...List.generate(
                  _items.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: DotIndicator(isActive: index == _pageIndex),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.black,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
