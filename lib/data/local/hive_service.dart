import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutriplan_ai/data/models/goal.dart';
import 'package:nutriplan_ai/data/models/meal.dart';

class HiveService {
  static const String _mealBoxName = 'meals_box';
  static const String _goalBoxName = 'goals_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(MealAdapter());
    Hive.registerAdapter(GoalAdapter());

    await Hive.openBox<Meal>(_mealBoxName);
    await Hive.openBox<Goal>(_goalBoxName);

    // Seed data
    if (mealBox.isEmpty) {
      final now = DateTime.now();
      await saveMeal(Meal(id: '1', name: 'Oatmeal', quantity: 150, calories: 200, protein: 5, carbs: 35, fats: 4, date: now, mealType: 'Breakfast'));
      await saveMeal(Meal(id: '2', name: 'Banana', quantity: 100, calories: 105, protein: 1, carbs: 27, fats: 0, date: now, mealType: 'Breakfast'));
      await saveMeal(Meal(id: '3', name: 'Grilled Chicken Salad', quantity: 300, calories: 450, protein: 40, carbs: 15, fats: 20, date: now, mealType: 'Lunch'));
      await saveMeal(Meal(id: '4', name: 'Almonds', quantity: 30, calories: 160, protein: 6, carbs: 6, fats: 14, date: now, mealType: 'Snacks'));
      await saveMeal(Meal(id: '5', name: 'Salmon & Rice', quantity: 350, calories: 600, protein: 45, carbs: 50, fats: 20, date: now, mealType: 'Dinner'));
    }
  }

  static Box<Meal> get mealBox => Hive.box<Meal>(_mealBoxName);
  static Box<Goal> get goalBox => Hive.box<Goal>(_goalBoxName);

  static Future<void> saveMeal(Meal meal) async {
    await mealBox.put(meal.id, meal);
  }

  static Future<void> deleteMeal(String id) async {
    await mealBox.delete(id);
  }

  static List<Meal> getAllMeals() {
    return mealBox.values.toList();
  }

  static Future<void> saveGoal(Goal goal) async {
    await goalBox.put(goal.id, goal);
  }

  static Goal? getGoal() {
    if (goalBox.isNotEmpty) {
      return goalBox.values.first;
    }
    return null;
  }
}
