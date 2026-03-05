// // import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
// // import 'package:digital_wallett_system/core/utils/snackbar_utils.dart';
// // import 'package:digital_wallett_system/features/feedback/presentation/state/feedback_state.dart';
// // import 'package:digital_wallett_system/features/feedback/presentation/view_model/feedback_view_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class ShareFeedbackPage extends ConsumerStatefulWidget {
// //   const ShareFeedbackPage({super.key});

// //   @override
// //   ConsumerState<ShareFeedbackPage> createState() => _ShareFeedbackPageState();
// // }

// // class _ShareFeedbackPageState extends ConsumerState<ShareFeedbackPage> {
// //   final TextEditingController _feedbackController = TextEditingController();
// //   final TextEditingController _improvementController = TextEditingController();

// //   @override
// //   void dispose() {
// //     _feedbackController.dispose();
// //     _improvementController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _submitFeedback() async {
// //     final feedback = _feedbackController.text.trim();
// //     final improvements = _improvementController.text.trim();

// //     if (feedback.isEmpty) {
// //       SnackbarUtils.showError(context, 'Please share your feedback');
// //       return;
// //     }

// //     if (improvements.isEmpty) {
// //       SnackbarUtils.showError(context, 'Please share future improvement ideas');
// //       return;
// //     }

// //     final error = await ref
// //         .read(feedbackViewModelProvider.notifier)
// //         .submitFeedback(feedback: feedback, futureImprovements: improvements);

// //     if (!mounted) return;
// //     if (error != null) {
// //       SnackbarUtils.showError(context, error);
// //       return;
// //     }

