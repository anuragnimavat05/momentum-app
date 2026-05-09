import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  // User Document Reference
  DocumentReference userRef(String uid) => firestore.collection('users').doc(uid);

  // Collections
  CollectionReference goalsRef(String uid) => userRef(uid).collection('goals');
  CollectionReference tasksRef(String uid) => userRef(uid).collection('tasks');
  CollectionReference habitsRef(String uid) => userRef(uid).collection('habits');
  CollectionReference focusSessionsRef(String uid) => userRef(uid).collection('focusSessions');
  CollectionReference dailyLogsRef(String uid) => userRef(uid).collection('dailyLogs');
  CollectionReference achievementsRef(String uid) => userRef(uid).collection('achievements');
  CollectionReference aiChatsRef(String uid) => userRef(uid).collection('aiChats');
  CollectionReference futureMessagesRef(String uid) => userRef(uid).collection('futureMessages');

  // Current User
  String? get currentUserId => auth.currentUser?.uid;
  bool get isAuthenticated => currentUserId != null;

  // Auth State Stream
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Initialize Firebase
  Future<void> initialize() async {
    // Set persistence
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Request notification permissions
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    final token = await messaging.getToken();
    if (token != null && currentUserId != null) {
      await userRef(currentUserId!).update({'fcmToken': token});
    }
  }

  // Create User Profile
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    await userRef(uid).set({
      'email': email,
      'displayName': displayName ?? email.split('@').first,
      'createdAt': FieldValue.serverTimestamp(),
      'momentumScore': 50,
      'currentStreak': 0,
      'longestStreak': 0,
      'xp': 0,
      'level': 1,
      'totalFocusMinutes': 0,
      'completedTasks': 0,
      'completedGoals': 0,
      'lastActiveDate': FieldValue.serverTimestamp(),
      'onboardingCompleted': false,
      'preferences': {
        'reminderTime': '09:00',
        'dailyGoal': 5,
        'focusDuration': 25,
        'theme': 'dark',
      },
    });
  }

  // Update User Stats
  Future<void> updateUserStats({
    String? uid,
    int? momentumScore,
    int? currentStreak,
    int? longestStreak,
    int? xp,
    int? level,
    int? totalFocusMinutes,
    int? completedTasks,
    int? completedGoals,
  }) async {
    final userId = uid ?? currentUserId;
    if (userId == null) return;

    final updates = <String, dynamic>{};
    if (momentumScore != null) updates['momentumScore'] = momentumScore;
    if (currentStreak != null) updates['currentStreak'] = currentStreak;
    if (longestStreak != null) updates['longestStreak'] = longestStreak;
    if (xp != null) updates['xp'] = xp;
    if (level != null) updates['level'] = level;
    if (totalFocusMinutes != null) updates['totalFocusMinutes'] = totalFocusMinutes;
    if (completedTasks != null) updates['completedTasks'] = completedTasks;
    if (completedGoals != null) updates['completedGoals'] = completedGoals;
    updates['lastActiveDate'] = FieldValue.serverTimestamp();

    await userRef(userId).update(updates);
  }

  // Sign Out
  Future<void> signOut() async {
    await auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
