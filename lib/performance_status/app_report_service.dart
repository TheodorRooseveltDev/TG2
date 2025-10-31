import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:project_2/performance_status/app_report_check.dart';
import 'package:project_2/performance_status/app_report_parameters.dart';
import 'package:project_2/performance_status/app_report_web_view.dart';

import 'package:uuid/uuid.dart';

class AppReportService {
  Future<void> initializeOneSignal() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Location.setShared(false);
    OneSignal.initialize(appReportOneSignalString);
    await Future.delayed(const Duration(seconds: 1));
    await OneSignal.Notifications.requestPermission(true);
    appReportExternalId = Uuid().v1();
    try {
      OneSignal.login(appReportExternalId!);
    } catch (_) {}
  }

  Future navigateToAppReportSplash(BuildContext context) async {
    appReportCheckSharedPreferences.setBool("appReportSent", true);
    openStandartAppLogic(context);
  }

  void navigateToAppReportWebView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppReportWebView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  AppsFlyerOptions createAppReportAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (afDevKey1 + afDevKey2),
      appId: devKeypndAppId,
      timeToWaitForATTUserAuthorization: 7,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> requestUserSafeTrackingPermission() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(seconds: 2));
        final status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        appReportTrackingStatus = status.toString();

        if (status == TrackingStatus.authorized) {
          getAppReportAdvertisingId();
        }
        if (status == TrackingStatus.notDetermined) {
          final status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          appReportTrackingStatus = status.toString();

          if (status == TrackingStatus.authorized) {
            getAppReportAdvertisingId();
          }
        }
      }
    }
  }

  Future<void> getAppReportAdvertisingId() async {
    try {
      appReportAdvertisingId = await AdvertisingId.id(true);
    } catch (_) {}
  }

  Future<String?> sendAppReportRequest(Map<dynamic, dynamic> parameters) async {
    try {
      final jsonString = json.encode(parameters);
      final base64Parameters = base64.encode(utf8.encode(jsonString));

      final requestBody = {appReportParameter: base64Parameters};

      final response = await http.post(
        Uri.parse(urlAppReportLink),
        body: requestBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
