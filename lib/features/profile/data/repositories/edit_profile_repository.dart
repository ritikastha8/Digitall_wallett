import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/profile/data/datasources/local/edit_profile_local_datasource.dart';
import 'package:digital_wallett_system/features/profile/data/datasources/remote/edit_profile_remote_datasource.dart';
import 'package:digital_wallett_system/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:digital_wallett_system/features/profile/domain/repositories/edit_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileRepositoryProvider = Provider<IEditProfileRepository>((ref) {
  final remoteDatasource = ref.read(editProfileRemoteDatasourceProvider);
  final localDatasource = ref.read(editProfileLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return EditProfileRepository(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class EditProfileRepository implements IEditProfileRepository {
  final EditProfileRemoteDatasource _remoteDatasource;
  final EditProfileLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;
  final UserSessionService _userSession;

  EditProfileRepository({
    required EditProfileRemoteDatasource remoteDatasource,
    required EditProfileLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
    required UserSessionService userSession,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _networkInfo = networkInfo,
       _userSession = userSession;

  @override
  Future<Either<Failure, EditProfileEntity>> updateProfile({
    required String fullName,
    required String mobileNumber,
    String? imagePath,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final apiModel = await _remoteDatasource.updateProfile(
        fullName: fullName,
        mobileNumber: mobileNumber,
        userId: _userSession.getCurrentUserId(),
        imagePath: imagePath,
      );

      await _localDatasource.cacheProfile(apiModel.toEntity());

      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Failed to update profile';
      if (responseData is Map && responseData['message'] != null) {
        message = responseData['message'].toString();
      } else if (responseData is String && responseData.trim().isNotEmpty) {
        message = responseData.contains('Cannot PUT')
            ? 'Update endpoint not found on server (PUT)'
            : responseData;
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }
      return Left(
        ApiFailure(
          message: message,
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
