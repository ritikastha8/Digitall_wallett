// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:digital_wallett_system/core/errors/failures.dart';
// import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
// import 'package:digital_wallett_system/features/feedback/data/datasources/remote/feedback_remote_datasource.dart';
// import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
// import 'package:digital_wallett_system/features/feedback/domain/repositories/feedback_repository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final feedbackRepositoryProvider = Provider<IFeedbackRepository>((ref) {
//   final remoteDatasource = ref.read(feedbackRemoteDatasourceProvider);
//   final networkInfo = ref.read(networkInfoProvider);
//   return FeedbackRepository(
//     remoteDatasource: remoteDatasource,
//     networkInfo: networkInfo,
//   );
// });

// class FeedbackRepository implements IFeedbackRepository {
//   final FeedbackRemoteDatasource _remoteDatasource;
//   final NetworkInfo _networkInfo;

//   FeedbackRepository({
//     required FeedbackRemoteDatasource remoteDatasource,
//     required NetworkInfo networkInfo,
//   }) : _remoteDatasource = remoteDatasource,
//        _networkInfo = networkInfo;

//   @override
//   Future<Either<Failure, FeedbackEntity>> createFeedback({
//     required String feedback,
//     required String futureImprovements,
//   }) async {
//     if (!await _networkInfo.isConnected) {
//       return const Left(ApiFailure(message: 'No internet connection'));
//     }

//     try {
//       final created = await _remoteDatasource.createFeedback(
//         feedback: feedback,
//         futureImprovements: futureImprovements,
//       );
//       return Right(created.toEntity());
//     } on DioException catch (e) {
//       return Left(
//         ApiFailure(
//           message: e.response?.data is Map
//               ? (e.response!.data['message'] ?? e.message ?? 'Submit failed')
//               : (e.message ?? 'Submit failed'),
//           statusCode: e.response?.statusCode,
//         ),
//       );
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/feedback/data/datasources/local/feedback_local_datasource.dart';
import 'package:digital_wallett_system/features/feedback/data/datasources/remote/feedback_remote_datasource.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:digital_wallett_system/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackRepositoryProvider = Provider<IFeedbackRepository>((ref) {
  final remoteDatasource = ref.read(feedbackRemoteDatasourceProvider);
  final localDatasource = ref.read(feedbackLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return FeedbackRepository(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
    networkInfo: networkInfo,
  );
});

class FeedbackRepository implements IFeedbackRepository {
  final FeedbackRemoteDatasource _remoteDatasource;
  final FeedbackLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  FeedbackRepository({
    required FeedbackRemoteDatasource remoteDatasource,
    required FeedbackLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacks() async {
    if (!await _networkInfo.isConnected) {
      final cached = _localDatasource.getCachedFeedbacks();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left(
        ApiFailure(message: 'No internet connection and no cached feedback'),
      );
    }
    try {
      final list = await _remoteDatasource.getFeedbacks();
      final entities = list.map((e) => e.toEntity()).toList();
      await _localDatasource.cacheFeedbacks(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to load feedback'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FeedbackEntity>> createFeedback({
    required String feedback,
    required String futureImprovements,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final created = await _remoteDatasource.createFeedback(
        feedback: feedback,
        futureImprovements: futureImprovements,
      );
      final entity = created.toEntity();

      // Update local cache
      final current = _localDatasource.getCachedFeedbacks();
      final next = [entity, ...current.where((e) => e.id != entity.id)];
      await _localDatasource.cacheFeedbacks(next);

      return Right(entity);
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to submit feedback'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FeedbackEntity>> updateFeedback({
    required String id,
    required String feedback,
    required String futureImprovements,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final updated = await _remoteDatasource.updateFeedback(
        id: id,
        feedback: feedback,
        futureImprovements: futureImprovements,
      );
      final entity = updated.toEntity();

      // Update local cache
      final next = _localDatasource
          .getCachedFeedbacks()
          .map((item) => item.id == id ? entity : item)
          .toList();
      await _localDatasource.cacheFeedbacks(next);

      return Right(entity);
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to update feedback'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFeedback(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      await _remoteDatasource.deleteFeedback(id);

      // Update local cache
      final next = _localDatasource
          .getCachedFeedbacks()
          .where((item) => item.id != id)
          .toList();
      await _localDatasource.cacheFeedbacks(next);

      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e, 'Failed to delete feedback'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  /// Helper to clean up Dio error handling
  Failure _handleDioError(DioException e, String defaultMessage) {
    return ApiFailure(
      message: e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message ?? defaultMessage)
          : (e.message ?? defaultMessage),
      statusCode: e.response?.statusCode,
    );
  }
}
