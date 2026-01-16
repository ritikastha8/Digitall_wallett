import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage/storage_service.dart';

// ====================== WALLET STORAGE PROVIDER ======================

/// Must be overridden in main.dart before runApp()
final walletStorageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('walletStorageServiceProvider must be overridden');
});
