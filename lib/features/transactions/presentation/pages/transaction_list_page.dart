import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/presentation/state/transaction_list_state.dart';
import 'package:digital_wallett_system/features/transactions/presentation/view_model/transaction_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  const TransactionListPage({super.key});

  @override
  ConsumerState<TransactionListPage> createState() =>
      _TransactionListPageState();
}

class _TransactionListPageState extends ConsumerState<TransactionListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionListViewModelProvider.notifier).loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionListViewModelProvider);
    final notifier = ref.read(transactionListViewModelProvider.notifier);

    if (state.status == TransactionListStatus.loading &&
        state.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TransactionListStatus.error &&
        state.transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => notifier.loadTransactions(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadTransactions(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: state.transactions.length,
        itemBuilder: (context, index) {
          final tx = state.transactions[index];
          return _TransactionTile(
            transaction: tx,
            onEditRemarks: () => _showEditRemarksDialog(tx),
            onDelete: () => _confirmDelete(tx),
          );
        },
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  Future<void> _showEditRemarksDialog(TransactionEntity tx) async {
    final txId = tx.id;
    if (txId == null || txId.isEmpty) {
      _showMessage('Cannot edit this transaction', isError: true);
      return;
    }

    final controller = TextEditingController(text: tx.remarks ?? '');
    final nextRemarks = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Remarks'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Remarks',
              hintText: 'Enter remarks',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (nextRemarks == null) return;

    final notifier = ref.read(transactionListViewModelProvider.notifier);
    final error = await notifier.updateTransactionRemarks(
      id: txId,
      remarks: nextRemarks,
    );

    if (error != null) {
      _showMessage(error, isError: true);
      return;
    }
    _showMessage('Remarks updated');
  }

  Future<void> _confirmDelete(TransactionEntity tx) async {
    final txId = tx.id;
    if (txId == null || txId.isEmpty) {
      _showMessage('Cannot delete this transaction', isError: true);
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: const Text(
            'Are you sure you want to delete this transaction?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final notifier = ref.read(transactionListViewModelProvider.notifier);
    final error = await notifier.deleteTransactionById(txId);

    if (error != null) {
      _showMessage(error, isError: true);
      return;
    }
    _showMessage('Transaction deleted');
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onEditRemarks;
  final VoidCallback onDelete;

  const _TransactionTile({
    required this.transaction,
    required this.onEditRemarks,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final type = transaction.type.toLowerCase();
    final isTopup = type.contains('topup');
    final isSend = type.contains('send');
    final isOutgoing =
        isTopup ||
        isSend ||
        (transaction.toMobileNumber != null &&
            transaction.toMobileNumber!.isNotEmpty);
    final txColor = isTopup
        ? Colors.blue
        : (isOutgoing ? AppColors.error : AppColors.success);
    final subtitle =
        transaction.toMobileNumber != null &&
            transaction.toMobileNumber!.isNotEmpty
        ? 'To: ${transaction.toMobileNumber}'
        : (transaction.mobileNumber ?? transaction.remarks ?? transaction.type);
    final dateStr = transaction.createdAt != null
        ? '${transaction.createdAt!.day}/${transaction.createdAt!.month}/${transaction.createdAt!.year}'
        : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: txColor.withValues(alpha: 0.2),
          child: Icon(
            isOutgoing ? Icons.arrow_upward : Icons.arrow_downward,
            color: txColor,
          ),
        ),
        title: Text(
          transaction.type,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$subtitle${dateStr.isNotEmpty ? ' - $dateStr' : ''}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'NPR ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: txColor),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit_remarks') {
                  onEditRemarks();
                  return;
                }
                if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'edit_remarks',
                  child: Text('Edit remarks'),
                ),
                PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
