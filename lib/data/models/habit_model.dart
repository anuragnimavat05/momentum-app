import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String userId;
  final String title;
  final String? why;
  final String category;
  final String frequency; // daily, weekdays, weekly
  final List<String> reminderTimes;
  final DateTime createdAt;
  final bool isActive;
  final int currentStreak;
  final int longestStreak;
  final List<DateTime> completionHistory;

  HabitModel({
    required this.id,
    required this.userId,
    required this.title,
    this.why,
    required this.category,
    this.frequency = 'daily',
    this.reminderTimes = const [],
    required this.createdAt,
    this.isActive = true,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completionHistory = const [],
  });

  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final history = (data['completionHistory'] as List<dynamic>?)
        ?.map((e) => (e as Timestamp).toDate())
        .toList() ?? [];
    return HabitModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      why: data['why'],
      category: data['category'] ?? 'General',
      frequency: data['frequency'] ?? 'daily',
      reminderTimes: List<String>.from(data['reminderTimes'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      completionHistory: history,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'why': why,
      'category': category,
      'frequency': frequency,
      'reminderTimes': reminderTimes,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completionHistory': completionHistory.map((d) => Timestamp.fromDate(d)).toList(),
    };
  }

  HabitModel copyWith({
    String? title,
    String? why,
    String? category,
    String? frequency,
    List<String>? reminderTimes,
    bool? isActive,
    int? currentStreak,
    int? longestStreak,
    List<DateTime>? completionHistory,
  }) {
    return HabitModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      why: why ?? this.why,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completionHistory: completionHistory ?? this.completionHistory,
    );
  }

  bool get completedToday {
    final now = DateTime.now();
    return completionHistory.any((d) =>
        d.year == now.year && d.month == now.month && d.day == now.day);
  }
}
