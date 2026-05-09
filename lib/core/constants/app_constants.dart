class AppConstants {
  // App Info
  static const String appName = 'Momentum';
  static const String appVersion = '1.0.0';
  
  // Momentum
  static const int maxMomentumScore = 100;
  static const int minMomentumScore = 0;
  static const int momentumDecayRate = 2;
  static const int momentumGainPerTask = 5;
  static const int momentumGainPerStreak = 10;
  
  // Focus Mode
  static const int defaultPomodoroMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int sessionsUntilLongBreak = 4;
  
  // Gamification
  static const int xpPerTask = 10;
  static const int xpPerFocusSession = 25;
  static const int xpPerStreak = 50;
  static const int xpPerLevel = 100;
  static const int maxLevel = 50;
  
  // Goal Categories
  static const List<String> goalCategories = [
    'Fitness',
    'Study',
    'Business',
    'YouTube',
    'Skills',
    'Money',
    'Travel',
    'Creative',
    'Health',
    'Relationships',
    'Other',
  ];
  
  // Category Icons (Material Icons code points)
  static const Map<String, int> categoryIcons = {
    'Fitness': 0xe3a9,
    'Study': 0xe80c,
    'Business': 0xe0af,
    'YouTube': 0xe063,
    'Skills': 0xea3f,
    'Money': 0xef63,
    'Travel': 0xe539,
    'Creative': 0xe405,
    'Health': 0xe3fc,
    'Relationships': 0xe7fb,
    'Other': 0xe5d3,
  };
  
  // Task Priorities
  static const List<String> taskPriorities = ['High', 'Medium', 'Low'];
  
  // Recurring Types
  static const List<String> recurringTypes = [
    'None',
    'Daily',
    'Weekly',
    'Weekdays',
    'Custom',
  ];
  
  // Motivational Quotes
  static const List<String> motivationalQuotes = [
    "The only way to do great work is to love what you do.",
    "Success is the sum of small efforts repeated day in and day out.",
    "Don't watch the clock; do what it does. Keep going.",
    "The future depends on what you do today.",
    "Motivation gets you started. Habit keeps you going.",
    "Small steps in the right direction can turn out to be the biggest step of your life.",
    "You don't have to be great to start, but you have to start to be great.",
    "Your only limit is your mind.",
    "Progress, not perfection.",
    "Every action you take is a vote for the type of person you wish to become.",
    "The secret of getting ahead is getting started.",
    "It's never too late to be what you might have been.",
    "Dreams don't work unless you do.",
    "Focus on the step in front of you, not the whole staircase.",
    "Consistency is what transforms average into excellence.",
  ];
  
  // AI Coach Messages
  static const List<String> aiEncouragement = [
    "Take a deep breath. You've got this!",
    "Every expert was once a beginner. Start now!",
    "Perfect is the enemy of good. Just begin!",
    "One small step leads to massive change.",
    "Your future self will thank you for starting today.",
    "Don't think about the whole journey. Just take the next step.",
    "Momentum is built one action at a time.",
    "The hard part is showing up. You're already halfway there!",
    "You have the power to change your story. Start now!",
    "Progress, not perfection. That's the key.",
  ];
  
  // Anti-Procrastination Prompts
  static const Map<String, List<String>> procrastinationPrompts = {
    'too_hard': [
      "Let's break this into smaller pieces.",
      "What's the smallest first step?",
      "Can you do just 5 minutes?",
    ],
    'too_boring': [
      "How can we make this more interesting?",
      "What's the end result you want?",
      "Listen to music while doing this.",
    ],
    'low_energy': [
      "Take a 5-minute break first.",
      "Have some water and rest.",
      "Try the 2-minute rule.",
    ],
    'distracted': [
      "Close other apps.",
      "Put your phone away.",
      "Try 25 minutes of focus.",
    ],
  };
  
  // Time-Based Greetings
  static const Map<String, String> timeGreetings = {
    'morning': 'Good morning, Champion! ☀️',
    'afternoon': 'Good afternoon, Warrior!',
    'evening': 'Good evening, Legend! 🌙',
    'night': 'Time to rest, Star! 💫',
  };
}
