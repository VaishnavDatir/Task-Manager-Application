// lib/features/task/view/task_detail_screen.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/task_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/repositories/task_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../view_model/task_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskViewModel>(
      create: (context) => TaskViewModel.view(
        task,
        context.read<TaskRepository>(),
        context.read<AuthRepository>(),
      ),
      child: _TaskDetailView(), // your UI
    );
  }
}

class _TaskDetailView extends StatelessWidget {
  const _TaskDetailView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final task = vm.task;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: theme.iconTheme,
        title: Hero(
          tag: 'task-title-${task!.objectId}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              task.title,
              style: AppTypography.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: vm.isLoading
                ? null
                : () async => await vm.editTaskBtnAction(),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: vm.isLoading
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete task'),
                        content: const Text(
                          'Are you sure you want to delete this task?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      await vm.deleteTask();
                    }
                  },
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FadeInUp(
              from: 50,
              child: Hero(
                tag: 'task-card-${task.objectId}',
                child: Material(
                  color: theme.colorScheme.surface,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: AppTypography.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _metaChip(
                              Icons.calendar_month,
                              _fmtDateTime(task.dueDate),
                            ),
                            const SizedBox(width: 8),
                            _priorityChip(task.priority),
                            const SizedBox(width: 8),
                            _statusChip(task.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Description', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          task.description.isEmpty
                              ? 'No description provided.'
                              : task.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        _infoRow('Created', _fmtDate(task.createdAt)),
                        if (task.updatedAt != null)
                          _infoRow('Updated', _fmtDate(task.updatedAt!)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  vm.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            // Actions
            FadeInUp(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: vm.isLoading || vm.isCompleted
                          ? null
                          : () => vm.markAsComplete(),
                      icon: vm.isCompleted
                          ? const Icon(Icons.check_circle_outline)
                          : const Icon(Icons.done_all_rounded),
                      label: Text(
                        vm.isCompleted ? 'Completed' : 'Mark Complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: vm.isCompleted
                            ? Colors.green.shade600
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Shrinkable FAB behaviour is handled by the OpenContainer in Home (so we don't create an extra container here).
    );
  }

  Widget _metaChip(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );

  Widget _priorityChip(TaskPriority p) {
    final label = p.name.toUpperCase();
    Color color;
    switch (p) {
      case TaskPriority.low:
        color = Colors.green;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        break;
      case TaskPriority.high:
        color = Colors.red;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static String _fmtDateTime(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  static String _fmtDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day}/${d.month}/${d.year}';
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
