import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../models/task_model.dart';
import '../network/api_custom_header.dart';
import 'auth_repository.dart';

class TaskRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  TaskRepository(this._dio, this._authRepository);

  /// Fetch all tasks belonging to current user
  Future<List<TaskModel>> fetchTasks(String userId) async {
    try {
      final whereQuery = {
        "createdBy": {
          "__type": "Pointer",
          "className": "_User",
          "objectId": userId,
        },
      };

      final response = await _dio.get(
        ApiEndpoints.tasks,
        options: Options(
          headers: {
            ApiCustomHeaders.xParseSessionToken:
                _authRepository.currentUser?.sessionToken,
          },
        ),
        queryParameters: {
          "where": jsonEncode(whereQuery), 
          "order": "-createdAt",
        },
      );

      final results = response.data["results"] as List<dynamic>? ?? [];
      return results.map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel?> createTask(TaskModel task) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.tasks,
        options: Options(
          headers: {
            ApiCustomHeaders.xParseSessionToken:
                _authRepository.currentUser?.sessionToken,
          },
        ),
        data: task.toJson(), // directly use model’s JSON
      );

      // Merge response data (objectId, createdAt, etc.)
      final created = {...task.toJson(), ...response.data};

      return TaskModel.fromJson(created);
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel?> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.taskById(task.objectId), // use model’s id
        options: Options(
          headers: {
            ApiCustomHeaders.xParseSessionToken:
                _authRepository.currentUser?.sessionToken,
          },
        ),
        data: task.toJson(), // send updated model
      );

      final updated = {...task.toJson(), ...response.data};
      return TaskModel.fromJson(updated);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete task
  Future<void> deleteTask(TaskModel task) async {
    try {
      await _dio.delete(
        ApiEndpoints.taskById(task.objectId),
        options: Options(
          headers: {
            ApiCustomHeaders.xParseSessionToken:
                _authRepository.currentUser?.sessionToken,
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
