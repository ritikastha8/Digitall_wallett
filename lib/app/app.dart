import 'package:digital_wallett_system/app/routes/app_navigator.dart';
import 'package:digital_wallett_system/app/theme/theme_provider.dart';
import 'package:digital_wallett_system/core/services/sensors/sensor_controller.dart';
import 'package:flutter/material.dart';
import 'package:digital_wallett_system/app/theme/app_theme.dart';
import 'package:digital_wallett_system/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Digital Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) => SensorController(
        navigatorKey: appNavigatorKey,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const SplashPage(),
    );
  }
}
