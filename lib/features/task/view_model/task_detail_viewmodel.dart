// lib/features/task/view_model/task_detail_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:wowtask/core/routing/app_navigator.dart';

import '../../../core/models/task_model.dart';
import '../../../core/routing/route_names.dart';

/// ViewModel for Task Detail - simple local updates + placeholders for repo calls.
class TaskDetailViewModel extends ChangeNotifier {
  TaskModel _task;
  bool _isLoading = false;
  String? _error;

  TaskDetailViewModel(this._task);

  TaskModel get task => _task;
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;

  bool get isCompleted => _task.status.toLowerCase() == 'completed';

  Future<void> markAsComplete() async {
    if (isCompleted) return;
    _setLoading(true);
    try {
      // TODO: call repository to mark complete. Simulate delay for now.
      await Future.delayed(const Duration(milliseconds: 450));
      _task = _task.copyWith(status: 'Completed', updatedAt: DateTime.now());
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to mark complete';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(BuildContext context) async {
    _setLoading(true);
    try {
      // TODO: actually delete via repository
      await Future.delayed(const Duration(milliseconds: 400));
      // return to previous screen with deleted result
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop({'action': 'deleted', 'id': _task.id});
      }
    } catch (e) {
      _error = 'Failed to delete';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editTask(BuildContext context) async {
    final updatedTask = await AppNavigator.pushToNamed(
      RouteNames.editTask,
      params: {"id": task.id},
      extra: task,
    );

    if (updatedTask != null) {
      task.title = updatedTask.title;
      task.description = updatedTask.description;
      task.priority = updatedTask.priority;
      task.dueDate = updatedTask.dueDate;
      task.status = updatedTask.status;
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
