import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(key, value);
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  Future<double?> getDouble(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(key);
  }
}