import 'package:dio/dio.dart';

class TaskRepository {
  final Dio _dio;
  TaskRepository(this._dio);

  Future<List<dynamic>> fetchTasks() async {
    final response = await _dio.get('/Task');
    return response.data['results'];
  }

  Future<void> createTask(Map<String, dynamic> data) async {
    await _dio.post('/Task', data: data);
  }

  Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await _dio.put('/Task/$id', data: data);
  }

  Future<void> deleteTask(String id) async {
    await _dio.delete('/Task/$id');
  }
}
