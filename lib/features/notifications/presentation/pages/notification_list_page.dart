import 'dart:async';

import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/notifications/presentation/state/notification_state.dart';
import 'package:digital_wallett_system/features/notifications/presentation/view_model/notification_view_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationListPage extends ConsumerStatefulWidget {
  const NotificationListPage({super.key});

  @override
  ConsumerState<NotificationListPage> createState() =>
      _NotificationListPageState();
}

class _NotificationListPageState extends ConsumerState<NotificationListPage> {
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _listenConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).loadNotifications();
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
        ref.read(notificationViewModelProvider.notifier).loadNotifications();
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
    final state = ref.watch(notificationViewModelProvider);
    final list = state.notifications;
    final loading = state.status == NotificationStatus.loading;
    final error = state.errorMessage;

    if (loading && list.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null && list.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
        ),
        body: Center(
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
                    ref.read(notificationViewModelProvider.notifier).loadNotifications();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No notifications',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
                'Offline mode: showing cached notifications',
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return ref
                    .read(notificationViewModelProvider.notifier)
                    .loadNotifications();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final n = list[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        n.read
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        n.title ?? 'Notification',
                        style: TextStyle(
                          fontWeight: n.read
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                      subtitle: n.body != null ? Text(n.body!) : null,
                      isThreeLine: n.body != null && n.body!.isNotEmpty,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
