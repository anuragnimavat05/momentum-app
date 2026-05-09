import 'dart:math';

/// Smart Momentum Engine
/// Calculates and manages momentum based on user behavior
class MomentumEngine {
  static final MomentumEngine _instance = MomentumEngine._internal();
  factory MomentumEngine() => _instance;
  MomentumEngine._internal();

  // Momentum constants
  static const int maxMomentum = 100;
  static const int minMomentum = 0;
  static const int defaultMomentum = 50;

  // Points
  static const int pointsPerTask = 5;
  static const int pointsPerFocusSession = 3;
  static const int pointsPerStreak = 10;
  static const int dailyDecay = 2;
  static const int streakProtection = 5; // Days before streak breaks

  /// Calculate momentum changes based on user actions
  MomentumResult calculateMomentum({
    required int currentMomentum,
    required int currentStreak,
    required int longestStreak,
    required DateTime lastActiveDate,
    required int completedTasksToday,
    required int completedFocusSessions,
    required DateTime now,
  }) {
    // Check if user was active yesterday
    final daysSinceLastActive = now.difference(lastActiveDate).inDays;

    // Calculate momentum change
    int momentumChange = 0;
    String reason = '';
    List<String> achievements = [];

    // 1. Task completion bonus
    if (completedTasksToday > 0) {
      momentumChange += completedTasksToday * pointsPerTask;
      reason = completedTasksToday == 1 
          ? 'Great job completing a task!' 
          : 'Amazing work! $completedTasksToday tasks done!';
    }

    // 2. Focus session bonus
    if (completedFocusSessions > 0) {
      momentumChange += completedFocusSessions * pointsPerFocusSession;
      achievements.add('Focus Champion');
    }

    // 3. Streak bonus (every 7 days)
    if (currentStreak > 0 && currentStreak % 7 == 0) {
      momentumChange += pointsPerStreak * 2;
      achievements.add('Week Warrior');
    }

    // 4. Longest streak achievement
    if (currentStreak > longestStreak) {
      achievements.add('New Record!');
    }

    // 5. Daily decay
    if (daysSinceLastActive > 0) {
      momentumChange -= daysSinceLastActive * dailyDecay;
      
      if (daysSinceLastActive >= streakProtection) {
        // Streak broken - additional penalty
        momentumChange -= 10;
        achievements.add('Let\'s Start Fresh');
      }
    }

    // Calculate new momentum
    int newMomentum = (currentMomentum + momentumChange).clamp(minMomentum, maxMomentum);

    // Calculate new streak
    int newStreak = currentStreak;
    if (daysSinceLastActive <= 1 && completedTasksToday > 0) {
      newStreak = currentStreak + 1;
    } else if (daysSinceLastActive > streakProtection) {
      newStreak = 0;
    }

    // Generate feedback messages based on momentum
    String feedback = _getMomentumFeedback(newMomentum);

    return MomentumResult(
      momentum: newMomentum,
      momentumChange: momentumChange,
      streak: newStreak,
      feedback: feedback,
      achievements: achievements,
      level: _calculateLevel(currentStreak, completedTasksToday),
    );
  }

  String _getMomentumFeedback(int momentum) {
    if (momentum >= 90) return "You're on fire! 🔥 Keep it going!";
    if (momentum >= 70) return "Strong momentum! You're doing amazing!";
    if (momentum >= 50) return "Building nicely. One step at a time.";
    if (momentum >= 30) return "Let's rebuild that momentum!";
    if (momentum >= 10) return "A fresh start awaits. One small action?";
    return "Let's begin again. You've got this! 💪";
  }

  int _calculateLevel(int streak, int tasksToday) {
    // Simple level calculation based on streak and daily tasks
    return (streak ~/ 7) + (tasksToday ~/ 3) + 1;
  }

  /// Get streak status message
  StreakInfo getStreakInfo({
    required int currentStreak,
    required int longestStreak,
    required DateTime lastActiveDate,
  }) {
    final now = DateTime.now();
    final daysSince = now.difference(lastActiveDate).inDays;
    
    bool isAtRisk = daysSince == 1;
    bool isBroken = daysSince > 1;
    
    String message;
    if (isBroken) {
      message = "Let's build a new streak!";
    } else if (currentStreak >= longestStreak) {
      message = "New record! $currentStreak days!";
    } else if (currentStreak >= 7) {
      message = "Amazing consistency! $currentStreak days!";
    } else if (isAtRisk) {
      message = "Complete a task today to save your streak!";
    } else {
      message = "$currentStreak day streak. Keep going!";
    }
    
    return StreakInfo(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      isAtRisk: isAtRisk,
      isBroken: isBroken,
      message: message,
    );
  }

  /// Get XP needed for next level
  int xpForLevel(int level) {
    return level * 100;
  }

  /// Calculate daily goal recommendation
  int getRecommendedDailyGoal(int currentMomentum) {
    if (currentMomentum >= 70) return 5;
    if (currentMomentum >= 50) return 3;
    if (currentMomentum >= 30) return 2;
    return 1;
  }

  /// Get focus session recommendation
  int getRecommendedFocusDuration(int currentMomentum) {
    if (currentMomentum >= 70) return 45;
    if (currentMomentum >= 50) return 25;
    return 15;
  }
}

class MomentumResult {
  final int momentum;
  final int momentumChange;
  final int streak;
  final String feedback;
  final List<String> achievements;
  final int level;

  MomentumResult({
    required this.momentum,
    required this.momentumChange,
    required this.streak,
    required this.feedback,
    required this.achievements,
    required this.level,
  });
}

class StreakInfo {
  final int currentStreak;
  final int longestStreak;
  final bool isAtRisk;
  final bool isBroken;
  final String message;

  StreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    required this.isAtRisk,
    required this.isBroken,
    required this.message,
  });
}
