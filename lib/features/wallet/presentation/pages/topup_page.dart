import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/wallet/data/repositories/wallet_repository.dart';
import 'package:digital_wallett_system/features/wallet/presentation/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopupPage extends ConsumerStatefulWidget {
  const TopupPage({super.key});

  @override
  ConsumerState<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends ConsumerState<TopupPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _amountController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(walletRepositoryProvider);
    final mobile = _mobileController.text.trim();
    if (mobile.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mobile number not found')));
      }
      setState(() => _loading = false);
      return;
    }
    final result = await repo.topup(
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      mobileNumber: mobile,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {
        ref.read(walletViewModelProvider.notifier).loadBalance();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Topup successful')));
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topup', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(hintText: 'Your mobile number', filled: true, fillColor: AppColors.inputFill, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
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
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Topup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
