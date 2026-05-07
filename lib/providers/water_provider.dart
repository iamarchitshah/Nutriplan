import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterNotifier extends Notifier<int> {
  @override
  int build() {
    _loadWater();
    return 0;
  }

  Future<void> _loadWater() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _getDateKey();
    state = prefs.getInt(dateKey) ?? 0;
  }

  Future<void> addGlass() async {
    state++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_getDateKey(), state);
    
    // Manage streak if goal reached (e.g. 8 glasses)
    if (state == 8) {
      final lastStreakDate = prefs.getString('lastStreakDate');
      final today = _getDateKey();
      if (lastStreakDate != today) {
        int currentStreak = prefs.getInt('currentStreak') ?? 0;
        await prefs.setInt('currentStreak', currentStreak + 1);
        await prefs.setString('lastStreakDate', today);
      }
    }
  }

  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('currentStreak') ?? 0;
  }

  String _getDateKey() {
    final now = DateTime.now();
    return 'water_${now.year}_${now.month}_${now.day}';
  }
}

final waterProvider = NotifierProvider<WaterNotifier, int>(() {
  return WaterNotifier();
});

final streakProvider = FutureProvider<int>((ref) async {
  final notifier = ref.read(waterProvider.notifier);
  return notifier.getStreak();
});
