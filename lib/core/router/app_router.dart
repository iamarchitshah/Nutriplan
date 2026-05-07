import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriplan_ai/data/models/meal.dart';
import 'package:nutriplan_ai/providers/auth_provider.dart';
import 'package:nutriplan_ai/screens/analytics/analytics_screen.dart';
import 'package:nutriplan_ai/screens/auth/login_screen.dart';
import 'package:nutriplan_ai/screens/auth/signup_screen.dart';
import 'package:nutriplan_ai/screens/profile/profile_screen.dart';
import 'package:nutriplan_ai/screens/food_entry/food_entry_screen.dart';
import 'package:nutriplan_ai/screens/home/home_screen.dart';
import 'package:nutriplan_ai/screens/planning/meal_planning_screen.dart';
import 'package:nutriplan_ai/screens/search/search_screen.dart';
import 'package:nutriplan_ai/screens/tracking/daily_tracking_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    initialLocation: isLoggedIn ? '/' : '/login',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/signup';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DailyTrackingScreen(),
          ),
          GoRoute(
            path: '/planning',
            builder: (context, state) => const MealPlanningScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/add-food',
        builder: (context, state) {
          final extraMap = state.extra as Map<String, dynamic>? ?? {};
          final mealType = extraMap['mealType'] as String? ?? 'Snack';
          final meal = extraMap['meal']; // Meal type is dynamic/Object here due to import
          return FoodEntryScreen(
            mealType: mealType,
            existingMeal: meal,
          );
        },
      ),
    ],
  );
});
