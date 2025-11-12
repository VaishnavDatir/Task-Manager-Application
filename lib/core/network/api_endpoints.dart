class ApiEndpoints {
  // USER
  static const String users = '/users';
  static const String signup = '/users';
  static const String login = '/login';
  static const String me = '/users/me';
  static const String logout = '/logout';

// Tasks
  static const tasks = '/classes/Task';

  //  Dynamic endpoints (functions for runtime values)
  static String userById(String userId) => '$users/$userId';
  static String taskById(String taskId) => '$tasks/$taskId';
}
