import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/profile/data/datasources/edit_profile_datasource.dart';
import 'package:digital_wallett_system/features/profile/data/models/edit_profile_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileRemoteDatasourceProvider = Provider<EditProfileRemoteDatasource>(
  (ref) {
    final apiClient = ref.read(apiClientProvider);
    return EditProfileRemoteDatasource(apiClient: apiClient);
  },
);

class EditProfileRemoteDatasource implements EditProfileDatasource {
  final ApiClient _apiClient;

  EditProfileRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<EditProfileApiModel> updateProfile({
    required String fullName,
    required String mobileNumber,
    required String? userId,
    String? imagePath,
  }) async {
    String? uploadedProfilePath;

    if (imagePath != null && imagePath.isNotEmpty) {
      final uploadFormData = FormData.fromMap({
        'profilePhoto': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });
      try {
        final uploadResponse = await _apiClient.uploadFile(
          ApiEndpoints.profileUploadPhoto,
          formData: uploadFormData,
          options: Options(contentType: 'multipart/form-data'),
        );
        uploadedProfilePath = _extractProfilePath(uploadResponse.data);
      } catch (_) {}
    }

    final Map<String, dynamic> data = {
      'name': fullName,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
    };
    if (uploadedProfilePath != null && uploadedProfilePath.isNotEmpty) {
      data['imageUrl'] = uploadedProfilePath;
    }

    Future<FormData> buildFormData() async {
      final map = Map<String, dynamic>.from(data);
      if (imagePath != null && imagePath.isNotEmpty) {
        map['profilePhoto'] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }
      return FormData.fromMap(map);
    }

    Response<dynamic>? response;
    final endpoints = <String>[
      '/user/auth/update-profile',
      '/user/auth/updateProfile',
      if (userId != null && userId.isNotEmpty) '/user/auth/update-profile/$userId',
      if (userId != null && userId.isNotEmpty) '/user/auth/updateProfile/$userId',
    ];
    final methods = <String>['PUT', 'PATCH'];
    final multipartOptions = Options(contentType: 'multipart/form-data');

    for (final endpoint in endpoints) {
      for (final method in methods) {
        try {
          response = method == 'PUT'
              ? await _apiClient.put(
                  endpoint,
                  data: await buildFormData(),
                  options: multipartOptions,
                )
              : await _apiClient.dio.patch(
                  endpoint,
                  data: await buildFormData(),
                  options: multipartOptions,
                );
          break;
        } on DioException catch (e) {
          if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
            continue;
          }
          rethrow;
        }
      }
      if (response != null) break;
    }

    if (response == null) {
      if (uploadedProfilePath != null && uploadedProfilePath.isNotEmpty) {
        return EditProfileApiModel(
          fullName: fullName,
          mobileNumber: mobileNumber,
          profilePicture: uploadedProfilePath,
        );
      }
      throw DioException(
        requestOptions: RequestOptions(path: endpoints.join(', ')),
        message: 'Update profile endpoint not found on server',
      );
    }

    final responseData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    final updatedUser = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : responseData;

    String resolvedFullName =
        (updatedUser['fullName'] ?? updatedUser['name'])?.toString() ??
        fullName;
    String resolvedMobileNumber =
        updatedUser['mobileNumber']?.toString() ?? mobileNumber;
    String? resolvedProfilePicture = _extractProfilePath(updatedUser);

    if (resolvedProfilePicture == null || resolvedProfilePicture.isEmpty) {
      try {
        final whoamiResponse = await _apiClient.get(ApiEndpoints.whoami);
        final whoamiData = whoamiResponse.data is Map<String, dynamic>
            ? whoamiResponse.data as Map<String, dynamic>
            : <String, dynamic>{};
        final whoamiUser = whoamiData['data'] is Map<String, dynamic>
            ? whoamiData['data'] as Map<String, dynamic>
            : whoamiData;
        resolvedProfilePicture = _extractProfilePath(whoamiUser);
        resolvedFullName =
            (whoamiUser['fullName'] ?? whoamiUser['name'])?.toString() ??
            resolvedFullName;
        resolvedMobileNumber =
            whoamiUser['mobileNumber']?.toString() ?? resolvedMobileNumber;
      } catch (_) {}
    }

    return EditProfileApiModel(
      fullName: resolvedFullName,
      mobileNumber: resolvedMobileNumber,
      profilePicture: resolvedProfilePicture,
    );
  }

  String? _extractProfilePath(dynamic source) {
    if (source is String) {
      return source;
    }
    if (source is Map<String, dynamic>) {
      return (source['imageUrl'] ??
              source['profilePhoto'] ??
              source['profilePicture'] ??
              source['path'] ??
              source['image'])
          ?.toString();
    }
    return null;
  }
}

