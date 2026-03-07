import 'package:digital_wallett_system/core/services/hive/hive_service.dart';
import 'package:digital_wallett_system/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardLocalDatasourceProvider = Provider<DashboardLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return DashboardLocalDatasource(hiveService: hiveService);
});

class DashboardLocalDatasource implements DDashboardDataSource {
  final HiveService _hiveService;

  DashboardLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;
}