// //     _feedbackController.clear();
// //     _improvementController.clear();
// //     SnackbarUtils.showSuccess(context, 'Feedback shared successfully');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final state = ref.watch(feedbackViewModelProvider);
// //     final isSubmitting = state.status == FeedbackStatus.submitting;

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Share Feedback')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Container(
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: context.surfaceColor,
// //             borderRadius: BorderRadius.circular(16),
// //             boxShadow: context.cardShadow,
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'Help us improve',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w700,
// //                   color: context.textPrimary,
// //                 ),
// //               ),
// //               const SizedBox(height: 6),
// //               Text(
// //                 'Share your feedback and tell us what future improvements you want in this app.',
// //                 style: TextStyle(color: context.textSecondary),
// //               ),
// //               const SizedBox(height: 16),
// //               TextField(
// //                 controller: _feedbackController,
// //                 minLines: 4,
// //                 maxLines: 6,
// //                 decoration: InputDecoration(
// //                   hintText: 'What do you think about the app?',
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               TextField(
// //                 controller: _improvementController,
// //                 minLines: 4,
// //                 maxLines: 6,
// //                 decoration: InputDecoration(
// //                   hintText: 'What should we improve in future updates?',
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton.icon(
// //                   onPressed: isSubmitting ? null : _submitFeedback,
// //                   icon: const Icon(Icons.feedback_outlined),
// //                   label: Text(
// //                     isSubmitting ? 'Submitting...' : 'Share Feedback',
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
// import 'package:digital_wallett_system/core/utils/snackbar_utils.dart';
// import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
// import 'package:digital_wallett_system/features/feedback/presentation/state/feedback_state.dart';
// import 'package:digital_wallett_system/features/feedback/presentation/view_model/feedback_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ShareFeedbackPage extends ConsumerStatefulWidget {
//   const ShareFeedbackPage({super.key});

//   @override
//   ConsumerState<ShareFeedbackPage> createState() => _ShareFeedbackPageState();
// }

// class _ShareFeedbackPageState extends ConsumerState<ShareFeedbackPage> {
//   final TextEditingController _feedbackController = TextEditingController();
//   final TextEditingController _improvementController = TextEditingController();
//   String? _editingFeedbackId;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(feedbackViewModelProvider.notifier).loadFeedbacks();
//     });
//   }

//   @override
//   void dispose() {
//     _feedbackController.dispose();
//     _improvementController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveFeedback() async {
//     final feedback = _feedbackController.text.trim();
//     final improvements = _improvementController.text.trim();

//     if (feedback.isEmpty || improvements.isEmpty) {
//       SnackbarUtils.showError(context, 'Please fill in both fields');
//       return;
//     }

//     final notifier = ref.read(feedbackViewModelProvider.notifier);
//     final error = _editingFeedbackId == null
//         ? await notifier.submitFeedback(
//             feedback: feedback,
//             futureImprovements: improvements,
//           )
//         : await notifier.updateFeedback(
//             id: _editingFeedbackId!,
//             feedback: feedback,
//             futureImprovements: improvements,
//           );

//     if (!mounted) return;
//     if (error != null) {
//       SnackbarUtils.showError(context, error);
//       return;
//     }

//     SnackbarUtils.showSuccess(
//       context,
//       _editingFeedbackId == null ? 'Feedback shared' : 'Feedback updated',
//     );
//     _clearForm();
//   }

//   void _clearForm() {
//     setState(() {
//       _editingFeedbackId = null;
//       _feedbackController.clear();
//       _improvementController.clear();
//     });
//   }

//   Future<void> _deleteFeedback(String id) async {
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Feedback'),
//         content: const Text('Do you want to delete this feedback?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (result != true) return;

//     final error = await ref
//         .read(feedbackViewModelProvider.notifier)
//         .deleteFeedback(id);
//     if (!mounted) return;
//     if (error != null) {
//       SnackbarUtils.showError(context, error);
//       return;
//     }
//     SnackbarUtils.showSuccess(context, 'Feedback deleted');
//     if (_editingFeedbackId == id) _clearForm();
//   }

//   void _startEdit(FeedbackEntity item) {
//     setState(() {
//       _editingFeedbackId = item.id;
//       _feedbackController.text = item.feedback;
//       _improvementController.text = item.futureImprovements;
//     });
//   }

//   String _formatDate(DateTime date) {
//     final month = _twoDigits(date.month);
//     final day = _twoDigits(date.day);
//     final hour = _twoDigits(date.hour);
//     final minute = _twoDigits(date.minute);
//     return '${date.year}-$month-$day $hour:$minute';
//   }

//   String _twoDigits(int value) => value.toString().padLeft(2, '0');

//   void _showFeedbackDetails(FeedbackEntity message) {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Message details'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(message.feedback),
//               const SizedBox(height: 12),
//               Text(message.futureImprovements),
//               const SizedBox(height: 12),
//               Text(
//                 'Created: ${_formatDate(message.createdAt ?? DateTime.now())}',
//                 style: TextStyle(color: context.textSecondary, fontSize: 12),
//               ),
//               Text(
//                 'Updated: ${_formatDate(message.updatedAt ?? message.createdAt ?? DateTime.now())}',
//                 style: TextStyle(color: context.textSecondary, fontSize: 12),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(feedbackViewModelProvider);
//     final isSubmitting = state.status == FeedbackStatus.submitting;
//     final isLoading = state.status == FeedbackStatus.loading;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Feedback & Suggestions')),
//       body: Column(
//         children: [
//           // Input Section (Your Design)
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: context.surfaceColor,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: context.cardShadow,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _editingFeedbackId == null
//                         ? 'Help us improve'
//                         : 'Edit your feedback',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _feedbackController,
//                     minLines: 2,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: 'What do you think about the app?',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _improvementController,
//                     minLines: 2,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: 'Future improvement ideas...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: isSubmitting ? null : _saveFeedback,
//                           icon: Icon(
//                             _editingFeedbackId == null
//                                 ? Icons.send
//                                 : Icons.check,
//                           ),
//                           label: Text(
//                             _editingFeedbackId == null
//                                 ? 'Share Feedback'
//                                 : 'Update Feedback',
//                           ),
//                         ),
//                       ),
//                       if (_editingFeedbackId != null) ...[
//                         const SizedBox(width: 8),
//                         TextButton(
//                           onPressed: _clearForm,
//                           child: const Text('Cancel'),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // List Section (Support Message functionality)
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : state.feedbacks.isEmpty
//                 ? const Center(child: Text('No feedback shared yet'))
//                 : ListView.separated(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: state.feedbacks.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemBuilder: (context, index) {
//                       final item = state.feedbacks[index];
//                       return Card(
//                         child: ListTile(
//                           title: Text(
//                             item.feedback,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           subtitle: Text(
//                             "Improvement: ${item.futureImprovements}",
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,

//                           ),

//                           trailing: PopupMenuButton<String>(
//                             onSelected: (val) {
//                               if (val == 'view') {
//                                 _showFeedbackDetails(item);
//                                 return;
//                               }
//                               if (val == 'edit') {
//                                 _startEdit(item);
//                                 return;
//                               }
//                               if (val == 'edit') _startEdit(item);
//                               if (val == 'delete') _deleteFeedback(item.id!);
//                             },
//                             itemBuilder: (context) => [
//                               const PopupMenuItem(
//                                 value: 'view',
//                                 child: Text('View'),
//                               ),
//                               const PopupMenuItem(
//                                 value: 'edit',
//                                 child: Text('Edit'),
//                               ),
//                               const PopupMenuItem(
//                                 value: 'delete',
//                                 child: Text('Delete'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
import 'package:digital_wallett_system/core/utils/snackbar_utils.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:digital_wallett_system/features/feedback/presentation/state/feedback_state.dart';
import 'package:digital_wallett_system/features/feedback/presentation/view_model/feedback_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareFeedbackPage extends ConsumerStatefulWidget {
  const ShareFeedbackPage({super.key});

  @override
  ConsumerState<ShareFeedbackPage> createState() => _ShareFeedbackPageState();
}

class _ShareFeedbackPageState extends ConsumerState<ShareFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _improvementController = TextEditingController();
  String? _editingFeedbackId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedbackViewModelProvider.notifier).loadFeedbacks();
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _improvementController.dispose();
    super.dispose();
  }

  // Helper to format date consistent with your Support Message page
  String _formatDate(DateTime date) {
    final month = _twoDigits(date.month);
    final day = _twoDigits(date.day);
    final hour = _twoDigits(date.hour);
    final minute = _twoDigits(date.minute);
    return '${date.year}-$month-$day $hour:$minute';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Future<void> _saveFeedback() async {
    final feedback = _feedbackController.text.trim();
    final improvements = _improvementController.text.trim();

    if (feedback.isEmpty || improvements.isEmpty) {
      SnackbarUtils.showError(context, 'Please fill in both fields');
      return;
    }

    final notifier = ref.read(feedbackViewModelProvider.notifier);
    final error = _editingFeedbackId == null
        ? await notifier.submitFeedback(
            feedback: feedback,
            futureImprovements: improvements,
          )
        : await notifier.updateFeedback(
            id: _editingFeedbackId!,
            feedback: feedback,
            futureImprovements: improvements,
          );

    if (!mounted) return;
    if (error != null) {
      SnackbarUtils.showError(context, error);
      return;
    }

    SnackbarUtils.showSuccess(
      context,
      _editingFeedbackId == null ? 'Feedback shared' : 'Feedback updated',
    );
    _clearForm();
  }

  void _clearForm() {
    setState(() {
      _editingFeedbackId = null;
      _feedbackController.clear();
      _improvementController.clear();
    });
  }

  Future<void> _deleteFeedback(String id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Feedback'),
        content: const Text('Do you want to delete this feedback?'),
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
      ),
    );

    if (result != true) return;

    final error = await ref
        .read(feedbackViewModelProvider.notifier)
        .deleteFeedback(id);
    if (!mounted) return;
    if (error != null) {
      SnackbarUtils.showError(context, error);
      return;
    }
    SnackbarUtils.showSuccess(context, 'Feedback deleted');
    if (_editingFeedbackId == id) _clearForm();
  }

  void _startEdit(FeedbackEntity item) {
    setState(() {
      _editingFeedbackId = item.id;
      _feedbackController.text = item.feedback;
      _improvementController.text = item.futureImprovements;
    });
  }

  void _showFeedbackDetails(FeedbackEntity message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Feedback:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(message.feedback),
                const SizedBox(height: 12),
                const Text(
                  'Improvements:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(message.futureImprovements),
                const SizedBox(height: 12),
                const Divider(),
                Text(
                  'Created: ${_formatDate(message.createdAt ?? DateTime.now())}',
                  style: TextStyle(color: context.textSecondary, fontSize: 11),
                ),
                Text(
                  'Updated: ${_formatDate(message.updatedAt ?? message.createdAt ?? DateTime.now())}',
                  style: TextStyle(color: context.textSecondary, fontSize: 11),
                ),
              ],
            ),
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
    final state = ref.watch(feedbackViewModelProvider);
    final isSubmitting = state.status == FeedbackStatus.submitting;
    final isLoading = state.status == FeedbackStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback & Suggestions')),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: context.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editingFeedbackId == null
                        ? 'Help us improve'
                        : 'Edit your feedback',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _feedbackController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Feedback...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _improvementController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Improvement ideas...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isSubmitting ? null : _saveFeedback,
                          icon: Icon(
                            _editingFeedbackId == null
                                ? Icons.send
                                : Icons.check,
                          ),
                          label: Text(
                            _editingFeedbackId == null
                                ? 'Share Feedback'
                                : 'Update Feedback',
                          ),
                        ),
                      ),
                      if (_editingFeedbackId != null) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _clearForm,
                          child: const Text('Cancel'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          // History Section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.feedbacks.isEmpty
                ? const Center(child: Text('No feedback shared yet'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.feedbacks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.feedbacks[index];
                      return Card(
                        child: ListTile(
                          onTap: () => _showFeedbackDetails(item),
                          title: Text(
                            item.feedback,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Improvement: ${item.futureImprovements}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // This adds the date/time below the improvement text
                              Text(
                                _formatDate(
                                  item.updatedAt ??
                                      item.createdAt ??
                                      DateTime.now(),
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (val) {
                              if (val == 'view') _showFeedbackDetails(item);
                              if (val == 'edit') _startEdit(item);
                              if (val == 'delete') _deleteFeedback(item.id!);
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: Text('View'),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
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
