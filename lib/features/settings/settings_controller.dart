import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_state.dart';

class SettingsKeys {
  static const sound = 'settings_sound';
  static const vibration = 'settings_vibration';
  static const notifications = 'settings_notifications';
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
      final controller = SettingsController();
      controller.load();
      return controller;
    });

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState());

  SharedPreferences? _prefs;

  Future<void> load() async {
    final prefs = await _ensurePrefs();
    state = SettingsState(
      soundEnabled: prefs.getBool(SettingsKeys.sound) ?? true,
      vibrationEnabled: prefs.getBool(SettingsKeys.vibration) ?? true,
      notificationsEnabled: prefs.getBool(SettingsKeys.notifications) ?? true,
    );
  }

  Future<bool> save(SettingsState newState) async {
    try {
      final prefs = await _ensurePrefs();
      await prefs.setBool(SettingsKeys.sound, newState.soundEnabled);
      await prefs.setBool(SettingsKeys.vibration, newState.vibrationEnabled);
      await prefs.setBool(
        SettingsKeys.notifications,
        newState.notificationsEnabled,
      );
      state = newState;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }
}
