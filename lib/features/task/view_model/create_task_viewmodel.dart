import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/v6.dart';

import '../../../core/models/task_model.dart';

class CreateTaskViewModel extends ChangeNotifier {
  // Form + controllers
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Focus nodes
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();

  // State
  TaskPriority selectedPriority = TaskPriority.medium;
  DateTime? dueDate;
  bool isLoading = false;
  String? errorMessage;

  // Computed getter for formatted text
  String get dueDateText {
    if (dueDate == null) return 'Select due date';
    final dateStr = DateFormat('EEE, MMM d, yyyy – hh:mm a').format(dueDate!);
    return dateStr;
  }

  // === User actions ===

  void onTitleChanged(String _) {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  void setPriority(TaskPriority priority) {
    if (selectedPriority != priority) {
      selectedPriority = priority;
      notifyListeners();
    }
  }

  Future<void> pickDueDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      final now = DateTime.now();

      // --- Step 1: Pick date ---
      final date = await showDatePicker(
        context: context,
        initialDate: dueDate ?? now,
        firstDate: now,
        lastDate: DateTime(now.year + 5),
        builder: (context, child) {
          // match system theme
          return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: child!,
          );
        },
      );

      if (date == null) return;

      // --- Step 2: Pick time ---
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dueDate ?? now),
        builder: (context, child) {
          return Theme(data: Theme.of(context), child: child!);
        },
      );

      if (time == null) return;

      final selected = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      dueDate = selected;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to pick date: $e';
      notifyListeners();
    }
  }

  Future<TaskModel?> submit() async {
    if (!formKey.currentState!.validate()) return null;

    if (dueDate == null) {
      errorMessage = 'Please select a due date.';
      notifyListeners();
      return null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      final task = TaskModel(
        id: UuidV6().toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority,
        dueDate: dueDate!,
        createdAt: DateTime.now(),
      );

      isLoading = false;
      notifyListeners();
      return task;
    } catch (e) {
      errorMessage = 'Failed to create task. Please try again.';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }
}
