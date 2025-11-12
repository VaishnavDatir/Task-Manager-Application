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

  List<TaskModel> getFilteredTasks(String filter) {
    if (filter == "All") return _tasks;
    return _tasks.where((task) => task.status == filter).toList();
  }
}
