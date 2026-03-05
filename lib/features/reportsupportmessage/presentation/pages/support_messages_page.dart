import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
import 'package:digital_wallett_system/core/utils/snackbar_utils.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/entities/support_message_entity.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/presentation/state/support_message_state.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/presentation/view_model/support_message_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportMessagesPage extends ConsumerStatefulWidget {
  const SupportMessagesPage({super.key});

  @override
  ConsumerState<SupportMessagesPage> createState() =>
      _SupportMessagesPageState();
}

class _SupportMessagesPageState extends ConsumerState<SupportMessagesPage> {
  final TextEditingController _messageController = TextEditingController();
  String? _editingMessageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supportMessageViewModelProvider.notifier).loadMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _saveMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final notifier = ref.read(supportMessageViewModelProvider.notifier);
    final error = _editingMessageId == null
        ? await notifier.createMessage(message)
        : await notifier.updateMessage(
            id: _editingMessageId!,
            message: message,
          );

    if (!mounted) return;
    if (error != null) {
      SnackbarUtils.showError(context, error);
      return;
    }

    SnackbarUtils.showSuccess(
      context,
      _editingMessageId == null ? 'Message sent' : 'Message updated',
    );
    setState(() {
      _editingMessageId = null;
      _messageController.clear();
    });
  }

  Future<void> _deleteMessage(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete message'),
          content: const Text('Do you want to delete this message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final error = await ref
        .read(supportMessageViewModelProvider.notifier)
        .deleteMessage(id);
    if (!mounted) return;
    if (error != null) {
      SnackbarUtils.showError(context, error);
      return;
    }
    SnackbarUtils.showSuccess(context, 'Message deleted');
    setState(() {
      if (_editingMessageId == id) {
        _editingMessageId = null;
        _messageController.clear();
      }
    });
  }

  void _startEdit(SupportMessageEntity message) {
    final id = message.id;
    if (id == null || id.trim().isEmpty) {
      SnackbarUtils.showError(context, 'Cannot edit this message');
      return;
    }
    setState(() {
      _editingMessageId = id;
      _messageController.text = message.message;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingMessageId = null;
      _messageController.clear();
    });
  }

  String _formatDate(DateTime date) {
    final month = _twoDigits(date.month);
    final day = _twoDigits(date.day);
    final hour = _twoDigits(date.hour);
    final minute = _twoDigits(date.minute);
    return '${date.year}-$month-$day $hour:$minute';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  void _showMessageDetails(SupportMessageEntity message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Message details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.message),
              const SizedBox(height: 12),
              Text(
                'Created: ${_formatDate(message.createdAt ?? DateTime.now())}',
                style: TextStyle(color: context.textSecondary, fontSize: 12),
              ),
              Text(
                'Updated: ${_formatDate(message.updatedAt ?? message.createdAt ?? DateTime.now())}',
                style: TextStyle(color: context.textSecondary, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supportMessageViewModelProvider);
    final isLoading = state.status == SupportMessageStatus.loading;
    final isSubmitting = state.status == SupportMessageStatus.submitting;
    final messages = state.messages;

    ref.listen<SupportMessageState>(supportMessageViewModelProvider, (
      prev,
      next,
    ) {
      if (!mounted) return;
      if (next.status == SupportMessageStatus.error &&
          next.errorMessage != null &&
          next.errorMessage!.trim().isNotEmpty &&
          prev?.errorMessage != next.errorMessage) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Report a Problem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your problem or message to admin...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isSubmitting ? null : _saveMessage,
                    icon: Icon(
                      _editingMessageId == null ? Icons.send : Icons.edit,
                    ),
                    label: Text(
                      _editingMessageId == null
                          ? 'Send message'
                          : 'Update message',
                    ),
                  ),
                ),
                if (_editingMessageId != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _cancelEdit,
                    child: const Text('Cancel'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: context.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: messages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Card(
                          child: ListTile(
                            onTap: () => _showMessageDetails(message),
                            title: Text(
                              message.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              'Updated: ${_formatDate(message.updatedAt ?? message.createdAt ?? DateTime.now())}',
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'view') {
                                  _showMessageDetails(message);
                                  return;
                                }
                                if (value == 'edit') {
                                  _startEdit(message);
                                  return;
                                }
                                if (value == 'delete') {
                                  final id = message.id;
                                  if (id == null || id.trim().isEmpty) {
                                    SnackbarUtils.showError(
                                      context,
                                      'Cannot delete this message',
                                    );
                                    return;
                                  }
                                  _deleteMessage(id);
                                }
                              },
                              itemBuilder: (context) {
                                return const [
                                  PopupMenuItem(
                                    value: 'view',
                                    child: Text('View'),
                                  ),
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ];
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
