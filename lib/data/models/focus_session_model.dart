import 'package:cloud_firestore/cloud_firestore.dart';

class FocusSessionModel {
  final String id;
  final String userId;
  final int durationMinutes;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;

  FocusSessionModel({
    required this.id,
    required this.userId,
    required this.durationMinutes,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
  });

  factory FocusSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FocusSessionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      durationMinutes: data['durationMinutes'] ?? 25,
      startTime: (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'durationMinutes': durationMinutes,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'isCompleted': isCompleted,
    };
  }

  FocusSessionModel copyWith({
    int? durationMinutes,
    DateTime? endTime,
    bool? isCompleted,
  }) {
    return FocusSessionModel(
      id: id,
      userId: userId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  int get actualDuration {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }
}
