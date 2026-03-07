import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // // Base URL
  // static const String baseUrl = 'http://10.0.2.2:5050/api';
  // // static const String baseUrl = 'http://192.168.1.64:5000/api/v1';
  // static const Duration connectionTimeout = Duration(seconds: 30);
  // static const Duration receiveTimeout = Duration(seconds: 30);

  /// Optional override: when set, baseUrl and imageBaseUrll use this instead of platform defaults.
  /// Build release with: flutter build apk --dart-define=API_BASE_URL=https://your-api.com
  /// (URL can include /api or not; /api is appended for baseUrl if missing.)
  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const bool isPhysicalDevice = false;
  static const String compIpAddress = "192.168.1.72";
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) {
      final url = _envBaseUrl.trim();
      return url.endsWith('/api') ? url : '$url/api';
    }
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:5052/api';
    }
    if (kIsWeb) {
      return 'http://localhost:5052/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5052/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:5052/api';
    } else {
      return 'http://localhost:5052/api';
    }
  }

  static String get imageBaseUrll {
    if (_envBaseUrl.isNotEmpty) {
      final url = _envBaseUrl.trim();
      return url.endsWith('/api') ? url.replaceFirst('/api', '') : url;
    }
    if (isPhysicalDevice) return 'http://$compIpAddress:5052';
    if (kIsWeb) return 'http://localhost:5052';
    if (Platform.isAndroid) return 'http://10.0.2.2:5052';
    if (Platform.isIOS) return 'http://localhost:5052';
    return 'http://localhost:5052';
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String register = '/user/auth/register';
  static const String login = '/user/auth/login';
  static String userById(String id) => '/user/auth/$id';

  static String profileUploadPhoto = '/user/auth/upload-profile';

  static const String requestPasswordReset =
      '/user/auth/request-password-reset';
  static String resetPassword(String token) =>
      '/user/auth/reset-password/$token';
  static const String changePassword = '/user/auth/change-password';
  static const String whoami = '/user/auth/whoami';
  static const String setPin = '/user/auth/set-pin';

  // ============ Wallet Endpoints ============
  /// GET /api/user/wallet/info → { "success": true, "data": { "balance", "bank" } }
  static const String walletBalance = '/user/wallet/info';

  /// POST /api/user/wallet/transfer body: { "toMobileNumber", "amount", "remarks" }
  static const String transfer = '/user/wallet/transfer';

  /// GET receive QR: ?amount=100 optional
  static const String receiveQr = '/user/wallet/receive-qr';

  /// POST load from linked bank: { "mobileNumber", "amount", "remarks" }
  static const String walletLoad = '/user/wallet/load';

  /// POST topup: { "amount" }
  static const String walletTopup = '/user/wallet/topup';

  /// POST link bank: { "accountNumber", "password" }
  static const String walletLinkBank = '/user/wallet/link-bank';

  /// POST verify bank: { "mobileNumber", "password" }
  static const String walletLoginBank = '/user/wallet/loginbank';

  // ============ Bank ============
  static const String bankBase = '/user/bank';
  static const String bankSeed = '$bankBase/seed';
  static const String bankLink = '$bankBase/link';
  static const String bankLoad = '$bankBase/load';

  // ============ Transactions ============
  static const String myTransactions = '/user/transactions/my-transactions';
  static const String transactionLog = '/user/transactions/log';
  static String transactionById(String id) => '/user/transactions/$id';

  // ============ Notifications ============
  static const String notificationsList = '/user/notifications';

  // ============ Terms & conditions ============
  static const String termsList = '/user/termsconditions';

  // ============ Admin ============
  static const String adminUsers = '/admin/users';
  static const String adminNotifications = '/admin/notifications';
  static const String adminTerms = '/admin/termsconditions';

  // ============ Support Messages ============
  static const String supportMessages = '/user/support-messages';
  static String supportMessageById(String id) => '/user/support-messages/$id';

  // ============ Support Messages ============
  static const String shareFeedback = '/user/share-feedback';
  static String shareFeedbackById(String id) => '/user/share-feedback/$id';
}
