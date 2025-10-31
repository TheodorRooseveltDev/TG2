import 'package:flutter/material.dart';
import 'package:project_2/screens/home_screen.dart';
import 'package:project_2/screens/onboarding_screen.dart';
import 'package:project_2/services/data_service.dart';

String appReportOneSignalString = "aa80cda6-d7ef-4efc-aa3a-cabfb91ab907";
String afDevKey1 = "hNYE575rnPs";
String afDevKey2 = "XhWgTXMRzpB";

String urlAppReportLink = "https://sweetspinandcook.com/app-report/";

String appReportParameter = "app-report";

String devKeypndAppId = "6754573538";

void openStandartAppLogic(BuildContext context) async {
  final dataService = DataService();

  // Clear onboarding status to start fresh (comment out after testing)
  await dataService.setOnboardingComplete(false);

  final isComplete = await dataService.isOnboardingComplete();

  // Create fade transition animation
  final targetScreen = isComplete
      ? const HomeScreen()
      : const OnboardingScreen();

  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
      transitionDuration: const Duration(milliseconds: 800),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Combined fade and scale animation
        final fadeInAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: fadeInAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
    ),
  );
}
