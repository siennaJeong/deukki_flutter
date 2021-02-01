import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

abstract class BaseWidget extends StatefulWidget {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  IosDeviceInfo iosDeviceInfo;
  AndroidDeviceInfo androidDeviceInfo;
  PackageInfo packageInfo;
  String platform, deviceId, deviceModel, manufacturer, osVersion, appVersion;

  void _getDeviceInfo() async {
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
      deviceModel = androidDeviceInfo.device;
      manufacturer = androidDeviceInfo.manufacturer;
      osVersion = androidDeviceInfo.version.release;
    }
    appVersion = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _getDeviceInfo();
  }
}