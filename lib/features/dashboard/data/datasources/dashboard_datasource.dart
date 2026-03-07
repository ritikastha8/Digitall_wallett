import 'dart:io';
import 'package:digital_wallett_system/features/dashboard/data/models/dashboard_api_model.dart';

/// Interface for local storage operations
abstract interface class DDashboardDataSource {
  // Future<DashboardHiveModel?> getUserInfo();
  // Future<double?> getWalletBalance();
  // Future<bool> updateUserInfo(DashboardHiveModel user);
  // Future<bool> deleteUserInfo();
}

/// Interface for remote/backend operations
abstract interface class DDashboardRemoteDataSource {
  // Future<DashboardApiModel?> getUserInfo(String userId);
  // Future<double?> getWalletBalance(String userId);
  Future<DashboardApiModel> uploadImage(File image);
  // Future<bool> uploadVideo(File video);
}
