// lib/features/tasks/model/task_model.dart
import 'package:flutter/foundation.dart';

enum TaskPriority { low, medium, high }

class TaskModel {
  String id;
  String title;
  String description;
  DateTime dueDate;
  TaskPriority priority;
  String status;
  DateTime createdAt;
  DateTime? updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = 'Pending',
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'priority': describeEnum(priority),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    TaskPriority parsePriority(String? s) {
      switch (s) {
        case 'low':
        case 'TaskPriority.low':
          return TaskPriority.low;
        case 'medium':
        case 'TaskPriority.medium':
          return TaskPriority.medium;
        default:
          return TaskPriority.high;
      }
    }

    return TaskModel(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      priority: parsePriority(json['priority'] as String?),
      status: json['status'] ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
