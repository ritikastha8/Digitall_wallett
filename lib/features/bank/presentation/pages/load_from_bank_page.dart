import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/bank/presentation/state/bank_state.dart';
import 'package:digital_wallett_system/features/bank/presentation/view_model/bank_view_model.dart';
import 'package:digital_wallett_system/features/wallet/presentation/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadFromBankPage extends ConsumerStatefulWidget {
  const LoadFromBankPage({super.key});

  @override
  ConsumerState<LoadFromBankPage> createState() => _LoadFromBankPageState();
}

class _LoadFromBankPageState extends ConsumerState<LoadFromBankPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await ref.read(bankViewModelProvider.notifier).loadFromBank(
      accountNumber: _accountController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
    );
    if (!mounted) return;
    if (error != null) return;
    ref.read(walletViewModelProvider.notifier).loadBalance();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Money loaded from bank')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bankState = ref.watch(bankViewModelProvider);
    final loading = bankState.status == BankStatus.loading;
    final error = bankState.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Load from Bank',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Load money from your linked bank account using account number.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _accountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(20)],
                  decoration: InputDecoration(
                    labelText: 'Account number',
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Required';
                    if (s.length < 6) return 'At least 6 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  decoration: InputDecoration(
                    labelText: 'Amount (NPR)',
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final a = double.tryParse(v);
                    return (a == null || a < 1) ? 'Min 1' : null;
                  },
                ),
                if (error != null) ...[
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: AppColors.error, fontSize: 14)),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: loading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Load from bank'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
