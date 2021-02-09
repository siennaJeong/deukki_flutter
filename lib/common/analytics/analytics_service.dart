
import 'dart:io';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class AnalyticsService {
  static const String VISIT = "Visit ";
  Amplitude analytics;
  String deviceModel;
  String deviceOS;
  DeviceInfoPlugin deviceInfo;
  IosDeviceInfo iosDeviceInfo;
  AndroidDeviceInfo androidDeviceInfo;
  PackageInfo packageInfo;
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() {
    return _instance;
  }
  AnalyticsService._internal() {
    deviceInfo = DeviceInfoPlugin();
    analytics = Amplitude.getInstance();
    analytics.init("436822ec0eeba1a00fd758661220bf7a");
    analytics.enableCoppaControl();
    deviceModel = "";
    deviceOS = "";
  }

  Map<String, dynamic> _userPropertiesJson(String deviceModel, String deviceOS, String appVersion, bool premium, String gender, String birthDate) => <String, dynamic> {
    'deviceModel': deviceModel,
    'deviceOS': deviceOS,
    'appVersion': appVersion,
    'premium': '$premium',
    'gender': gender.isNotEmpty ? gender : 'null',
    'birthDate': birthDate.isNotEmpty ? birthDate : 'null'
  };

  Future<void> setUserProperties(bool premium, String gender, String birthDate) async {
    packageInfo ??= await PackageInfo.fromPlatform();

    if(Platform.isIOS) {
      iosDeviceInfo ??= await deviceInfo.iosInfo;
      this.deviceOS = iosDeviceInfo.systemName;
      this.deviceModel = iosDeviceInfo.utsname.machine;
    }else {
      androidDeviceInfo ??= await deviceInfo.androidInfo;
      this.deviceOS = "Android";
      this.deviceModel = androidDeviceInfo.device;
    }

    if(!kDebugMode) {
      await analytics.setUserProperties(_userPropertiesJson(deviceModel, deviceOS, packageInfo.version, premium, gender, birthDate));
    }else {
      print("Amplitude set properties : ${_userPropertiesJson(deviceModel, deviceOS, packageInfo.version, premium, gender, birthDate)}");
    }
  }

  Future<void> sendAnalyticsEvent(String eventName, Map<String, dynamic> eventProperties) async {
    if(!kDebugMode) {
      if(eventProperties == null) {
        await analytics.logEvent(eventName);
      }else {
        await analytics.logEvent(eventName, eventProperties: eventProperties);
      }
    }else {
      print("Amplitude log event : eventName $eventName, eventProperty : ${eventProperties.toString()}");
    }
  }
}