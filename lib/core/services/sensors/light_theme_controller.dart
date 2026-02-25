import 'dart:async';

import 'package:digital_wallett_system/app/theme/theme_provider.dart';
import 'package:digital_wallett_system/core/services/sensors/light_sensor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LightThemeController extends ConsumerStatefulWidget {
  final Widget child;

  const LightThemeController({super.key, required this.child});

  @override
  ConsumerState<LightThemeController> createState() =>
      _LightThemeControllerState();
}

class _LightThemeControllerState extends ConsumerState<LightThemeController> {
  static const double _darkLuxThreshold = 20;
  static const double _brightLuxThreshold = 60;

  StreamSubscription<double>? _lightSensorSubscription;

  @override
  void initState() {
    super.initState();
    _lightSensorSubscription = LightSensorService.luxStream.listen(
      _syncThemeFromLight,
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _lightSensorSubscription?.cancel();
    super.dispose();
  }

  void _syncThemeFromLight(double lux) {
    final isLightSensorThemeEnabled = ref.read(lightSensorThemeEnabledProvider);
    if (!isLightSensorThemeEnabled) return;

    final notifier = ref.read(themeModeProvider.notifier);
    final currentTheme = ref.read(themeModeProvider);

    if (lux <= _darkLuxThreshold && currentTheme != ThemeMode.dark) {
      unawaited(notifier.setThemeModeFromLightSensor(ThemeMode.dark));
      return;
    }

    if (lux >= _brightLuxThreshold && currentTheme != ThemeMode.light) {
      unawaited(notifier.setThemeModeFromLightSensor(ThemeMode.light));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
