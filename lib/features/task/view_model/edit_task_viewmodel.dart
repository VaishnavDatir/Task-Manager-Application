import 'package:flutter/material.dart';

import '../../../core/models/task_model.dart';
import '../../../core/repositories/task_repository.dart';

class EditTaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  TaskPriority selectedPriority;
  DateTime? selectedDueDate;

  bool isLoading = false;
  String? errorMessage;

  final TaskModel task;

  EditTaskViewModel(this.task, this._taskRepository)
    : selectedPriority = task.priority,
      selectedDueDate = task.dueDate {
    titleController.text = task.title;
    descriptionController.text = task.description;
  }

  // -------------------------------------------------------------
  // 🔹 DATE DISPLAY
  // -------------------------------------------------------------
  String get dueDateText => selectedDueDate == null
      ? 'Select due date'
      : '${selectedDueDate!.day.toString().padLeft(2, '0')}/'
            '${selectedDueDate!.month.toString().padLeft(2, '0')}/'
            '${selectedDueDate!.year}  '
            '${selectedDueDate!.hour.toString().padLeft(2, '0')}:'
            '${selectedDueDate!.minute.toString().padLeft(2, '0')}';

  // -------------------------------------------------------------
  // 🔹 SET PRIORITY
  // -------------------------------------------------------------
  void setPriority(TaskPriority p) {
    selectedPriority = p;
    notifyListeners();
  }

  // -------------------------------------------------------------
  // 🔹 PICK DUE DATE + TIME
  // -------------------------------------------------------------
  Future<void> pickDueDate(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      initialDate: selectedDueDate ?? now,
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDueDate ?? now),
    );

    if (time == null) return;

    selectedDueDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    notifyListeners();
  }

  // -------------------------------------------------------------
  // 🔹 UPDATE TASK (REAL BACK4APP API CALL)
  // -------------------------------------------------------------
  Future<TaskModel?> updateTask() async {
    if (!formKey.currentState!.validate()) return null;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updatedTask = task.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority,
        dueDate: selectedDueDate ?? task.dueDate,
        updatedAt: DateTime.now(),
      );

      // REAL backend update
      final savedTask = await _taskRepository.updateTask(updatedTask);

      isLoading = false;
      notifyListeners();

      return savedTask; // returned to screen → pop(result)
    } catch (e) {
      errorMessage = "Failed to update task";
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
