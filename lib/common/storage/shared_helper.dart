
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper{
  SharedHelper._();
  static final SharedHelper _sharedHelper = SharedHelper._();
  factory SharedHelper() => _sharedHelper;

  static SharedPreferences _sharedPreferences;

  Future<SharedPreferences> get sharedPreference async {
    if(_sharedPreferences != null) return _sharedPreferences;
    _sharedPreferences = await initShared();
    return _sharedPreferences;
  }

  initShared() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  setIntSharedPref(String key, int value) async {
    final shared = await sharedPreference;
    await shared.setInt(key, value);
  }

  getIntSharedPref(String key, [int defValue]) async {
    final shared = await sharedPreference;
    return shared.getInt(key) ?? defValue ?? 0;
  }

  setStringSharedPref(String key, String value) async {
    final shared = await sharedPreference;
    await shared.setString(key, value);
  }

  getStringSharedPref(String key, [String defValue]) async {
    final shared = await sharedPreference;
    return shared.getString(key) ?? defValue ?? "";
  }

  removeAllShared() async {
    final shared = await sharedPreference;
    await shared.clear();
  }
}