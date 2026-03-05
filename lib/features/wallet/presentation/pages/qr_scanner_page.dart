import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/transfer/presentation/pages/send_money_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final list = capture.barcodes;
    if (list.isEmpty) return;
    final raw = list.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    _hasScanned = true;
    _parseAndNavigate(raw);
  }

  void _parseAndNavigate(String raw) {
    String? mobile;
    double? amount;
    try {
      final uri = Uri.tryParse(raw);
      if (uri != null && uri.queryParameters.isNotEmpty) {
        mobile =
            uri.queryParameters['mobile'] ??
            uri.queryParameters['mobileNumber'] ??
            uri.queryParameters['toMobileNumber'];
        final a = uri.queryParameters['amount'] ?? uri.queryParameters['amt'];
        if (a != null) amount = double.tryParse(a);
      }
      if (mobile == null || mobile.isEmpty) {
        final match = RegExp(
          r'[?&](mobile|mobileNumber|toMobileNumber)=(\d+)',
        ).firstMatch(raw);
        if (match != null) mobile = match.group(2);
        final amtMatch = RegExp(r'[?&](amount|amt)=([\d.]+)').firstMatch(raw);
        if (amtMatch != null) amount = double.tryParse(amtMatch.group(2) ?? '');
      }
    } catch (_) {}
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SendMoneyPage(initialMobile: mobile, initialAmount: amount),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Scanner',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(controller: _controller, onDetect: _onDetect),
    );
  }
}
