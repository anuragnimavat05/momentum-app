import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/focus_session_model.dart';
import '../../data/models/daily_log_model.dart';

class DataProvider extends ChangeNotifier {
  UserModel? _currentUser;
  List<GoalModel> _goals = [];
  List<TaskModel> _tasks = [];
  List<FocusSessionModel> _focusSessions = [];
  DailyLogModel? _todayLog;
  bool _isLoading = false;
  TaskModel? _suggestedTask;
  
  // Getters
  UserModel? get currentUser => _currentUser;
  List<GoalModel> get goals => _goals;
  List<GoalModel> get activeGoals => _goals.where((g) => !g.isCompleted).toList();
  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get todayTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<FocusSessionModel> get focusSessions => _focusSessions;
  DailyLogModel? get todayLog => _todayLog;
  bool get isLoading => _isLoading;
  TaskModel? get suggestedTask => _suggestedTask;
  
  // Computed values
  int get momentumScore => _currentUser?.momentumScore ?? 50;
  int get currentStreak => _currentUser?.currentStreak ?? 0;
  int get totalFocusMinutes => _focusSessions.fold(0, (sum, s) => sum + s.durationMinutes);
  int get todayFocusMinutes => _focusSessions.where((s) => 
    s.startTime.day == DateTime.now().day && 
    s.startTime.month == DateTime.now().month &&
    s.startTime.year == DateTime.now().year
  ).fold(0, (sum, s) => sum + s.durationMinutes);
  
  // Initialize with demo data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    // Load demo user
    _currentUser = UserModel(
      uid: 'demo_user',
      email: 'demo@momentum.app',
      displayName: 'Demo User',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      momentumScore: 72,
      currentStreak: 5,
      longestStreak: 12,
      xp: 1250,
      level: 13,
      totalFocusMinutes: 2580,
      completedTasks: 89,
      completedGoals: 3,
      lastActiveDate: DateTime.now(),
    );
    
    // Load demo goals
    _goals = _generateDemoGoals();
    _tasks = _generateDemoTasks();
    _focusSessions = _generateDemoFocusSessions();
    _suggestedTask = _getSmartSuggestion();
    
