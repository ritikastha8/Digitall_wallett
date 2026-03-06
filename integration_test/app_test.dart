import 'package:digital_wallett_system/app/app.dart';
import 'package:digital_wallett_system/core/services/hive/hive_service.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createApp() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MyApp(),
      );
    }

    testWidgets('App should start with splash screen', (tester) async {
      await tester.pumpWidget(createApp());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('NovaCash'), findsOneWidget);
    });

    testWidgets('App should navigate from splash after delay', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
