import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriplan_ai/core/theme/app_theme.dart';
import 'package:nutriplan_ai/providers/goal_provider.dart';
import 'package:nutriplan_ai/providers/meal_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrition = ref.watch(dailyNutritionProvider);
    final goal = ref.watch(goalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWeeklyTrendCard(context, goal?.targetCalories ?? 2000),
            const SizedBox(height: 16),
            _buildMacroBreakdownCard(context, nutrition),
            const SizedBox(height: 16),
            _buildInsightsCard(context, nutrition),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTrendCard(BuildContext context, int targetCalories) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Calorie Trend',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your calorie intake over the last 7 days.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: targetCalories * 1.5,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(color: Colors.grey, fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'Mon'; break;
                            case 1: text = 'Tue'; break;
                            case 2: text = 'Wed'; break;
                            case 3: text = 'Thu'; break;
                            case 4: text = 'Fri'; break;
                            case 5: text = 'Sat'; break;
                            case 6: text = 'Sun'; break;
                            default: text = ''; break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: targetCalories.toDouble() / 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1);
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarData(0, 1800, targetCalories),
                    _buildBarData(1, 2100, targetCalories),
                    _buildBarData(2, 1950, targetCalories),
                    _buildBarData(3, 2200, targetCalories),
                    _buildBarData(4, 2050, targetCalories),
                    _buildBarData(5, 1700, targetCalories),
                    _buildBarData(6, 1900, targetCalories),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y, int target) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y > target ? Colors.redAccent : AppTheme.primary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: target * 1.5,
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroBreakdownCard(BuildContext context, Map<String, double> nutrition) {
    final double totalMacros = nutrition['protein']! + nutrition['carbs']! + nutrition['fats']!;
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Macro Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: totalMacros == 0
                  ? const Center(child: Text('No data yet', style: TextStyle(color: Colors.grey)))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: nutrition['protein'],
                            title: '${((nutrition['protein']! / totalMacros) * 100).toStringAsFixed(0)}%',
                            radius: 60,
                            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          PieChartSectionData(
                            color: AppTheme.secondary,
                            value: nutrition['carbs'],
                            title: '${((nutrition['carbs']! / totalMacros) * 100).toStringAsFixed(0)}%',
                            radius: 60,
                            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          PieChartSectionData(
                            color: Colors.redAccent,
                            value: nutrition['fats'],
                            title: '${((nutrition['fats']! / totalMacros) * 100).toStringAsFixed(0)}%',
                            radius: 60,
                            titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
            ),
            if (totalMacros > 0) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem('Protein', Colors.blue),
                  _buildLegendItem('Carbs', AppTheme.secondary),
                  _buildLegendItem('Fats', Colors.redAccent),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInsightsCard(BuildContext context, Map<String, double> nutrition) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                'Personalized Insights',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            _buildInsightTile(
              icon: Icons.check_circle,
              iconColor: AppTheme.primary,
              title: 'Great Consistency!',
              subtitle: 'You have logged meals for 5 consecutive days. Keep the streak alive!',
            ),
            const Divider(height: 1),
            _buildInsightTile(
              icon: Icons.water_drop,
              iconColor: Colors.lightBlue,
              title: 'Hydration Check',
              subtitle: 'Don\'t forget to drink water! Aim for at least 8 glasses today.',
            ),
            const Divider(height: 1),
            _buildInsightTile(
              icon: Icons.warning_rounded,
              iconColor: AppTheme.secondary,
              title: 'Protein Intake',
              subtitle: nutrition['protein']! < 50
                  ? 'Your protein intake is a bit low today. Try adding some lean meat or beans.'
                  : 'Awesome! You are hitting your protein goals effectively.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightTile({required IconData icon, required Color iconColor, required String title, required String subtitle}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}
