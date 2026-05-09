import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLogModel {
  final String id;
  final String userId;
  final DateTime date;
  final int completedTasksCount;
  final int totalFocusMinutes;
  final int momentumAtEnd;
  final String? reflectionNote;
  final String? tomorrowPlan;

  DailyLogModel({
    required this.id,
    required this.userId,
    required this.date,
    this.completedTasksCount = 0,
    this.totalFocusMinutes = 0,
    this.momentumAtEnd = 50,
    this.reflectionNote,
    this.tomorrowPlan,
  });

  factory DailyLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyLogModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedTasksCount: data['completedTasksCount'] ?? 0,
      totalFocusMinutes: data['totalFocusMinutes'] ?? 0,
      momentumAtEnd: data['momentumAtEnd'] ?? 50,
      reflectionNote: data['reflectionNote'],
      tomorrowPlan: data['tomorrowPlan'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'completedTasksCount': completedTasksCount,
      'totalFocusMinutes': totalFocusMinutes,
      'momentumAtEnd': momentumAtEnd,
      'reflectionNote': reflectionNote,
      'tomorrowPlan': tomorrowPlan,
    };
  }

  DailyLogModel copyWith({
    int? completedTasksCount,
    int? totalFocusMinutes,
    int? momentumAtEnd,
    String? reflectionNote,
    String? tomorrowPlan,
  }) {
    return DailyLogModel(
      id: id,
      userId: userId,
      date: date,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      momentumAtEnd: momentumAtEnd ?? this.momentumAtEnd,
      reflectionNote: reflectionNote ?? this.reflectionNote,
      tomorrowPlan: tomorrowPlan ?? this.tomorrowPlan,
    );
  }
}
