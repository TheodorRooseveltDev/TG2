import 'package:flutter/material.dart';
import 'package:project_2/performance_status/app_report_check.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CookAndSpinApp());
}

class CookAndSpinApp extends StatelessWidget {
  const CookAndSpinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweet Spin \'n\' Cook',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppReportCheck(),
    );
  }
}
