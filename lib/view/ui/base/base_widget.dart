import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

abstract class BaseWidget extends StatefulWidget {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static IosDeviceInfo iosDeviceInfo;
  static AndroidDeviceInfo androidDeviceInfo;
  static PackageInfo packageInfo;
  static String platform, deviceId, deviceModel, manufacturer, osVersion, appVersion;
  static String fcmToken;

  static void getDeviceInfo() async {
    packageInfo ??= await PackageInfo.fromPlatform();
    if(Platform.isIOS) {
      iosDeviceInfo ??= await deviceInfoPlugin.iosInfo;
      platform = "ios";
      deviceId = iosDeviceInfo.identifierForVendor;
      deviceModel = iosDeviceInfo.utsname.machine;
      manufacturer = "apple";
      osVersion = iosDeviceInfo.systemVersion;
    }else {
      androidDeviceInfo ??= await deviceInfoPlugin.androidInfo;
      platform = "android";
      deviceId = androidDeviceInfo.androidId;
      deviceModel = androidDeviceInfo.model;
      manufacturer = androidDeviceInfo.manufacturer;
      osVersion = androidDeviceInfo.version.release;
    }
    appVersion = packageInfo.version;
  }

  static void fcmListener() {
    firebaseMessaging.getToken().then((token) {
      fcmToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
}