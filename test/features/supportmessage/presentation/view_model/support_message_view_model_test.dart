import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/entities/support_message_entity.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/usecases/create_support_message_usecase.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/usecases/delete_support_message_usecase.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/usecases/get_support_messages_usecase.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/usecases/update_support_message_usecase.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/presentation/state/support_message_state.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/presentation/view_model/support_message_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSupportMessagesUsecase extends Mock
    implements GetSupportMessagesUsecase {}

class MockCreateSupportMessageUsecase extends Mock
    implements CreateSupportMessageUsecase {}

class MockUpdateSupportMessageUsecase extends Mock
    implements UpdateSupportMessageUsecase {}

class MockDeleteSupportMessageUsecase extends Mock
    implements DeleteSupportMessageUsecase {}

void main() {
  late MockGetSupportMessagesUsecase mockGet;
  late MockCreateSupportMessageUsecase mockCreate;
  late MockUpdateSupportMessageUsecase mockUpdate;
  late MockDeleteSupportMessageUsecase mockDelete;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const CreateSupportMessageParams(message: 'message'));
    registerFallbackValue(
      const UpdateSupportMessageParams(id: '1', message: 'message'),
    );
    registerFallbackValue(const DeleteSupportMessageParams(id: '1'));
  });

  setUp(() {
    mockGet = MockGetSupportMessagesUsecase();
    mockCreate = MockCreateSupportMessageUsecase();
    mockUpdate = MockUpdateSupportMessageUsecase();
    mockDelete = MockDeleteSupportMessageUsecase();
    container = ProviderContainer(
      overrides: [
        getSupportMessagesUsecaseProvider.overrideWithValue(mockGet),
        createSupportMessageUsecaseProvider.overrideWithValue(mockCreate),
        updateSupportMessageUsecaseProvider.overrideWithValue(mockUpdate),
        deleteSupportMessageUsecaseProvider.overrideWithValue(mockDelete),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SupportMessageViewModel', () {
    const oldMessage = SupportMessageEntity(id: '1', message: 'Old');
    const updatedMessage = SupportMessageEntity(id: '1', message: 'Updated');
    const createdMessage = SupportMessageEntity(id: '2', message: 'Created');

    test('build returns initial state', () {
      final state = container.read(supportMessageViewModelProvider);
      expect(state.status, SupportMessageStatus.initial);
      expect(state.messages, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('loadMessages success sets loaded state', () async {
      when(() => mockGet()).thenAnswer((_) async => const Right([oldMessage]));

      await container
          .read(supportMessageViewModelProvider.notifier)
          .loadMessages();

      final state = container.read(supportMessageViewModelProvider);
      expect(state.status, SupportMessageStatus.loaded);
      expect(state.messages, [oldMessage]);
    });

    test('loadMessages failure sets error state', () async {
      when(
        () => mockGet(),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Load failed')));

      await container
          .read(supportMessageViewModelProvider.notifier)
          .loadMessages();

      final state = container.read(supportMessageViewModelProvider);
      expect(state.status, SupportMessageStatus.error);
      expect(state.errorMessage, 'Load failed');
    });

    test('createMessage success adds message', () async {
      when(
        () => mockCreate(any()),
      ).thenAnswer((_) async => const Right(createdMessage));

      final error = await container
          .read(supportMessageViewModelProvider.notifier)
          .createMessage('Created');

      final state = container.read(supportMessageViewModelProvider);
      expect(error, isNull);
      expect(state.status, SupportMessageStatus.loaded);
      expect(state.messages.first.message, 'Created');
    });

    test('updateMessage success replaces message', () async {
      when(() => mockGet()).thenAnswer((_) async => const Right([oldMessage]));
      when(
        () => mockUpdate(any()),
      ).thenAnswer((_) async => const Right(updatedMessage));

      await container
          .read(supportMessageViewModelProvider.notifier)
          .loadMessages();
      final error = await container
          .read(supportMessageViewModelProvider.notifier)
          .updateMessage(id: '1', message: 'Updated');

      final state = container.read(supportMessageViewModelProvider);
      expect(error, isNull);
      expect(state.status, SupportMessageStatus.loaded);
      expect(state.messages.first.message, 'Updated');
    });

    test('deleteMessage success removes message', () async {
      when(() => mockGet()).thenAnswer((_) async => const Right([oldMessage]));
      when(() => mockDelete(any())).thenAnswer((_) async => const Right(null));

      await container
          .read(supportMessageViewModelProvider.notifier)
          .loadMessages();
      final error = await container
          .read(supportMessageViewModelProvider.notifier)
          .deleteMessage('1');

      final state = container.read(supportMessageViewModelProvider);
      expect(error, isNull);
      expect(state.status, SupportMessageStatus.loaded);
      expect(state.messages, isEmpty);
    });
  });
}
