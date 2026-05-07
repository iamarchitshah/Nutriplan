import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriplan_ai/core/theme/app_theme.dart';
import 'package:nutriplan_ai/providers/auth_provider.dart';
import 'package:nutriplan_ai/providers/goal_provider.dart';
import 'package:nutriplan_ai/providers/theme_provider.dart';
import 'package:nutriplan_ai/data/models/goal.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _targetCalories = 2000;
  double _targetProtein = 150;
  double _targetCarbs = 200;
  double _targetFats = 65;
  double _weight = 70; // kg
  double _height = 175; // cm

  @override
  void initState() {
    super.initState();
    final currentGoal = ref.read(goalProvider);
    if (currentGoal != null) {
      _targetCalories = currentGoal.targetCalories;
      _targetProtein = currentGoal.targetProtein;
      _targetCarbs = currentGoal.targetCarbs;
      _targetFats = currentGoal.targetFats;
    }
  }

  void _saveGoals() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final currentGoal = ref.read(goalProvider);
      
      final updatedGoal = Goal(
        id: currentGoal?.id ?? 'default',
        targetCalories: _targetCalories,
        targetProtein: _targetProtein,
        targetCarbs: _targetCarbs,
        targetFats: _targetFats,
      );
      
      ref.read(goalProvider.notifier).updateGoal(updatedGoal);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goals updated successfully!')),
      );
    }
  }

  double _calculateBMI() {
    if (_height == 0) return 0;
    return _weight / ((_height / 100) * (_height / 100));
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark || (themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primary,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'My Nutrition Goals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  secondary: const Icon(Icons.dark_mode),
                  value: isDarkMode,
                  onChanged: (val) {
                    ref.read(themeProvider.notifier).toggleTheme(val);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildBMICalculator(context),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _targetCalories.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Daily Calories Target (kcal)',
                          prefixIcon: Icon(Icons.local_fire_department, color: AppTheme.secondary),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        onSaved: (value) => _targetCalories = int.parse(value!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _targetProtein.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Daily Protein Target (g)',
                          prefixIcon: Icon(Icons.fitness_center, color: Colors.blue),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        onSaved: (value) => _targetProtein = double.parse(value!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _targetCarbs.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Daily Carbs Target (g)',
                          prefixIcon: Icon(Icons.bakery_dining, color: AppTheme.secondary),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        onSaved: (value) => _targetCarbs = double.parse(value!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _targetFats.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Daily Fats Target (g)',
                          prefixIcon: Icon(Icons.water_drop, color: Colors.redAccent),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        onSaved: (value) => _targetFats = double.parse(value!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveGoals,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Goals & Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBMICalculator(BuildContext context) {
    final bmi = _calculateBMI();
    String category = 'Normal';
    Color bmiColor = AppTheme.primary;
    if (bmi < 18.5) {
      category = 'Underweight';
      bmiColor = Colors.blue;
    } else if (bmi >= 25 && bmi < 30) {
      category = 'Overweight';
      bmiColor = AppTheme.secondary;
    } else if (bmi >= 30) {
      category = 'Obese';
      bmiColor = Colors.redAccent;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_weight_outlined),
                SizedBox(width: 8),
                Text('BMI Calculator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _weight.toString(),
                    decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val != null) setState(() => _weight = val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _height.toString(),
                    decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final val = double.tryParse(v);
                      if (val != null) setState(() => _height = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your BMI: ${bmi.toStringAsFixed(1)}', style: const TextStyle(fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bmiColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(category, style: TextStyle(color: bmiColor, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
