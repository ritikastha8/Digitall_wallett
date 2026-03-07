import 'package:digital_wallett_system/features/auth/data/models/auth_api_model.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthApiModel Tests', () {
    test('toJson returns correct map', () {
      final model = AuthApiModel(
        fullName: 'Ritika',
        mobileNumber: '9800000000',
        email: "test12@gmail.com",
        password: '1234',
        profilePicture: 'img.png',
      );

      final result = model.toJson();

      expect(result['name'], 'Ritika');
      expect(result['mobileNumber'], '9800000000');
      expect(result['password'], '1234');
      expect(result['profilePicture'], 'img.png');
    });

    test('fromJson creates model correctly', () {
      final json = {
        '_id': '1',
        'name': 'Ritika',
        'mobileNumber': '9800000000',
        'profilePicture': 'img.png',
      };

      final model = AuthApiModel.fromJson(json);

      expect(model.id, '1');
      expect(model.fullName, 'Ritika');
      expect(model.mobileNumber, '9800000000');
      expect(model.profilePicture, 'img.png');
    });

    test('toEntity converts model to entity', () {
      final model = AuthApiModel(
        id: '1',
        fullName: 'Ritika',
        email: "test@gmail.com",
        mobileNumber: '9800000000',
        profilePicture: 'img.png',
      );

      final entity = model.toEntity();

      expect(entity.authId, '1');
      expect(entity.fullName, 'Ritika');
      expect(entity.mobileNumber, '9800000000');
      expect(entity.profilePicture, 'img.png');
    });

    test('fromEntity converts entity to model', () {
      final entity = AuthEntity(
        authId: '1',
        fullName: 'Ritika',
        mobileNumber: '9800000000',
        email: 'ritika@test.com',
        password: '1234',
        profilePicture: 'img.png',
      );

      final model = AuthApiModel.fromEntity(entity);

      expect(model.fullName, entity.fullName);
      expect(model.mobileNumber, entity.mobileNumber);
      expect(model.password, entity.password);
      expect(model.profilePicture, entity.profilePicture);
    });

    test('toEntityList converts model list to entity list', () {
      final models = [
        AuthApiModel(
          fullName: 'User1',
          mobileNumber: '111',
          email: 'user1@test.com',
        ),
        AuthApiModel(
          fullName: 'User2',
          mobileNumber: '222',
          email: 'user2@test.com',
        ),
      ];

      final entities = AuthApiModel.toEntityList(models);

      expect(entities.length, 2);
      expect(entities.first.fullName, 'User1');
      expect(entities.last.fullName, 'User2');
    });
  });
}
