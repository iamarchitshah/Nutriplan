import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:nutriplan_ai/data/models/meal.dart';
import 'package:nutriplan_ai/providers/meal_provider.dart';

class FoodEntryScreen extends ConsumerStatefulWidget {
  final String mealType;
  final Meal? existingMeal;

  const FoodEntryScreen({super.key, required this.mealType, this.existingMeal});

  @override
  ConsumerState<FoodEntryScreen> createState() => _FoodEntryScreenState();
}

class _FoodEntryScreenState extends ConsumerState<FoodEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _quantity = 100;
  int _calories = 0;
  double _protein = 0;
  double _carbs = 0;
  double _fats = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingMeal != null) {
      _name = widget.existingMeal!.name;
      _quantity = widget.existingMeal!.quantity;
      _calories = widget.existingMeal!.calories;
      _protein = widget.existingMeal!.protein;
      _carbs = widget.existingMeal!.carbs;
      _fats = widget.existingMeal!.fats;
    }
  }

  void _saveFood() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final date = ref.read(selectedDateProvider);

      final meal = Meal(
        id: widget.existingMeal?.id ?? const Uuid().v4(),
        name: _name,
        quantity: _quantity,
        calories: _calories,
        protein: _protein,
        carbs: _carbs,
        fats: _fats,
        date: widget.existingMeal?.date ?? date,
        mealType: widget.mealType,
      );

      if (widget.existingMeal != null) {
        ref.read(mealProvider.notifier).updateMeal(meal);
      } else {
        ref.read(mealProvider.notifier).addMeal(meal);
      }
      
      context.pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.existingMeal != null ? 'Meal updated successfully!' : 'Food added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingMeal != null ? 'Edit Food' : 'Add to ${widget.mealType}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: widget.existingMeal?.name,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity (g/ml)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: widget.existingMeal != null ? widget.existingMeal!.quantity.toString() : '100',
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null) return 'Invalid';
                        if (double.parse(value) <= 0) return 'Must be > 0';
                        return null;
                      },
                      onSaved: (value) => _quantity = double.parse(value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Calories (kcal)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: widget.existingMeal?.calories.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                      onSaved: (value) => _calories = int.parse(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Macronutrients (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: widget.existingMeal != null ? widget.existingMeal!.protein.toString() : '0',
                      onSaved: (value) => _protein = double.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Carbs (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: widget.existingMeal != null ? widget.existingMeal!.carbs.toString() : '0',
                      onSaved: (value) => _carbs = double.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fats (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: widget.existingMeal != null ? widget.existingMeal!.fats.toString() : '0',
                      onSaved: (value) => _fats = double.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveFood,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(widget.existingMeal != null ? 'Update Food' : 'Add Food', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
