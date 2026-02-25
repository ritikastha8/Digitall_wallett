import 'dart:async';
import 'dart:math';

import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wallett_system/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/pages/bottom_pages/bottomnavigation_screen.dart';
import 'package:digital_wallett_system/features/transfer/presentation/pages/send_money_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/load_money_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/my_qr_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/qr_scanner_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/topup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

typedef _PageFactory = Widget Function();

class AccelerometerController extends ConsumerStatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const AccelerometerController({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  ConsumerState<AccelerometerController> createState() =>
      _AccelerometerControllerState();
}

class _AccelerometerControllerState
    extends ConsumerState<AccelerometerController> {
  static const double _tiltThreshold = 6.5;
  static const Duration _tiltCooldown = Duration(milliseconds: 900);
  static const Duration _shakeWindow = Duration(milliseconds: 900);
  static const Duration _shakeCooldown = Duration(seconds: 3);
  static const double _shakeDeltaThreshold = 14.5;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastTiltAt = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastShakeAt = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? _firstShakeSpikeAt;
  int _shakeSpikeCount = 0;
  double? _lastAccelerationMagnitude;
  int _currentSequenceIndex = 0;

  late final List<_PageFactory> _pageSequence = <_PageFactory>[
    () => const BottomnavigationScreen(initialIndex: 0),
    () => const LoadMoneyPage(),
    () => const SendMoneyPage(),
    () => const TopupPage(),
    () => const MyQrPage(),
    () => const QrScannerPage(),
    () => const BottomnavigationScreen(initialIndex: 1),
    () => const BottomnavigationScreen(initialIndex: 2),
  ];

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEventStream().listen(
      _handleAccelerometerEvent,
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  bool _canHandleMotionActions() {
    final session = ref.read(userSessionServiceProvider);
    return session.isLoggedIn();
  }

  void _handleAccelerometerEvent(AccelerometerEvent event) {
    if (!_canHandleMotionActions()) return;

    _handleTiltNavigation(event.x);
    _handleShakeLogout(event);
  }

  void _handleTiltNavigation(double xAxis) {
    final now = DateTime.now();
    if (now.difference(_lastTiltAt) < _tiltCooldown) return;

    if (xAxis <= -_tiltThreshold) {
      _lastTiltAt = now;
      _moveToNextPage();
      return;
    }

    if (xAxis >= _tiltThreshold) {
      _lastTiltAt = now;
      _moveToPreviousPage();
    }
  }

  void _handleShakeLogout(AccelerometerEvent event) {
    final now = DateTime.now();
    if (now.difference(_lastShakeAt) < _shakeCooldown) return;

    final magnitude = sqrt(
      (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
    );
    final previousMagnitude = _lastAccelerationMagnitude;
    _lastAccelerationMagnitude = magnitude;
    if (previousMagnitude == null) return;

    final delta = (magnitude - previousMagnitude).abs();
    if (delta < _shakeDeltaThreshold) return;

    if (_firstShakeSpikeAt == null ||
        now.difference(_firstShakeSpikeAt!) > _shakeWindow) {
      _firstShakeSpikeAt = now;
      _shakeSpikeCount = 1;
      return;
    }

    _shakeSpikeCount += 1;
    if (_shakeSpikeCount >= 2) {
      _firstShakeSpikeAt = null;
      _shakeSpikeCount = 0;
      _lastShakeAt = now;
      _logoutFromShake();
    }
  }

  Future<void> _moveToNextPage() async {
    if (_currentSequenceIndex >= _pageSequence.length - 1) return;
    _currentSequenceIndex += 1;
    await _replaceWithCurrentSequencePage();
  }

  Future<void> _moveToPreviousPage() async {
    if (_currentSequenceIndex <= 0) return;
    _currentSequenceIndex -= 1;
    await _replaceWithCurrentSequencePage();
  }

  Future<void> _replaceWithCurrentSequencePage() async {
    final navigator = widget.navigatorKey.currentState;
    if (navigator == null) return;

    await navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => _pageSequence[_currentSequenceIndex]()),
    );
  }

  Future<void> _logoutFromShake() async {
    await ref.read(authViewModelProvider.notifier).logout();
    _currentSequenceIndex = 0;

    final navigator = widget.navigatorKey.currentState;
    if (navigator == null) return;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
