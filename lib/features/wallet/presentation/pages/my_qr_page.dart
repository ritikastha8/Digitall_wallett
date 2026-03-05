import 'dart:convert';

import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/wallet/data/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyQrPage extends ConsumerStatefulWidget {
  const MyQrPage({super.key});

  @override
  ConsumerState<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends ConsumerState<MyQrPage> {
  bool _loading = true;
  String? _error;
  String? _payload;
  String? _mobileNumber;
  String? _name;
  double? _amount;
  String? _qrImageBase64;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final result = await ref.read(walletRepositoryProvider).getReceiveQr();
    if (!mounted) return;
    result.fold(
      (f) => setState(() { _loading = false; _error = f.message; }),
      (entity) => setState(() {
        _loading = false;
        _payload = entity.payload;
        _mobileNumber = entity.mobileNumber;
        _name = entity.name;
        _amount = entity.amount;
        _qrImageBase64 = entity.qrImageBase64;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My QR', style: TextStyle(color: Colors.black)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My QR', style: TextStyle(color: Colors.black)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                TextButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_qrImageBase64 != null && _qrImageBase64!.isNotEmpty) ...[
              _buildQrImage(),
              const SizedBox(height: 24),
            ],
            if (_name != null && _name!.isNotEmpty) Text(_name!, style: Theme.of(context).textTheme.titleMedium),
            if (_mobileNumber != null && _mobileNumber!.isNotEmpty) Text(_mobileNumber!, style: Theme.of(context).textTheme.bodyLarge),
            if (_amount != null && _amount! > 0) Text('NPR ${_amount!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
            if (_payload != null && _payload!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SelectableText(_payload!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrImage() {
    String base64 = _qrImageBase64!;
    if (base64.startsWith('data:image')) {
      final comma = base64.indexOf(',');
      if (comma != -1) base64 = base64.substring(comma + 1);
    }
    try {
      final bytes = base64Decode(base64);
      return Image.memory(bytes, height: 280, width: 280, fit: BoxFit.contain);
    } catch (_) {
      return Container(
        height: 280,
        width: 280,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.qr_code, size: 120)),
      );
    }
  }
}
