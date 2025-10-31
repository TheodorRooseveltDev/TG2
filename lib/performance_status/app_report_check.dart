import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'package:flutter/material.dart';
import 'package:project_2/performance_status/app_report_parameters.dart';
import 'package:project_2/performance_status/app_report_service.dart';
import 'package:project_2/performance_status/app_report_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic appReportConversionData;
String? appReportTrackingStatus;
String? appReportAdvertisingId;
String? appReportLink;

String? appReportAppsflyerId;
String? appReportExternalId;

late SharedPreferences appReportCheckSharedPreferences;

class AppReportCheck extends StatefulWidget {
  const AppReportCheck({super.key});

  @override
  State<AppReportCheck> createState() => _AppReportCheckState();
}

class _AppReportCheckState extends State<AppReportCheck> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appReportCheckSharedPreferences = await SharedPreferences.getInstance();
      await Future.delayed(const Duration(milliseconds: 500));

      initAll();
    });
  }

  initAll() async {
    await Future.delayed(Duration(milliseconds: 10));
    bool appReportSent =
        appReportCheckSharedPreferences.getBool("appReportSent") ?? false;
    appReportLink = appReportCheckSharedPreferences.getString("link");

    if (appReportLink != null && appReportLink != "" && !appReportSent) {
      AppReportService().navigateToAppReportWebView(context);
    } else {
      if (appReportSent) {
        AppReportService().navigateToAppReportSplash(context);
      } else {
        initializeMainPart();
      }
    }
  }

  void initializeMainPart() async {
    await AppReportService().requestUserSafeTrackingPermission();
    await AppReportService().initializeOneSignal();
    await takeAppReportParams();
  }

  Future<void> createAppReportLink() async {
    Map<dynamic, dynamic> parameters = appReportConversionData;

    parameters.addAll({
      "track_status": appReportTrackingStatus,
      "${appReportParameter}_id": appReportAdvertisingId,
      "appsflyer_id": appReportAppsflyerId,
      "external_id": appReportExternalId,
    });

    String? link = await AppReportService().sendAppReportRequest(parameters);

    appReportLink = link;

    if (appReportLink == "" || appReportLink == null) {
      AppReportService().navigateToAppReportSplash(context);
    } else {
      appReportCheckSharedPreferences.setString(
        "link",
        appReportLink.toString(),
      );
      appReportCheckSharedPreferences.setBool("success", true);
      AppReportService().navigateToAppReportWebView(context);
    }
  }

  Future<void> takeAppReportParams() async {
    final appsFlyerOptions = AppReportService()
        .createAppReportAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);
    appReportAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();
    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    appsFlyerSdk.onInstallConversionData((res) async {
      appReportConversionData = res;
      await createAppReportLink();
    });

    appsFlyerSdk.startSDK(
      onError: (errorCode, errorMessage) {
        AppReportService().navigateToAppReportSplash(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppReportSplash();
  }
}
