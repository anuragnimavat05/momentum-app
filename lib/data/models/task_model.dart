import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String? goalId;
  final String userId;
  final String title;
  final bool isCompleted;
  final String priority;
  final String recurringType;
  final String? reminderTime;
  final String category;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<Subtask> subtasks;
  final String? suggestedAction; // For tiny action suggestions

  TaskModel({
    required this.id,
    this.goalId,
    required this.userId,
    required this.title,
    this.isCompleted = false,
    this.priority = 'Medium',
    this.recurringType = 'None',
    this.reminderTime,
    this.category = 'General',
    required this.createdAt,
    this.dueDate,
    this.subtasks = const [],
    this.suggestedAction,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final subtasksData = data['subtasks'] as List<dynamic>? ?? [];
    return TaskModel(
      id: doc.id,
      goalId: data['goalId'],
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      priority: data['priority'] ?? 'Medium',
      recurringType: data['recurringType'] ?? 'None',
      reminderTime: data['reminderTime'],
      category: data['category'] ?? 'General',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      subtasks: subtasksData.map((s) => Subtask.fromMap(s as Map<String, dynamic>)).toList(),
      suggestedAction: data['suggestedAction'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'goalId': goalId,
      'userId': userId,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority,
      'recurringType': recurringType,
      'reminderTime': reminderTime,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
      'suggestedAction': suggestedAction,
    };
  }

  TaskModel copyWith({
    String? title,
    bool? isCompleted,
    String? priority,
    String? recurringType,
    String? reminderTime,
    String? category,
    DateTime? dueDate,
    List<Subtask>? subtasks,
    String? suggestedAction,
  }) {
    return TaskModel(
      id: id,
      goalId: goalId,
      userId: userId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      recurringType: recurringType ?? this.recurringType,
      reminderTime: reminderTime ?? this.reminderTime,
      category: category ?? this.category,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      subtasks: subtasks ?? this.subtasks,
      suggestedAction: suggestedAction ?? this.suggestedAction,
    );
  }
}

class Subtask {
  final String id;
  final String title;
  final bool isCompleted;

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
