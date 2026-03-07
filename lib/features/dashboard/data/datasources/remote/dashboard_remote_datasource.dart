import 'dart:io';

import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/core/services/storage/token_service.dart';
import 'package:digital_wallett_system/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:digital_wallett_system/features/dashboard/data/models/dashboard_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRemoteDatasourceProvider = Provider<DDashboardRemoteDataSource>((
  ref,
) {
  return DashboardRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class DashboardRemoteDatasource implements DDashboardRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  DashboardRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<DashboardApiModel> uploadImage(File image) async {
    // path => c:asd/asd/a.jpg , asd asd means just a folder name ; then take only the name of the image file
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'profilePhoto': await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    // get token from token service
    final token = _tokenService.getToken();

    final response = await _apiClient.uploadFile(
      ApiEndpoints.profileUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        return DashboardApiModel.fromJson(inner);
      }
      if (inner != null) {
        return DashboardApiModel(media: inner.toString());
      }
    }
    return const DashboardApiModel();
  }
}
