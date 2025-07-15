import 'package:expensetracker_pro/presentation/home_dashboard/home_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };
  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final ValueNotifier<bool> useDarkTheme = ValueNotifier(false);

  MyApp({super.key});

  void toggleTheme() {
    useDarkTheme.value = !useDarkTheme.value;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return ValueListenableBuilder<bool>(
        valueListenable: useDarkTheme,
        builder: (context, isDark, _) {
          return MaterialApp(
            title: 'expensetracker_pro',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            home: HomeDashboard(
              toggleTheme: toggleTheme, // ⬅️ Pass this to allow toggling
            ),
            initialRoute: AppRoutes.initial,
          );
        },
      );
    });
  }
}
