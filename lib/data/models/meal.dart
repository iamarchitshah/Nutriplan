import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final int calories;

  @HiveField(4)
  final double protein;

  @HiveField(5)
  final double carbs;

  @HiveField(6)
  final double fats;

  @HiveField(7)
  final DateTime date;

  @HiveField(8)
  final String mealType; // Breakfast, Lunch, Dinner, Snack

  @HiveField(9)
  bool isSynced;

  Meal({
    required this.id,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.date,
    required this.mealType,
    this.isSynced = false,
  });

  Meal copyWith({
    String? id,
    String? name,
    double? quantity,
    int? calories,
    double? protein,
    double? carbs,
    double? fats,
    DateTime? date,
    String? mealType,
    bool? isSynced,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'isSynced': isSynced,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0.0).toDouble(),
      calories: map['calories']?.toInt() ?? 0,
      protein: (map['protein'] ?? 0.0).toDouble(),
      carbs: (map['carbs'] ?? 0.0).toDouble(),
      fats: (map['fats'] ?? 0.0).toDouble(),
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      mealType: map['mealType'] ?? '',
      isSynced: map['isSynced'] ?? false,
    );
  }
}
