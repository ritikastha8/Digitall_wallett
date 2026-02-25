import 'package:digital_wallett_system/core/services/sensors/accelerometer_controller.dart';
import 'package:digital_wallett_system/core/services/sensors/light_theme_controller.dart';
import 'package:flutter/material.dart';

class SensorController extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const SensorController({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return LightThemeController(
      child: AccelerometerController(navigatorKey: navigatorKey, child: child),
    );
  }
}
