import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:nutriplan_ai/core/theme/app_theme.dart';
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
  
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingMeal?.name ?? '');
    _quantityController = TextEditingController(text: widget.existingMeal?.quantity.toString() ?? '100');
    _caloriesController = TextEditingController(text: widget.existingMeal?.calories.toString() ?? '');
    _proteinController = TextEditingController(text: widget.existingMeal?.protein.toString() ?? '0');
    _carbsController = TextEditingController(text: widget.existingMeal?.carbs.toString() ?? '0');
    _fatsController = TextEditingController(text: widget.existingMeal?.fats.toString() ?? '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _saveFood() {
    if (_formKey.currentState!.validate()) {
      final date = ref.read(selectedDateProvider);

      final meal = Meal(
        id: widget.existingMeal?.id ?? const Uuid().v4(),
        name: _nameController.text,
        quantity: double.tryParse(_quantityController.text) ?? 100,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        protein: double.tryParse(_proteinController.text) ?? 0,
        carbs: double.tryParse(_carbsController.text) ?? 0,
        fats: double.tryParse(_fatsController.text) ?? 0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => _showBarcodeScanner(context),
            tooltip: 'Scan Barcode',
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity (g/ml)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null) return 'Invalid';
                        if (double.parse(value) <= 0) return 'Must be > 0';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(
                        labelText: 'Calories (kcal)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
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
                      controller: _proteinController,
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: const InputDecoration(
                        labelText: 'Carbs (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatsController,
                      decoration: const InputDecoration(
                        labelText: 'Fats (g)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
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

  void _showBarcodeScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 300,
          child: Column(
            children: [
              const Text('Scan Food Barcode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner, color: Colors.white, size: 64),
                      SizedBox(height: 8),
                      Text('Scanning...', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  setState(() {
                    _nameController.text = 'Oatmeal (Scanned)';
                    _caloriesController.text = '150';
                    _proteinController.text = '5';
                    _carbsController.text = '27';
                    _fatsController.text = '3';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food found via barcode!')),
                  );
                },
                child: const Text('Simulate Successful Scan'),
              )
            ],
          ),
        );
      }
    );
  }
}