    _isLoading = false;
    notifyListeners();
  }
  
  List<GoalModel> _generateDemoGoals() {
    return [
      GoalModel(
        id: 'goal_1',
        userId: 'demo_user',
        title: 'Grow my YouTube channel',
        why: 'I want freedom and confidence to express myself and help others through video content.',
        category: 'YouTube',
        targetDate: DateTime.now().add(const Duration(days: 180)),
        progress: 35,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        nextAction: 'Record a 2-minute intro video',
        milestones: [
          Milestone(id: 'm1', title: 'Reach 100 subscribers', isCompleted: true),
          Milestone(id: 'm2', title: 'Post first video', isCompleted: true),
          Milestone(id: 'm3', title: 'Reach 500 subscribers', isCompleted: false),
          Milestone(id: 'm4', title: 'Get monetized', isCompleted: false),
        ],
      ),
      GoalModel(
        id: 'goal_2',
        userId: 'demo_user',
        title: 'Get fit and strong',
        why: 'I want to feel confident, energetic, and healthy for my family.',
        category: 'Fitness',
        targetDate: DateTime.now().add(const Duration(days: 90)),
        progress: 60,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        nextAction: 'Do 20 pushups',
        milestones: [
          Milestone(id: 'm1', title: 'Lose first 5 lbs', isCompleted: true),
          Milestone(id: 'm2', title: 'Run 5K without stopping', isCompleted: true),
          Milestone(id: 'm3', title: 'Do 20 pushups in a row', isCompleted: false),
        ],
      ),
      GoalModel(
        id: 'goal_3',
        userId: 'demo_user',
        title: 'Master Flutter Development',
        why: 'I want to build my own apps and potentially start a freelance career.',
        category: 'Skills',
        targetDate: DateTime.now().add(const Duration(days: 120)),
        progress: 25,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        nextAction: 'Complete 1 Flutter tutorial',
        milestones: [
          Milestone(id: 'm1', title: 'Build first app', isCompleted: true),
          Milestone(id: 'm2', title: 'Learn state management', isCompleted: false),
          Milestone(id: 'm3', title: 'Create portfolio app', isCompleted: false),
        ],
      ),
    ];
  }
  
  List<TaskModel> _generateDemoTasks() {
    return [
      TaskModel(
        id: 'task_1',
        goalId: 'goal_1',
        userId: 'demo_user',
        title: 'Record YouTube intro video',
        priority: 'High',
        category: 'Content',
        createdAt: DateTime.now(),
        suggestedAction: 'Record a 2-minute video',
      ),
      TaskModel(
        id: 'task_2',
        goalId: 'goal_2',
        userId: 'demo_user',
        title: 'Morning workout',
        priority: 'High',
        recurringType: 'Daily',
        category: 'Fitness',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        suggestedAction: 'Do 20 pushups and 50 situps',
      ),
      TaskModel(
        id: 'task_3',
        goalId: 'goal_3',
        userId: 'demo_user',
        title: 'Flutter state management tutorial',
        priority: 'Medium',
        category: 'Learning',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        suggestedAction: 'Watch 15 minutes of tutorial',
      ),
      TaskModel(
        id: 'task_4',
        goalId: 'goal_1',
        userId: 'demo_user',
        title: 'Write video description',
        priority: 'Low',
        category: 'Content',
        createdAt: DateTime.now(),
        suggestedAction: 'Write 3 bullet points',
      ),
      TaskModel(
        id: 'task_5',
        userId: 'demo_user',
        title: 'Review daily progress',
        priority: 'Medium',
        recurringType: 'Daily',
        category: 'General',
        createdAt: DateTime.now(),
        suggestedAction: 'Write 3 things you accomplished today',
      ),
    ];
  }
  
  List<FocusSessionModel> _generateDemoFocusSessions() {
    final sessions = <FocusSessionModel>[];
    final random = Random();
    
    for (int i = 7; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final sessionCount = random.nextInt(3) + 1;
      
      for (int j = 0; j < sessionCount; j++) {
        final startHour = 9 + j * 2;
        sessions.add(FocusSessionModel(
          id: 'session_${i}_$j',
          userId: 'demo_user',
          durationMinutes: 25,
          startTime: DateTime(date.year, date.month, date.day, startHour, 0),
          endTime: DateTime(date.year, date.month, date.day, startHour, 25),
          isCompleted: true,
        ));
      }
    }
    
    return sessions;
  }
  
  TaskModel? _getSmartSuggestion() {
    // Get highest priority incomplete task that isn't recurring
    final incomplete = _tasks.where((t) => !t.isCompleted).toList();
    if (incomplete.isEmpty) return null;
    
    // Sort by priority
    incomplete.sort((a, b) {
      final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      return (priorityOrder[a.priority] ?? 1).compareTo(priorityOrder[b.priority] ?? 1);
    });
    
    return incomplete.first;
  }
  
  // Actions
  Future<void> completeTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task.copyWith(isCompleted: true);
      _currentUser = _currentUser?.copyWith(
        completedTasks: (_currentUser?.completedTasks ?? 0) + 1,
        momentumScore: min(100, (_currentUser?.momentumScore ?? 50) + AppConstants.momentumGainPerTask),
        xp: (_currentUser?.xp ?? 0) + AppConstants.xpPerTask,
      );
      _checkLevelUp();
      _suggestedTask = _getSmartSuggestion();
    }
    notifyListeners();
  }
  
  Future<void> startFocusSession(int minutes) async {
    final session = FocusSessionModel(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser?.uid ?? 'demo_user',
      durationMinutes: minutes,
      startTime: DateTime.now(),
      isCompleted: false,
    );
    _focusSessions.add(session);
    notifyListeners();
  }
  
  Future<void> completeFocusSession(FocusSessionModel session) async {
    final index = _focusSessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      final completed = session.copyWith(
        endTime: DateTime.now(),
        isCompleted: true,
      );
      _focusSessions[index] = completed;
      _currentUser = _currentUser?.copyWith(
        totalFocusMinutes: (_currentUser?.totalFocusMinutes ?? 0) + session.durationMinutes,
        momentumScore: min(100, (_currentUser?.momentumScore ?? 50) + 3),
        xp: (_currentUser?.xp ?? 0) + AppConstants.xpPerFocusSession,
      );
      _checkLevelUp();
    }
    notifyListeners();
  }
  
  void _checkLevelUp() {
    if (_currentUser == null) return;
    final newXp = _currentUser!.xp;
    final newLevel = (newXp / AppConstants.xpPerLevel).floor() + 1;
    if (newLevel > _currentUser!.level && newLevel <= AppConstants.maxLevel) {
      _currentUser = _currentUser!.copyWith(level: newLevel);
    }
  }
  
  Future<void> addGoal(GoalModel goal) async {
    _goals.add(goal);
    notifyListeners();
  }
  
  Future<void> updateGoal(GoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }
  
  Future<void> addTask(TaskModel task) async {
    _tasks.add(task);
    _suggestedTask = _getSmartSuggestion();
    notifyListeners();
  }
  
  Future<void> completeGoal(GoalModel goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal.copyWith(isCompleted: true, progress: 100);
      _currentUser = _currentUser?.copyWith(
        completedGoals: (_currentUser?.completedGoals ?? 0) + 1,
        momentumScore: 100,
        xp: (_currentUser?.xp ?? 0) + 100,
      );
      _checkLevelUp();
    }
    notifyListeners();
  }
  
  String getAiSuggestion() {
    final quotes = AppConstants.motivationalQuotes;
    return quotes[DateTime.now().minute % quotes.length];
  }
  
  String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return AppConstants.timeGreetings['morning']!;
    if (hour >= 12 && hour < 17) return AppConstants.timeGreetings['afternoon']!;
    if (hour >= 17 && hour < 21) return AppConstants.timeGreetings['evening']!;
    return AppConstants.timeGreetings['night']!;
  }
}
