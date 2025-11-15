import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'levels_state.dart';

class LevelsKeys {
  static const unlocked = 'levels_unlocked';
  static const completed = 'levels_completed';
}

final levelsControllerProvider =
    StateNotifierProvider<LevelsController, LevelsState>((ref) {
      final controller = LevelsController();
      controller.load();
      return controller;
    });

class LevelsController extends StateNotifier<LevelsState> {
  LevelsController() : super(const LevelsState());

  SharedPreferences? _prefs;

  Future<void> load() async {
    final prefs = await _ensurePrefs();
    final unlocked = prefs.getInt(LevelsKeys.unlocked) ?? 1;
    final completedList = prefs.getStringList(LevelsKeys.completed) ?? [];
    final completed = completedList.map(int.parse).toSet();
    state = state.copyWith(unlockedCount: unlocked, completedLevels: completed);
  }

  bool isLevelUnlocked(int level) => level <= state.unlockedCount;
  bool isLevelCompleted(int level) => state.completedLevels.contains(level);

  Future<void> unlockLevel(int level) async {
    if (level <= state.unlockedCount) return;
    final prefs = await _ensurePrefs();
    await prefs.setInt(LevelsKeys.unlocked, level);
    state = state.copyWith(unlockedCount: level);
  }

  Future<void> completeMission(int level) async {
    final newCompleted = Set<int>.from(state.completedLevels)..add(level);
    final nextLevel = level + 1;
    final newUnlocked = nextLevel > state.unlockedCount
        ? nextLevel
        : state.unlockedCount;
    final prefs = await _ensurePrefs();
    await prefs.setInt(LevelsKeys.unlocked, newUnlocked);
    await prefs.setStringList(
      LevelsKeys.completed,
      newCompleted.map((e) => e.toString()).toList(),
    );
    state = state.copyWith(
      unlockedCount: newUnlocked,
      completedLevels: newCompleted,
    );
  }

  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }
}
