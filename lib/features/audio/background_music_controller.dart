import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundMusicController {
  BackgroundMusicController() {
    _player.setReleaseMode(ReleaseMode.loop);
    _player.setVolume(_defaultVolume);
  }

  final AudioPlayer _player = AudioPlayer();
  static const double _defaultVolume = 0.35;
  static const String _assetPath = 'sounds/winning-loop-228639.mp3';

  bool _enabled = true;
  bool _isPlaying = false;

  Future<void> setMusicEnabled(bool enabled) async {
    _enabled = enabled;
    if (_enabled) {
      await _ensurePlaying();
    } else {
      await _pauseIfNeeded();
    }
  }

  Future<void> pause() => _pauseIfNeeded();

  Future<void> _ensurePlaying() async {
    if (_isPlaying) return;
    await _player.play(
      AssetSource(_assetPath),
      volume: _defaultVolume,
    );
    _isPlaying = true;
  }

  Future<void> _pauseIfNeeded() async {
    if (!_isPlaying) return;
    await _player.pause();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}

final backgroundMusicControllerProvider =
    Provider<BackgroundMusicController>((ref) {
      final controller = BackgroundMusicController();
      ref.onDispose(controller.dispose);
      return controller;
    });
