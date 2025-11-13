
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/v8.dart';

import '../../../core/models/task_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/repositories/task_repository.dart';
import '../../../core/routing/app_navigator.dart';
import '../../../core/routing/route_names.dart';

enum TaskMode { create, edit, view }

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;
  final TaskMode mode;

  TaskModel? _task; // null for create mode

  // Form + controllers
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // State
  TaskPriority selectedPriority = TaskPriority.medium;
  DateTime? dueDate;
  bool isLoading = false;
  String? errorMessage;

  // Constructors (named)
  TaskViewModel.create(this._taskRepository, this._authRepository)
    : mode = TaskMode.create;

  TaskViewModel.edit(this._task, this._taskRepository, this._authRepository)
    : mode = TaskMode.edit {
    _initFromTask();
  }

  TaskViewModel.view(this._task, this._taskRepository, this._authRepository)
    : mode = TaskMode.view {
    _initFromTask();
  }

  bool get isCompleted => _task?.status.toLowerCase() == 'completed';

  // Init helpers
  void _initFromTask() {
    if (_task == null) return;
    titleController.text = _task!.title;
    descriptionController.text = _task!.description;
    selectedPriority = _task!.priority;
    dueDate = _task!.dueDate;
  }

  // Getters
  TaskModel? get task => _task;
  bool get isCreate => mode == TaskMode.create;
  bool get isEdit => mode == TaskMode.edit;
  bool get isView => mode == TaskMode.view;

  String get dueDateText {
    if (dueDate == null) return 'Select due date';
    return DateFormat('EEE, MMM d, yyyy – hh:mm a').format(dueDate!);
  }

  // UI helpers
  void setPriority(TaskPriority p) {
    selectedPriority = p;
    notifyListeners();
  }

  Future<void> pickDueDate(BuildContext context) async {
    // Called from UI; context is valid there. We don't use context after async.
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dueDate ?? now),
    );
    if (pickedTime == null) return;

    dueDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    notifyListeners();
  }

  // CRUD actions
  Future<TaskModel?> createTask() async {
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
      final newTask = TaskModel(
        objectId: "",
        taskId: UuidV8().generate().toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: dueDate!,
        priority: selectedPriority,
        status: 'Pending',
        createdAt: DateTime.now(),
        updatedAt: null,
        createdBy: _authRepository.currentUser?.id ?? '',
      );

      final saved = await _taskRepository.createTask(newTask);
      _task = saved;
      isLoading = false;
      notifyListeners();
      return saved;
    } catch (e) {
      errorMessage = 'Failed to create task. Please try again.';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<TaskModel?> updateTask() async {
    if (!formKey.currentState!.validate()) return null;
    if (_task == null) return null;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updated = _task!.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority,
        dueDate: dueDate ?? _task!.dueDate,
        updatedAt: DateTime.now(),
      );

      final saved = await _taskRepository.updateTask(updated);
      _task = saved;
      isLoading = false;
      notifyListeners();
      return saved;
    } catch (e) {
      errorMessage = 'Failed to update task.';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteTask() async {
    if (_task == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      await _taskRepository.deleteTask(_task!);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Failed to delete task.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<TaskModel?> markAsComplete() async {
    if (_task == null) return null;
    if (_task!.status.toLowerCase() == 'completed') return _task;

    isLoading = true;
    notifyListeners();
    try {
      final updated = _task!.copyWith(
        status: 'Completed',
        updatedAt: DateTime.now(),
      );
      final saved = await _taskRepository.updateTask(updated);
      _task = saved;
      isLoading = false;
      notifyListeners();
      return saved;
    } catch (e) {
      errorMessage = 'Failed to mark task complete';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> editTaskBtnAction() async {
    final updatedTask = await AppNavigator.pushToNamed(
      RouteNames.editTask,
      params: {"id": task!.objectId},
      extra: task,
    );

    if (updatedTask is TaskModel) {
      _task = updatedTask;
      notifyListeners();
    }
  }

  void onTitleChanged(String _) {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
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
      // build new task
      TaskModel newTask = TaskModel(
        objectId: "",
        taskId: UuidV8().generate().toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority,
        dueDate: dueDate!,
        status: "Pending",
        createdAt: DateTime.now(),
        createdBy: _authRepository.currentUser?.id,
      );

      final savedTask = await _taskRepository.createTask(newTask);

      isLoading = false;
      notifyListeners();

      return savedTask;
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to create task. Please try again.";
      notifyListeners();
      return null;
    }
  }

  // Dispose controllers
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
