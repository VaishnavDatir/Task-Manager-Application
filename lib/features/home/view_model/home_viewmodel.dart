import 'package:flutter/material.dart';

import '../../../core/models/task_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/repositories/task_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HomeViewModel(this._taskRepository, this._authRepository);

  Future<void> fetchTasks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = _authRepository.currentUser?.id;
      if (userId == null) {
        _error = "No user logged in";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _tasks = await _taskRepository.fetchTasks(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // FILTER LOGIC
  List<TaskModel> getFilteredTasks(String filter) {
    final now = DateTime.now();

    switch (filter) {
      case "Today":
        return _tasks
            .where(
              (task) =>
                  task.status != "Completed" && _isSameDate(task.dueDate, now),
            )
            .toList();

      case "Past Due":
        return _tasks
            .where(
              (task) =>
                  task.dueDate.isBefore(
                    DateTime(now.year, now.month, now.day),
                  ) &&
                  task.status != "Completed",
            )
            .toList();

      case "Upcoming":
        return _tasks
            .where(
              (task) =>
                  task.status != "Completed" &&
                  task.dueDate.isAfter(DateTime(now.year, now.month, now.day)),
            )
            .toList();

      case "Completed":
        return _tasks.where((task) => task.status == "Completed").toList();

      default:
        return _tasks;
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }


}
