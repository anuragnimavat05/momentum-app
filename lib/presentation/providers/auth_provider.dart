import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _fetchUserData(currentUser.uid);
      if (!seenOnboarding) {
        // First time - show onboarding
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
        _status = AuthStatus.authenticated;
      } else {
        // Create new user document
        final newUser = UserModel(
          uid: uid,
          email: _auth.currentUser?.email ?? '',
          displayName: _auth.currentUser?.displayName,
          photoUrl: _auth.currentUser?.photoURL,
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(uid).set(newUser.toFirestore());
        _user = newUser;
        _status = AuthStatus.authenticated;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await _fetchUserData(credential.user!.uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await _fetchUserData(credential.user!.uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final GoogleAuthProvider provider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(provider);
      
      if (credential.user != null) {
        await _fetchUserData(credential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'popup-closed-by-user':
        return 'Sign in was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
