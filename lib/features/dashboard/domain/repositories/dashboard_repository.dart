import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/dashboard/domain/entities/dashboard_entity.dart';

abstract interface class DDashboardRepository {
  // Future<Either<Failure, List<DashboardEntity>>> getAllItems();
  // Future<Either<Failure, List<DashboardEntity>>> getItemsByUser(String userId);
  // Future<Either<Failure, List<DashboardEntity>>> getLostItems();
  // Future<Either<Failure, List<DashboardEntity>>> getFoundItems();
  // Future<Either<Failure, List<DashboardEntity>>> getItemsByCategory(
  //   String categoryId,
  // );
  // Future<Either<Failure, DashboardEntity>> getItemById(String itemId);
  // Future<Either<Failure, bool>> createItem(DashboardEntity item);
  // Future<Either<Failure, bool>> updateItem(DashboardEntity item);
  // Future<Either<Failure, bool>> deleteItem(String itemId);
  // image upload
  Future<Either<Failure, String>> uploadImage(File image);
}
