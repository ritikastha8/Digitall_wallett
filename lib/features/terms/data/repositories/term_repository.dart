import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/terms/data/datasources/local/term_local_datasource.dart';
import 'package:digital_wallett_system/features/terms/data/datasources/remote/term_remote_datasource.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:digital_wallett_system/features/terms/domain/repositories/term_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termRepositoryProvider = Provider<ITermRepository>((ref) {
  final remoteDatasource = ref.read(termRemoteDatasourceProvider);
  final localDatasource = ref.read(termLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return TermRepository(
    termLocalDatasource: localDatasource,
    termRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class TermRepository implements ITermRepository {
  final TermLocalDatasource _termLocalDatasource;
  final ITermRemoteDatasource _termRemoteDatasource;
  final NetworkInfo _networkInfo;

  TermRepository({
    required TermLocalDatasource termLocalDatasource,
    required ITermRemoteDatasource termRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _termLocalDatasource = termLocalDatasource,
       _termRemoteDatasource = termRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<TermEntity>>> getTerms() async {
    if (!await _networkInfo.isConnected) {
      final cached = _termLocalDatasource.getCachedTerms();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left(
        ApiFailure(message: 'No internet connection and no cached terms'),
      );
    }
    try {
      final list = await _termRemoteDatasource.getTerms();
      await _termLocalDatasource.cacheTerms(list);
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ??
                    e.message ??
                    'Failed to load terms')
              : (e.message ?? 'Failed to load terms'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

}
