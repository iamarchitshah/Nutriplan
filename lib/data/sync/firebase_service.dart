import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:nutriplan_ai/data/models/goal.dart';
import 'package:nutriplan_ai/data/models/meal.dart';

class FirebaseService {
  static bool _isInitialized = false;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Firebase initialization failed (probably missing config): $e');
      _isInitialized = false;
    }
  }

  static bool get isConfigured => _isInitialized;

  static String? get currentUserId {
    if (!isConfigured) return 'mock_user_id';
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> syncMeal(Meal meal) async {
    if (!isConfigured || currentUserId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('meals')
          .doc(meal.id)
          .set(meal.toMap());
    } catch (e) {
      debugPrint('Failed to sync meal: $e');
    }
  }

  static Future<void> deleteMeal(String mealId) async {
    if (!isConfigured || currentUserId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('meals')
          .doc(mealId)
          .delete();
    } catch (e) {
      debugPrint('Failed to delete meal: $e');
    }
  }

  static Future<void> syncGoal(Goal goal) async {
    if (!isConfigured || currentUserId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('goals')
          .doc(goal.id)
          .set(goal.toMap());
    } catch (e) {
      debugPrint('Failed to sync goal: $e');
    }
  }

  static Future<void> login(String email, String password) async {
    if (!isConfigured) return;
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signup(String email, String password) async {
    if (!isConfigured) return;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> logout() async {
    if (!isConfigured) return;
    await FirebaseAuth.instance.signOut();
  }
}
