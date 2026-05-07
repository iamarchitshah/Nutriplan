import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int targetCalories;

  @HiveField(2)
  final double targetProtein;

  @HiveField(3)
  final double targetCarbs;

  @HiveField(4)
  final double targetFats;

  @HiveField(5)
  bool isSynced;

  Goal({
    required this.id,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
    this.isSynced = false,
  });

  Goal copyWith({
    String? id,
    int? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFats,
    bool? isSynced,
  }) {
    return Goal(
      id: id ?? this.id,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFats: targetFats ?? this.targetFats,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
      'isSynced': isSynced,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] ?? '',
      targetCalories: map['targetCalories']?.toInt() ?? 0,
      targetProtein: (map['targetProtein'] ?? 0.0).toDouble(),
      targetCarbs: (map['targetCarbs'] ?? 0.0).toDouble(),
      targetFats: (map['targetFats'] ?? 0.0).toDouble(),
      isSynced: map['isSynced'] ?? false,
    );
  }
}
