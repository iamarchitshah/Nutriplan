import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriplan_ai/data/local/hive_service.dart';
import 'package:nutriplan_ai/data/models/meal.dart';

class MealNotifier extends Notifier<List<Meal>> {
  @override
  List<Meal> build() {
    return HiveService.getAllMeals();
  }

  Future<void> addMeal(Meal meal) async {
    await HiveService.saveMeal(meal);
    state = HiveService.getAllMeals();
  }

  Future<void> updateMeal(Meal meal) async {
    await HiveService.saveMeal(meal);
    state = HiveService.getAllMeals();
  }

  Future<void> deleteMeal(String id) async {
    await HiveService.deleteMeal(id);
    state = HiveService.getAllMeals();
  }
}

final mealProvider = NotifierProvider<MealNotifier, List<Meal>>(() {
  return MealNotifier();
});

class DateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setDate(DateTime date) {
    state = date;
  }
}

final selectedDateProvider = NotifierProvider<DateNotifier, DateTime>(() {
  return DateNotifier();
});

final mealsForSelectedDateProvider = Provider<List<Meal>>((ref) {
  final meals = ref.watch(mealProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return meals.where((meal) {
    return meal.date.year == selectedDate.year &&
        meal.date.month == selectedDate.month &&
        meal.date.day == selectedDate.day;
  }).toList();
});

final dailyNutritionProvider = Provider<Map<String, double>>((ref) {
  final meals = ref.watch(mealsForSelectedDateProvider);
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fats = 0;

  for (var meal in meals) {
    calories += meal.calories;
    protein += meal.protein;
    carbs += meal.carbs;
    fats += meal.fats;
  }

  return {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
  };
});
