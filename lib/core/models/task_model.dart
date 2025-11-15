import 'package:flutter/foundation.dart';

enum TaskPriority { low, medium, high }

class TaskModel {
  final String objectId;
  final String? taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  TaskModel({
    required this.objectId,
    this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = 'Pending',
    DateTime? createdAt,
    this.updatedAt,
    this.createdBy,
  }) : createdAt = createdAt ?? DateTime.now();

  // 🔁 CopyWith
  TaskModel copyWith({
    String? objectId,
    String? taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return TaskModel(
      objectId: objectId ?? this.objectId,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // 🔧 Convert to JSON for Back4App
  Map<String, dynamic> toJson({String? userId}) {
    return {
      "taskId": taskId,
      "title": title,
      "description": description,
      "dueDate": {"__type": "Date", "iso": dueDate.toUtc().toIso8601String()},
      "priority": describeEnum(priority),
      "status": status,
      if (userId != null || createdBy != null)
        "createdBy": {
          "__type": "Pointer",
          "className": "_User",
          "objectId": userId ?? createdBy,
        },
    };
  }

  // 🔄 From JSON (safe parsing)
  factory TaskModel.fromJson(Map<dynamic, dynamic> json) {
    TaskPriority parsePriority(dynamic value) {
      if (value == null) return TaskPriority.medium;

      final s = value.toString().toLowerCase();
      if (s == "low") return TaskPriority.low;
      if (s == "medium") return TaskPriority.medium;
      return TaskPriority.high;
    }

    DateTime parseDate(dynamic value) {
      try {
        if (value == null) return DateTime.now();
        if (value is String) return DateTime.parse(value);
        if (value is Map && value["iso"] != null) {
          return DateTime.parse(value["iso"]).toLocal();
        }
      } catch (_) {}
      return DateTime.now();
    }

    return TaskModel(
      objectId: json["objectId"] ?? "",
      taskId: json["taskId"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      dueDate: parseDate(json["dueDate"]),
      priority: parsePriority(json["priority"]),
      status: json["status"] ?? "Pending",
      createdAt: parseDate(json["createdAt"]),
      updatedAt: json["updatedAt"] != null
          ? parseDate(json["updatedAt"])
          : null,
      createdBy: json["createdBy"]?["objectId"],
    );
  }
}
