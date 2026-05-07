import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:nutriplan_ai/data/models/goal.dart';

class PdfGenerator {
  static Future<void> generateWeeklyReport(Goal? goal, Map<String, double> nutrition) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('NutriPlan AI - Weekly Nutrition Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Summary for the past 7 days:', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                data: const <List<String>>[
                  <String>['Day', 'Calories', 'Protein', 'Carbs', 'Fats'],
                  <String>['Monday', '1800', '120', '150', '60'],
                  <String>['Tuesday', '2100', '140', '180', '70'],
                  <String>['Wednesday', '1950', '130', '160', '65'],
                  <String>['Thursday', '2200', '150', '200', '75'],
                  <String>['Friday', '2050', '135', '190', '70'],
                  <String>['Saturday', '1700', '110', '140', '55'],
                  <String>['Sunday', '1900', '125', '165', '60'],
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text('Today\'s Overview vs Goals:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Calories Consumed: ${nutrition['calories']?.toInt()} / ${goal?.targetCalories} kcal'),
              pw.Text('Protein: ${nutrition['protein']?.toStringAsFixed(1)} / ${goal?.targetProtein} g'),
              pw.Text('Carbs: ${nutrition['carbs']?.toStringAsFixed(1)} / ${goal?.targetCarbs} g'),
              pw.Text('Fats: ${nutrition['fats']?.toStringAsFixed(1)} / ${goal?.targetFats} g'),
              pw.SizedBox(height: 30),
              pw.Text('Keep up the great work! Consistent tracking leads to long-term success.', style: const pw.TextStyle(color: PdfColors.green)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'NutriPlan_Weekly_Report.pdf',
    );
  }
}
