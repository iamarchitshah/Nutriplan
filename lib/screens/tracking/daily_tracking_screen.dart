import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriplan_ai/core/theme/app_theme.dart';
import 'package:nutriplan_ai/providers/auth_provider.dart';
import 'package:nutriplan_ai/providers/goal_provider.dart';
import 'package:nutriplan_ai/providers/meal_provider.dart';

class DailyTrackingScreen extends ConsumerWidget {
  const DailyTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(goalProvider);
    final nutrition = ref.watch(dailyNutritionProvider);

    if (goal == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final caloriesConsumed = nutrition['calories']!;
    final caloriesRemaining = goal.targetCalories - caloriesConsumed;
    final progress = (caloriesConsumed / goal.targetCalories).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Overview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieCard(context, caloriesConsumed, caloriesRemaining, progress, goal.targetCalories),
            const SizedBox(height: 24),
            Text(
              'Macronutrients',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildMacroCard(
              context,
              'Protein',
              nutrition['protein']!,
              goal.targetProtein,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildMacroCard(
              context,
              'Carbs',
              nutrition['carbs']!,
              goal.targetCarbs,
              AppTheme.secondary,
            ),
            const SizedBox(height: 12),
            _buildMacroCard(
              context,
              'Fats',
              nutrition['fats']!,
              goal.targetFats,
              Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCard(
    BuildContext context,
    double consumed,
    double remaining,
    double progress,
    int target,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  consumed.toInt().toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                ),
                const Text('Consumed'),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    color: AppTheme.primary,
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.local_fire_department, color: AppTheme.secondary),
                    Text(
                      target.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Goal', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  remaining > 0 ? remaining.toInt().toString() : '0',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text('Remaining'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(
    BuildContext context,
    String title,
    double consumed,
    double target,
    Color color,
  ) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${consumed.toStringAsFixed(1)}g / ${target.toStringAsFixed(1)}g',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.2),
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
