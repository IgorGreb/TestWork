import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameStatsRepository {
  static const String _bestScoreKeyPrefix = 'best_score_';
  SharedPreferences? _prefs;

  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<int> fetchBestScore(int level) async {
    final prefs = await _ensurePrefs();
    return prefs.getInt('$_bestScoreKeyPrefix$level') ?? 0;
  }

  Future<void> saveBestScore(int level, int score) async {
    final prefs = await _ensurePrefs();
    final current = prefs.getInt('$_bestScoreKeyPrefix$level') ?? 0;
    if (score > current) {
      await prefs.setInt('$_bestScoreKeyPrefix$level', score);
    }
  }
}

final gameStatsRepositoryProvider = Provider<GameStatsRepository>((ref) {
  return GameStatsRepository();
});
