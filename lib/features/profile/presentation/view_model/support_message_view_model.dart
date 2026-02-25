import 'package:digital_wallett_system/features/profile/domain/usecases/create_support_message_usecase.dart';
import 'package:digital_wallett_system/features/profile/domain/usecases/delete_support_message_usecase.dart';
import 'package:digital_wallett_system/features/profile/domain/usecases/get_support_messages_usecase.dart';
import 'package:digital_wallett_system/features/profile/domain/usecases/update_support_message_usecase.dart';
import 'package:digital_wallett_system/features/profile/presentation/state/support_message_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supportMessageViewModelProvider =
    NotifierProvider<SupportMessageViewModel, SupportMessageState>(
      SupportMessageViewModel.new,
    );

class SupportMessageViewModel extends Notifier<SupportMessageState> {
  late final GetSupportMessagesUsecase _getSupportMessagesUsecase;
  late final CreateSupportMessageUsecase _createSupportMessageUsecase;
  late final UpdateSupportMessageUsecase _updateSupportMessageUsecase;
  late final DeleteSupportMessageUsecase _deleteSupportMessageUsecase;

  @override
  SupportMessageState build() {
    _getSupportMessagesUsecase = ref.read(getSupportMessagesUsecaseProvider);
    _createSupportMessageUsecase = ref.read(createSupportMessageUsecaseProvider);
    _updateSupportMessageUsecase = ref.read(updateSupportMessageUsecaseProvider);
    _deleteSupportMessageUsecase = ref.read(deleteSupportMessageUsecaseProvider);
    return const SupportMessageState();
  }

  Future<void> loadMessages() async {
    state = state.copyWith(status: SupportMessageStatus.loading);
    final result = await _getSupportMessagesUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupportMessageStatus.error,
          errorMessage: failure.message,
        );
      },
      (messages) {
        state = state.copyWith(
          status: SupportMessageStatus.loaded,
          messages: messages,
          errorMessage: null,
        );
      },
    );
  }

  Future<String?> createMessage(String message) async {
    state = state.copyWith(status: SupportMessageStatus.submitting);
    final result = await _createSupportMessageUsecase(
      CreateSupportMessageParams(message: message),
    );
    return result.fold((failure) {
      state = state.copyWith(
        status: SupportMessageStatus.error,
        errorMessage: failure.message,
      );
      return failure.message;
    }, (created) {
      final updatedList = [created, ...state.messages];
      state = state.copyWith(
        status: SupportMessageStatus.loaded,
        messages: updatedList,
        errorMessage: null,
      );
      return null;
    });
  }

  Future<String?> updateMessage({
    required String id,
    required String message,
  }) async {
    state = state.copyWith(status: SupportMessageStatus.submitting);
    final result = await _updateSupportMessageUsecase(
      UpdateSupportMessageParams(id: id, message: message),
    );
    return result.fold((failure) {
      state = state.copyWith(
        status: SupportMessageStatus.error,
        errorMessage: failure.message,
      );
      return failure.message;
    }, (updated) {
      final updatedList = state.messages
          .map((item) => item.id == id ? updated : item)
          .toList();
      state = state.copyWith(
        status: SupportMessageStatus.loaded,
        messages: updatedList,
        errorMessage: null,
      );
      return null;
    });
  }

  Future<String?> deleteMessage(String id) async {
    state = state.copyWith(status: SupportMessageStatus.submitting);
    final result = await _deleteSupportMessageUsecase(
      DeleteSupportMessageParams(id: id),
    );
    return result.fold((failure) {
      state = state.copyWith(
        status: SupportMessageStatus.error,
        errorMessage: failure.message,
      );
      return failure.message;
    }, (_) {
      final updatedList = state.messages.where((item) => item.id != id).toList();
      state = state.copyWith(
        status: SupportMessageStatus.loaded,
        messages: updatedList,
        errorMessage: null,
      );
      return null;
    });
  }
}
