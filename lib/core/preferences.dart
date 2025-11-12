import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', name);
  }

  static Future<String?> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('player_name');
  }

  static Future<void> saveSettings(Map<String, bool> settings) async {
    final prefs = await SharedPreferences.getInstance();
    settings.forEach((key, value) async {
      await prefs.setBool(key, value);
    });
  }

  static Future<Map<String, bool>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'sound': prefs.getBool('sound') ?? true,
      'vibration': prefs.getBool('vibration') ?? true,
      'notifications': prefs.getBool('notifications') ?? true,
    };
  }
}
