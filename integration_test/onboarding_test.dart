import 'package:digital_wallett_system/core/services/hive/hive_service.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:digital_wallett_system/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & Splash Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('Splash Page Integration Tests', () {
      Widget createSplashPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: SplashPage()),
        );
      }

      testWidgets('Splash page should display', (tester) async {
        await tester.pumpWidget(createSplashPage());

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('NovaCash'), findsOneWidget);
      });

      testWidgets('Splash page should contain app branding', (tester) async {
        await tester.pumpWidget(createSplashPage());

        expect(find.text('Your Smart Digital Wallet'), findsOneWidget);
      });
    });

    group('Onboarding Page Integration Tests', () {
      Widget createOnboardingPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: OnboardingPage()),
        );
      }

      testWidgets('Onboarding page should display', (tester) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Onboarding page should have PageView', (tester) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('Onboarding page should have dot indicators and next button', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsWidgets);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('Onboarding page should be swipeable', (tester) async {
        await tester.pumpWidget(createOnboardingPage());
        await tester.pumpAndSettle();

        final pageView = find.byType(PageView);
        expect(pageView, findsOneWidget);

        await tester.drag(pageView, const Offset(-300, 0));
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });
    });
  });
}
