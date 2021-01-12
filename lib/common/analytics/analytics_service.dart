
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info/package_info.dart';

class AnalyticsService {
  static const String PREFIX = "DEUKKI_";
  FirebaseAnalytics firebaseAnalytics;
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
    firebaseAnalytics = FirebaseAnalytics();
    userId = "";
    deviceName = "";
    deviceModel = "";
    deviceOS = "";
    deviceOSVersion = "";
  }

  setUserId(String userId) => this.userId = userId;

  Future<void> setUserProperties(String userId, String gender, String birthDate) async {
    setUserId(userId);
    await firebaseAnalytics.setUserId(userId);
    await firebaseAnalytics.setUserProperty(name: 'gender', value: gender);
    await firebaseAnalytics.setUserProperty(name: 'birthDate', value: birthDate);
  }

  Future<void> sendAnalyticsEvent(bool isVisited, bool isPremium, String page, String click, String subPage, String value) async {
    print("send analytics call");
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

    await firebaseAnalytics.logEvent(
      name: "$PREFIX${Platform.isIOS ? 'ios' : 'and'}",
      parameters: <String, String>{
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
  }
}