import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';
import 'package:digital_wallett_system/core/constants/hive_table_constant.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // ======================= INIT =========================
  Future<void> init() async {
    if (kIsWeb) {
      // Web: no filesystem path; Hive uses IndexedDB via initFlutter()
      await Hive.initFlutter();
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${HiveTableConstant.dbName}';
      Hive.init(path);
    }

    _registerAdapters();
    await _openBoxes();
  }

  // ======================= ADAPTERS =========================
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  // ======================= OPEN BOXES =========================
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
  }

  // ======================= CLOSE HIVE =========================
  Future<void> close() async {
    await Hive.close();
  }

  // ======================= USER QUERIES =========================
  Box<AuthHiveModel> get _userBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  // Register user
  Future<AuthHiveModel> registerUser(AuthHiveModel user) async {
    await _userBox.put(user.authId, user);
    return user;
  }

  // Login
  AuthHiveModel? loginUser(String mobileNumber, String password) {
    // try {
    //   return _userBox.values.firstWhere(
    //     (user) =>
    //         user.mobileNumber == mobileNumber && user.password == password,
    //         orElse: () => null,
    //   );

    // } catch (e) {
    //   return null;
    // }

    try {
      return _userBox.values.firstWhere(
        (user) =>
            user.mobileNumber == mobileNumber && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Get user by ID
  AuthHiveModel? getUserById(String authId) {
    return _userBox.get(authId);
  }

  // Get user by mobile number
  AuthHiveModel? getUserByMobile(String mobileNumber) {
    try {
      return _userBox.values.firstWhere(
        (user) => user.mobileNumber == mobileNumber,
      );
    } catch (e) {
      return null;
    }
  }

  // Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (_userBox.containsKey(user.authId)) {
      await _userBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  // Delete user
  Future<void> deleteUser(String authId) async {
    await _userBox.delete(authId);
  }

  // // Check if mobile number already exists
  // bool isMobileNumberExists(String mobileNumber) {
  //   return _userBox.values.any((user) => user.mobileNumber == mobileNumber);
  // }
}
