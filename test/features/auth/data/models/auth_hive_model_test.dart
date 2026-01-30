import 'package:flutter_test/flutter_test.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthHiveModel Tests', () {
    test('constructor generates authId when null', () {
      final model = AuthHiveModel(
        fullName: 'Ritika',
        mobileNumber: '9800000000',
      );

      expect(model.authId, isNotNull);
    });

    test('fromEntity creates hive model correctly', () {
      final entity = AuthEntity(
        authId: '1',
        fullName: 'Ritika',
        mobileNumber: '9800000000',
        password: '1234',
        profilePicture: 'img.png',
      );

      final model = AuthHiveModel.fromEntity(entity);

      expect(model.authId, entity.authId);
      expect(model.fullName, entity.fullName);
      expect(model.mobileNumber, entity.mobileNumber);
      expect(model.password, entity.password);
      expect(model.profilePicture, entity.profilePicture);
    });

    test('toEntity converts hive model to entity', () {
      final model = AuthHiveModel(
        authId: '1',
        fullName: 'Ritika',
        mobileNumber: '9800000000',
        password: '1234',
        profilePicture: 'img.png',
      );

      final entity = model.toEntity();

      expect(entity.authId, model.authId);
      expect(entity.fullName, model.fullName);
      expect(entity.mobileNumber, model.mobileNumber);
      expect(entity.password, model.password);
      expect(entity.profilePicture, model.profilePicture);
    });

    test('toEntityList converts hive model list correctly', () {
      final models = [
        AuthHiveModel(fullName: 'User1', mobileNumber: '111'),
        AuthHiveModel(fullName: 'User2', mobileNumber: '222'),
      ];

      final entities = AuthHiveModel.toEntityList(models);

      expect(entities.length, 2);
      expect(entities.first.fullName, 'User1');
      expect(entities.last.fullName, 'User2');
    });
  });
}
