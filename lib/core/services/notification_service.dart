/// Notification Service
/// Handles all app notifications - both local and remote
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;

  /// Smart motivational notifications
  static const List<Map<String, String>> _motivationalNotifications = [
    {'title': 'One small action keeps momentum alive', 'body': 'You\'re just 5 minutes away from progress.'},
    {'title': 'Protect your streak', 'body': 'Complete a task today to keep your streak going!'},
    {'title': 'Your future self is waiting', 'body': 'The best time to start was yesterday. The next best time is now.'},
    {'title': 'Progress over perfection', 'body': 'Don\'t wait for perfect. Just start.'},
    {'title': 'Small steps = big changes', 'body': 'What\'s one tiny action you could take today?'},
    {'title': 'Momentum is building', 'body': 'Every action you take is a vote for who you want to become.'},
    {'title': 'You\'ve got this', 'body': 'Remember why you started. One step at a time.'},
    {'title': 'Consistency > Intensity', 'body': 'Showing up every day matters more than doing everything at once.'},
  ];

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  /// Get random motivational notification
  Map<String, String> getRandomNotification() {
    final index = DateTime.now().millisecond % _motivationalNotifications.length;
    return _motivationalNotifications[index];
  }

  /// Get notification based on momentum
  Map<String, String> getMomentumNotification(int momentum) {
    if (momentum < 20) {
      return {'title': 'Let\'s restart your momentum', 'body': 'One small action can turn this around. You\'ve got this!'};
    } else if (momentum < 50) {
      return {'title': 'Building momentum', 'body': 'Keep going! Every action builds momentum.'};
    } else {
      return {'title': 'Momentum is on your side!', 'body': 'You\'re doing amazing. Stay consistent!'};
    }
  }

  /// Get notification based on streak
  Map<String, String> getStreakNotification(int streak) {
    if (streak == 0) {
      return {'title': 'Start your journey today', 'body': 'Begin building your streak with one small action.'};
    } else if (streak < 7) {
      return {'title': 'Protect your $streak-day streak', 'body': 'You\'re doing great! Keep the momentum going.'};
    } else {
      return {'title': '$streak days and counting!', 'body': 'Amazing consistency! Your dedication is inspiring.'};
    }
  }

  /// Get reminder notification
  Map<String, String> getReminderNotification() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return {'title': 'Good morning!', 'body': 'What\'s your main goal for today?'};
    } else if (hour < 17) {
      return {'title': 'Afternoon check-in', 'body': 'How\'s your progress going today?'};
    } else {
      return {'title': 'Evening wind-down', 'body': 'Review your day and plan for tomorrow.'};
    }
  }
}
