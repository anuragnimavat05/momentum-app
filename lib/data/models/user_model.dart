import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final int momentumScore;
  final int currentStreak;
  final int longestStreak;
  final int xp;
  final int level;
  final int totalFocusMinutes;
  final int completedTasks;
  final int completedGoals;
  final DateTime? lastActiveDate;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.momentumScore = 50,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.xp = 0,
    this.level = 1,
    this.totalFocusMinutes = 0,
    this.completedTasks = 0,
    this.completedGoals = 0,
    this.lastActiveDate,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      momentumScore: data['momentumScore'] ?? 50,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      xp: data['xp'] ?? 0,
      level: data['level'] ?? 1,
      totalFocusMinutes: data['totalFocusMinutes'] ?? 0,
      completedTasks: data['completedTasks'] ?? 0,
      completedGoals: data['completedGoals'] ?? 0,
      lastActiveDate: (data['lastActiveDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'momentumScore': momentumScore,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'xp': xp,
      'level': level,
      'totalFocusMinutes': totalFocusMinutes,
      'completedTasks': completedTasks,
      'completedGoals': completedGoals,
      'lastActiveDate': lastActiveDate != null ? Timestamp.fromDate(lastActiveDate!) : null,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? momentumScore,
    int? currentStreak,
    int? longestStreak,
    int? xp,
    int? level,
    int? totalFocusMinutes,
    int? completedTasks,
    int? completedGoals,
    DateTime? lastActiveDate,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      momentumScore: momentumScore ?? this.momentumScore,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      completedTasks: completedTasks ?? this.completedTasks,
      completedGoals: completedGoals ?? this.completedGoals,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
