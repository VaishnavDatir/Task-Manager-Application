import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wowtask/core/models/task_model.dart';

class UiUtils {
  static Color getStatusColor(TaskModel task, String selectedFilter) {
    switch (selectedFilter) {
      case "Past Due":
        return Colors.redAccent;
      case "Today":
        return Colors.orangeAccent;
      case "Upcoming":
        return Colors.blueAccent;
      default:
        if (task.status == "Completed") return Colors.green;
        return Colors.orangeAccent;
    }
  }

  static String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();

    // Normalize times (so date-only comparison works correctly)
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final diff = now.difference(dueDate).inDays.abs();

    // 1️ Due Today
    if (taskDay == today) {
      if (dueDate.isAfter(now)) {
        return "Due in ${timeago.format(dueDate, allowFromNow: true)}";
      } else {
        return "Due ${timeago.format(dueDate)}";
      }
    }

    // Future Dates (not today)
    if (dueDate.isAfter(now)) {
      if (diff <= 10) {
        return "Due in ${timeago.format(dueDate, allowFromNow: true)}";
      }
      return "Due on ${dueDate.day}/${dueDate.month}/${dueDate.year}";
    }

    // Past Dates
    if (dueDate.isBefore(now)) {
      if (diff <= 10) {
        return "Due ${timeago.format(dueDate)}";
      }
      return "Due on ${dueDate.day}/${dueDate.month}/${dueDate.year}";
    }

    // Fallback
    return "Due on ${dueDate.day}/${dueDate.month}/${dueDate.year}";
  }
}
