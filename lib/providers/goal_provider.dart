import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriplan_ai/data/local/hive_service.dart';
import 'package:nutriplan_ai/data/models/goal.dart';

class GoalNotifier extends Notifier<Goal?> {
  @override
  Goal? build() {
    return HiveService.getGoal() ?? Goal(
      id: 'default',
      targetCalories: 2000,
      targetProtein: 150,
      targetCarbs: 200,
      targetFats: 65,
    );
  }

  Future<void> updateGoal(Goal goal) async {
    await HiveService.saveGoal(goal);
    state = goal;
  }
}

final goalProvider = NotifierProvider<GoalNotifier, Goal?>(() {
  return GoalNotifier();
});
