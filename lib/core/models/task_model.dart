import 'package:flutter/foundation.dart';

enum TaskPriority { low, medium, high }

class TaskModel {
  final String objectId; // Back4App unique ID
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
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = 'Pending',
    DateTime? createdAt,
    this.updatedAt,
    this.createdBy,
  }) : createdAt = createdAt ?? DateTime.now();

  // 🧩 Copy with
  TaskModel copyWith({
    String? objectId,
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

  //  To JSON (for Back4App)
  Map<String, dynamic> toJson({String? userId}) {
    final map = {
      "title": title,
      "description": description,
      "dueDate": {"__type": "Date", "iso": dueDate.toUtc().toIso8601String()},
      "priority": describeEnum(priority),
      "status": status,
    };

    if (userId != null) {
      map["createdBy"] = {
        "__type": "Pointer",
        "className": "_User",
        "objectId": userId,
      };
    }

    return map;
  }


  // 🧩 From JSON (for Back4App)
  factory TaskModel.fromJson(Map<dynamic, dynamic> json) {
    TaskPriority parsePriority(String? s) {
      switch (s?.toLowerCase()) {
        case 'low':
          return TaskPriority.low;
        case 'medium':
          return TaskPriority.medium;
        default:
          return TaskPriority.high;
      }
    }

    DateTime parseDate(dynamic val) {
      if (val == null) return DateTime.now();
      if (val is String) return DateTime.parse(val);
      if (val is Map && val["iso"] != null) return DateTime.parse(val["iso"]);
      return DateTime.now();
    }

    return TaskModel(
      objectId: json["objectId"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      dueDate: parseDate(json["dueDate"]),
      priority: parsePriority(json["priority"]),
      status: json["status"] ?? "Pending",
      createdAt: parseDate(json["createdAt"]),
      updatedAt: json["updatedAt"] != null
          ? parseDate(json["updatedAt"])
          : null,
      createdBy: json["createdBy"]?["objectId"] ?? "",
    );
  }

}
