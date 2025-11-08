import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/task_model.dart';
import '../../../core/theme/app_colors.dart';
import '../view_model/create_task_viewmodel.dart';

class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateTaskViewModel(),
      child: const _CreateTaskView(),
    );
  }
}

class _CreateTaskView extends StatelessWidget {
  const _CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateTaskViewModel>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // remove focus on tap
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Task',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Form(
            key: vm.formKey,
            child: SingleChildScrollView(
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextFormField(
                      controller: vm.titleController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: 'Task Title *',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return 'Title is required';
                        if (s.length > 100) {
                          return 'Title must be at most 100 characters';
                        }
                        return null;
                      },
                      onChanged: vm.onTitleChanged,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: vm.descriptionController,
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'Description (optional)',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Priority selector
                    Text('Priority *', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _priorityChip(context, vm, TaskPriority.low, 'Low'),
                        _priorityChip(
                          context,
                          vm,
                          TaskPriority.medium,
                          'Medium',
                        ),
                        _priorityChip(context, vm, TaskPriority.high, 'High'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Due date/time selector
                    Text(
                      'Due (Date & Time) *',
                      style: theme.textTheme.titleMedium,
                    ),
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
                                semanticsLabel: 'Due date and time',
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
                    const SizedBox(height: 80), // spacing for bottom button
                    if (vm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          vm.errorMessage!,
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom create button (always visible)
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        final created = await vm.submit();
                        if (created != null && context.mounted) {
                          Navigator.of(context).pop(created);
                        } else if (vm.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(vm.errorMessage!)),
                          );
                          vm.clearError();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: vm.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Task'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _priorityChip(
    BuildContext context,
    CreateTaskViewModel vm,
    TaskPriority p,
    String label,
  ) {
    final isSelected = vm.selectedPriority == p;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => vm.setPriority(p),
        selectedColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : theme.textTheme.bodySmall?.color,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
