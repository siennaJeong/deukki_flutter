
import 'dart:io';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class AnalyticsService {
  static const String PREFIX = "DEUKKI_";
  Amplitude analytics;
  String userId;
  String deviceName;
  String deviceModel;
  String deviceOS;
  String deviceOSVersion;
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
    userId = "";
    deviceName = "";
    deviceModel = "";
    deviceOS = "";
    deviceOSVersion = "";
  }

  setUserId(String userId) => this.userId = userId;

  Future<void> setUserProperties(String userId, String gender, String birthDate) async {
    /*if(!kDebugMode) {
      setUserId(userId);
      await analytics.setUserId(userId);
      await analytics.setUserProperties(
          <String, dynamic> {
            'gender': gender,
            'birthDate': birthDate
          }
      );
    }*/
  }

  Future<void> sendAnalyticsEvent(bool isVisited, bool isPremium, String page, String click, String subPage, String value) async {
    /*if(!kDebugMode) {
      var now = DateTime.now();
      packageInfo ??= await PackageInfo.fromPlatform();

      if(Platform.isIOS) {
        iosDeviceInfo ??= await deviceInfo.iosInfo;
        this.deviceName = iosDeviceInfo.model;
        this.deviceModel = iosDeviceInfo.utsname.machine;
        this.deviceOS = iosDeviceInfo.systemName;
        this.deviceOSVersion = iosDeviceInfo.systemVersion;
      }else {
        androidDeviceInfo ??= await deviceInfo.androidInfo;
        this.deviceName = androidDeviceInfo.model;
        this.deviceModel = androidDeviceInfo.device;
        this.deviceOS = "Android";
        this.deviceOSVersion = androidDeviceInfo.version.release;
      }

      await analytics.logEvent(
        "$PREFIX${Platform.isIOS ? 'ios' : 'and'}",
        eventProperties: <String, dynamic> {
          'log_type': isVisited ? 'visit' : 'action',
          'reg_date': '$now',
          'user_id': this.userId,
          'premium': isPremium ? 'premium' : 'free',
          'device_model': this.deviceModel,
          'device_name': this.deviceName,
          'device_os' : this.deviceOS,
          'device_os_version': this.deviceOSVersion,
          'deukki_version': packageInfo.version,
          'view': page,
          'click': click,
          'sub': subPage,
          'value': value
        }
      );
    }*/
  }
}