// lib/features/tasks/repository/task_repository.dart

import '../models/task_model.dart';

abstract class TaskRepository {
  /// creates task and returns created TaskModel (with id, timestamps)
  Future<TaskModel> createTask(TaskModel task);

  /// other methods you may want later
  // Future<List<TaskModel>> fetchTasks();
  // Future<TaskModel> updateTask(TaskModel task);
  // Future<void> deleteTask(String id);
}
