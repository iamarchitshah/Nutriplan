import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nutriplan_ai/core/theme/app_theme.dart';
import 'package:nutriplan_ai/data/models/meal.dart';
import 'package:nutriplan_ai/providers/meal_provider.dart';

class MealPlanningScreen extends ConsumerWidget {
  const MealPlanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final meals = ref.watch(mealsForSelectedDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                ref.read(selectedDateProvider.notifier).setDate(date);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(context, selectedDate, ref),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMealSection(context, 'Breakfast', meals),
                const SizedBox(height: 16),
                _buildMealSection(context, 'Lunch', meals),
                const SizedBox(height: 16),
                _buildMealSection(context, 'Dinner', meals),
                const SizedBox(height: 16),
                _buildMealSection(context, 'Snacks', meals),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, DateTime selectedDate, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Theme.of(context).cardTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).setDate(
                  selectedDate.subtract(const Duration(days: 1)));
            },
          ),
          Text(
            DateFormat('EEEE, MMM d').format(selectedDate),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).setDate(
                  selectedDate.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String mealType, List<Meal> meals) {
    final sectionMeals = meals.where((m) => m.mealType == mealType).toList();
    final sectionCalories = sectionMeals.fold(0, (sum, m) => sum + m.calories);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mealType,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '$sectionCalories kcal',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
              ],
            ),
          ),
          if (sectionMeals.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No foods added yet',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sectionMeals.length,
              itemBuilder: (context, index) {
                final meal = sectionMeals[index];
                return Consumer(
                  builder: (context, ref, child) {
                    return Dismissible(
                      key: Key(meal.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        ref.read(mealProvider.notifier).deleteMeal(meal.id);
                      },
                      child: ListTile(
                        title: Text(meal.name),
                        subtitle: Text('${meal.quantity}g'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${meal.calories} kcal'),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                ref.read(mealProvider.notifier).deleteMeal(meal.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Meal deleted')),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          context.push('/add-food', extra: {'mealType': mealType, 'meal': meal});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          TextButton.icon(
            onPressed: () {
              context.push('/add-food', extra: {'mealType': mealType});
            },
            icon: const Icon(Icons.add),
            label: Text('ADD FOOD TO ${mealType.toUpperCase()}'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}
