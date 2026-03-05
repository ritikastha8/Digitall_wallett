import 'dart:async';

import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/terms/presentation/state/terms_state.dart';
import 'package:digital_wallett_system/features/terms/presentation/view_model/terms_view_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsPage extends ConsumerStatefulWidget {
  const TermsPage({super.key});

  @override
  ConsumerState<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends ConsumerState<TermsPage> {
  static const String _introTitle = 'WELCOME TO NOVACASH!';
  static const String _introBody =
      'By installing and registering in the NovaCash mobile app, you ("Customer") agree to be legally bound by these Terms and Conditions ("Terms"), which govern your use of the services provided by NovaCash Limited, a company incorporated under the laws of Nepal and licensed to operate as a Payment Service Provider (PSP), having its registered office at [Your Address] (hereinafter referred to as "NovaCash" or "NovaCash Wallet").';

  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _listenConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsViewModelProvider.notifier).loadTerms();
    });
  }

  Future<void> _listenConnectivity() async {
    final connectivity = Connectivity();
    final initial = await connectivity.checkConnectivity();
    if (!mounted) return;
    setState(() => _isOffline = initial.contains(ConnectivityResult.none));
    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (!mounted) return;
      final nowOffline = result.contains(ConnectivityResult.none);
      final wasOffline = _isOffline;
      setState(() => _isOffline = nowOffline);
      if (wasOffline && !nowOffline) {
        ref.read(termsViewModelProvider.notifier).loadTerms();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsViewModelProvider);
    final list = state.terms;
    final loading = state.status == TermsStatus.loading;
    final error = state.errorMessage;

    final visibleTerms = list
        .where(
          (t) =>
              (t.title != null && t.title!.trim().isNotEmpty) ||
              (t.content != null && t.content!.trim().isNotEmpty),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Condition',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          if (_isOffline)
            Container(
              width: double.infinity,
              color: Colors.amber.shade100,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Offline mode: showing cached terms and conditions',
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  _introTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _introBody,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: loading && list.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : error != null && list.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              ref.read(termsViewModelProvider.notifier).loadTerms();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : list.isEmpty
                ? Center(
                    child: Text(
                      'No terms available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: visibleTerms.length,
                    itemBuilder: (context, index) {
                      final term = visibleTerms[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (term.title != null)
                                Text(
                                  term.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (term.title != null) const SizedBox(height: 8),
                              if (term.content != null)
                                SelectableText(
                                  term.content!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
