import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutriplan_ai/core/router/app_router.dart';
import 'package:nutriplan_ai/core/theme/app_theme.dart';
import 'package:nutriplan_ai/data/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: NutriPlanApp(),
    ),
  );
}

class NutriPlanApp extends ConsumerWidget {
  const NutriPlanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'NutriPlan AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
