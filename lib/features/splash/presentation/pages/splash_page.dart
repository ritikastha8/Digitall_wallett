import 'package:digital_wallett_system/app/routes/app_routes.dart';
import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/pages/bottom_pages/bottomnavigation_screen.dart';
import 'package:digital_wallett_system/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _navigateNext();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
  }

  void _startAnimations() {
    _scaleController.forward();
    _fadeController.forward();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final session = ref.read(userSessionServiceProvider);
    if (session.isLoggedIn()) {
      AppRoutes.pushReplacement(context, const BottomnavigationScreen());
    } else if (session.getHasSeenOnboarding()) {
      AppRoutes.pushReplacement(context, const LoginPage());
    } else {
      AppRoutes.pushReplacement(context, const OnboardingPage());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // old splash background
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo (like old splash)
                  SvgPicture.asset(
                    "assets/images/logonovacash.svg",
                    height: 140,
                  ),
                  const SizedBox(height: 24),

                  // App name
                  Text(
                    "NovaCash",
                    style: TextStyle(
                      fontFamily: 'Great Vibes',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Your Smart Digital Wallet",
                    style: TextStyle(
                      fontSize: 14,
                      color: context.textSecondary.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
