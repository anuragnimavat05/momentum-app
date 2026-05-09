import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String userId;
  final String title;
  final String? why;
  final String category;
  final DateTime? targetDate;
  final int progress;
  final String? visionUrl;
  final DateTime createdAt;
  final bool isCompleted;
  final List<Milestone> milestones;
  final String? nextAction;

  GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    this.why,
    required this.category,
    this.targetDate,
    this.progress = 0,
    this.visionUrl,
    required this.createdAt,
    this.isCompleted = false,
    this.milestones = const [],
    this.nextAction,
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final milestonesData = data['milestones'] as List<dynamic>? ?? [];
    return GoalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      why: data['why'],
      category: data['category'] ?? 'Other',
      targetDate: (data['targetDate'] as Timestamp?)?.toDate(),
      progress: data['progress'] ?? 0,
      visionUrl: data['visionUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isCompleted: data['isCompleted'] ?? false,
      milestones: milestonesData.map((m) => Milestone.fromMap(m as Map<String, dynamic>)).toList(),
      nextAction: data['nextAction'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'why': why,
      'category': category,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate!) : null,
      'progress': progress,
      'visionUrl': visionUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
      'milestones': milestones.map((m) => m.toMap()).toList(),
      'nextAction': nextAction,
    };
  }

  GoalModel copyWith({
    String? title,
    String? why,
    String? category,
    DateTime? targetDate,
    int? progress,
    String? visionUrl,
    bool? isCompleted,
    List<Milestone>? milestones,
    String? nextAction,
  }) {
    return GoalModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      why: why ?? this.why,
      category: category ?? this.category,
      targetDate: targetDate ?? this.targetDate,
      progress: progress ?? this.progress,
      visionUrl: visionUrl ?? this.visionUrl,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      milestones: milestones ?? this.milestones,
      nextAction: nextAction ?? this.nextAction,
    );
  }
}

class Milestone {
  final String id;
  final String title;
  final bool isCompleted;

  Milestone({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
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
