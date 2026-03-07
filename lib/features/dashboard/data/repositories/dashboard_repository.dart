import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:digital_wallett_system/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
import 'package:digital_wallett_system/features/dashboard/data/datasources/remote/dashboard_remote_datasource.dart';
// import 'package:digital_wallett_system/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:digital_wallett_system/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider<DDashboardRepository>((ref) {
  final dashboardDatasource = ref.read(dashboardLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final DashboardRemoteDatasource = ref.read(dashboardRemoteDatasourceProvider);
  return DashboardRepository(
    dashboardDatasource: dashboardDatasource,
    dashboardRemoteDataSource: DashboardRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class DashboardRepository implements DDashboardRepository {
  final DDashboardDataSource _dashboardDataSource;
  final DDashboardRemoteDataSource _dashboardRemoteDataSource;
  final NetworkInfo _networkInfo;
  DashboardRepository({
    required DDashboardDataSource dashboardDatasource,
    required DDashboardRemoteDataSource dashboardRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _dashboardDataSource = dashboardDatasource,
       _dashboardRemoteDataSource = dashboardRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    // remote ma matrai insert huna paryo
    if (await _networkInfo.isConnected) {
      try {
        final model = await _dashboardRemoteDataSource.uploadImage(image);
        return Right(model.media ?? '');
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }
}
