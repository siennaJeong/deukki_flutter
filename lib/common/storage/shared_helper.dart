
import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper {
  static Future<SharedPreferences> get _getSharedInstance async => _sharedPreferences ??= await SharedPreferences.getInstance();
  static SharedPreferences _sharedPreferences;

  SharedHelper() { initShared(); }

  static Future<SharedPreferences> initShared() async {
    _sharedPreferences = await _getSharedInstance;
    return _sharedPreferences;
  }

  setIntSharedPref(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  int getIntSharedPref(String key, [int defValue]) {
    return _sharedPreferences.getInt(key) ?? defValue ?? 0;
  }

  setStringSharedPref(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String getStringSharedPref(String key, [String defValue]) {
    return _sharedPreferences.getString(key) ?? defValue ?? "";
  }
}