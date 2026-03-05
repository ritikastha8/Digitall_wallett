import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:equatable/equatable.dart';

enum TermsStatus {
  initial,
  loading,
  loaded,
  error,
}

class TermsState extends Equatable {
  final TermsStatus status;
  final List<TermEntity> terms;
  final String? errorMessage;

  const TermsState({
    this.status = TermsStatus.initial,
    this.terms = const [],
    this.errorMessage,
  });

  TermsState copyWith({
    TermsStatus? status,
    List<TermEntity>? terms,
    String? errorMessage,
  }) {
    return TermsState(
      status: status ?? this.status,
      terms: terms ?? this.terms,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, terms, errorMessage];
}
