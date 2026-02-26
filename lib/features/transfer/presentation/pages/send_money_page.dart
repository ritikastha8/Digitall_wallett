import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/transfer/presentation/state/transfer_state.dart';
import 'package:digital_wallett_system/features/transfer/presentation/view_model/transfer_view_model.dart';
import 'package:digital_wallett_system/features/wallet/presentation/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendMoneyPage extends ConsumerStatefulWidget {
  final String? initialMobile;
  final double? initialAmount;

  const SendMoneyPage({super.key, this.initialMobile, this.initialAmount});

  @override
  ConsumerState<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends ConsumerState<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _mobileController;
  late final TextEditingController _amountController;
  final _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.initialMobile ?? '');
    _amountController = TextEditingController(text: widget.initialAmount != null ? widget.initialAmount.toString() : '');
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(transferViewModelProvider.notifier);
    final success = await notifier.sendMoney(
      recipientMobile: _mobileController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      remarks: _remarksController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      await ref.read(walletViewModelProvider.notifier).loadBalance();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer successful')),
      );
      notifier.reset();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transferState = ref.watch(transferViewModelProvider);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    ref.listen<TransferState>(transferViewModelProvider, (prev, next) {
      if (next.status == TransferStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Send Money', style: TextStyle(color: Colors.black)),
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
                const SizedBox(height: 24),
                Text(
                  'Recipient mobile number',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter mobile number';
                    if (v.length != 10) return 'Mobile number must be 10 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Amount (NPR)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter amount';
                    final amount = double.tryParse(v);
                    if (amount == null || amount <= 0) return 'Amount must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Remarks (optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 2,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Add a note',
                    filled: true,
                    fillColor: AppColors.inputFill,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: transferState.status == TransferStatus.loading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: transferState.status == TransferStatus.loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Send Money'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
