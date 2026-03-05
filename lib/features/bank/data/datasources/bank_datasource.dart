import 'package:digital_wallett_system/features/bank/data/models/bank_api_model.dart';

abstract interface class IBankRemoteDatasource {
  Future<void> seedBank();
  Future<BankApiModel> linkBank({
    required String accountNumber,
    required String password,
  });
  Future<void> loadFromBank({
    required String accountNumber,
    required double amount,
  });
}
