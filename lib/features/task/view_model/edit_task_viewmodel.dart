import 'package:flutter/material.dart';

import '../../../core/models/task_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/app_preferences.dart';

class EditTaskViewModel extends ChangeNotifier {

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskPriority selectedPriority;
  DateTime? selectedDueDate;

  bool isLoading = false;
  String? errorMessage;

  final TaskModel task;
  final ApiClient apiClient;
  final AppPreferences prefs;

  EditTaskViewModel(this.task, this.apiClient, this.prefs)
    : selectedPriority = task.priority,
      selectedDueDate = task.dueDate {
    titleController.text = task.title;
    descriptionController.text = task.description;
  }

   

  String get dueDateText => selectedDueDate == null
      ? 'Select due date'
      : '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year} '
            '${selectedDueDate!.hour.toString().padLeft(2, '0')}:${selectedDueDate!.minute.toString().padLeft(2, '0')}';

  void setPriority(TaskPriority p) {
    selectedPriority = p;
    notifyListeners();
  }

  Future<void> pickDueDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      initialDate: selectedDueDate ?? now,
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDueDate ?? now),
      );
      if (time != null) {
        selectedDueDate = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        notifyListeners();
      }
    }
  }

  Future<TaskModel?> updateTask() async {
    if (!formKey.currentState!.validate()) return null;

    isLoading = true;
    notifyListeners();

    try {
      // simulate API call (replace with your backend call)
      await Future.delayed(const Duration(seconds: 1));

      final updatedTask = task.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority,
        dueDate: selectedDueDate ?? task.dueDate,
        updatedAt: DateTime.now(),
      );
      isLoading = false;
      notifyListeners();
      return updatedTask;
    } catch (e) {
      errorMessage = 'Failed to update task';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
