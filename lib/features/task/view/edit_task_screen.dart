import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/task_model.dart';
import '../../../core/theme/app_colors.dart';
import '../view_model/edit_task_viewmodel.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskModel task;
  const EditTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditTaskViewModel(task),
      child: const _EditTaskView(),
    );
  }
}

class _EditTaskView extends StatelessWidget {
  const _EditTaskView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditTaskViewModel>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Task')),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Form(
            key: vm.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextFormField(
                    controller: vm.titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Task Title',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Title is required';
                      if (s.length > 100) return 'Too long';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: vm.descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Priority selector
                  Text('Priority', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _priorityChip(context, vm, TaskPriority.low, 'Low'),
                      _priorityChip(context, vm, TaskPriority.medium, 'Medium'),
                      _priorityChip(context, vm, TaskPriority.high, 'High'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Due date/time selector
                  Text('Due Time', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: vm.isLoading
                        ? null
                        : () async => vm.pickDueDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              vm.dueDateText,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: vm.dueDateText == 'Select due date'
                                    ? theme.hintColor
                                    : null,
                              ),
                            ),
                          ),
                          const Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  if (vm.errorMessage != null)
                    Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        final updated = await vm.updateTask();
                        if (updated != null && context.mounted) {
                          Navigator.of(context).pop(updated);
                        }
                      },
                child: vm.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Update Task'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _priorityChip(
    BuildContext context,
    EditTaskViewModel vm,
    TaskPriority p,
    String label,
  ) {
    final isSelected = vm.selectedPriority == p;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => vm.setPriority(p),
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.textTheme.bodySmall?.color,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
