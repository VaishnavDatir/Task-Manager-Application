import 'package:flutter/material.dart';
import 'package:wowtask/core/routing/app_navigator.dart';

import '../../../core/models/task_model.dart';
import '../../../core/repositories/task_repository.dart';
import '../../../core/routing/route_names.dart';

class TaskDetailViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;

  TaskModel _task;
  bool _isLoading = false;
  String? _error;

  TaskDetailViewModel(this._task, this._taskRepository);

  // GETTERS
  TaskModel get task => _task;
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;

  bool get isCompleted => _task.status.toLowerCase() == 'completed';

  // PRIVATE METHOD
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  //  MARK TASK AS COMPLETED
  Future<void> markAsComplete() async {
    if (isCompleted) return;

    _setLoading(true);
    try {
      final updatedTask = _task.copyWith(
        status: 'Completed',
        updatedAt: DateTime.now(),
      );

      final result = await _taskRepository.updateTask(updatedTask);

      if (result != null) {
        _task = result;
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = "Failed to mark as completed";
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask() async {
    _setLoading(true);
    try {
      await _taskRepository.deleteTask(_task);
      AppNavigator.goBack("deleted");
    } catch (e) {
      _error = "Failed to delete task";
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editTask(BuildContext context) async {
    final updatedTask = await AppNavigator.pushToNamed(
      RouteNames.editTask,
      params: {"id": task.objectId},
      extra: task,
    );

    if (updatedTask is TaskModel) {
      _task = updatedTask;
      notifyListeners();
    }
  }
}
