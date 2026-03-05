import 'package:digital_wallett_system/features/terms/domain/usecases/get_terms_usecase.dart';
import 'package:digital_wallett_system/features/terms/presentation/state/terms_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termsViewModelProvider = NotifierProvider<TermsViewModel, TermsState>(
  TermsViewModel.new,
);

class TermsViewModel extends Notifier<TermsState> {
  late final GetTermsUsecase _getTermsUsecase;

  @override
  TermsState build() {
    _getTermsUsecase = ref.read(getTermsUsecaseProvider);
    return const TermsState();
  }

  Future<void> loadTerms() async {
    state = state.copyWith(status: TermsStatus.loading, errorMessage: null);
    final result = await _getTermsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: TermsStatus.error,
          errorMessage: failure.message,
        );
      },
      (list) {
        state = state.copyWith(
          status: TermsStatus.loaded,
          terms: list,
          errorMessage: null,
        );
      },
    );
  }
}
