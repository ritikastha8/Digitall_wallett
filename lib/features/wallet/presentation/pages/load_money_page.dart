import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/wallet/data/repositories/wallet_repository.dart';
import 'package:digital_wallett_system/features/wallet/presentation/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadMoneyPage extends ConsumerStatefulWidget {
  const LoadMoneyPage({super.key});

  @override
  ConsumerState<LoadMoneyPage> createState() => _LoadMoneyPageState();
}

class _LoadMoneyPageState extends ConsumerState<LoadMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(walletRepositoryProvider);
    final result = await repo.loadMoney(
      mobileNumber: _mobileController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      remarks: _remarksController.text.trim().isEmpty ? null : _remarksController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {
        ref.read(walletViewModelProvider.notifier).loadBalance();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Money loaded successfully')));
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Money', style: TextStyle(color: Colors.black)),
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
                const Text('Bank mobile number', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(hintText: '10 digits', filled: true, fillColor: AppColors.inputFill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : v.length != 10 ? '10 digits' : null,
                ),
                const SizedBox(height: 24),
                const Text('Amount (NPR)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  decoration: InputDecoration(hintText: 'Amount', filled: true, fillColor: AppColors.inputFill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final a = double.tryParse(v);
                    return (a == null || a < 1) ? 'Min 1' : null;
                  },
                ),
                const SizedBox(height: 24),
                const Text('Remarks (optional)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _remarksController,
                  decoration: InputDecoration(hintText: 'Note', filled: true, fillColor: AppColors.inputFill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Load Money'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
