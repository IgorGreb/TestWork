import 'dart:math';

import 'package:flutter_riverpod/legacy.dart';

import '../levels/level_missions.dart';
import 'game_state.dart';

final gameControllerProvider =
    StateNotifierProvider.autoDispose.family<GameController, GameState, LevelMission>(
      (ref, mission) => GameController(mission),
    );

class GameController extends StateNotifier<GameState> {
  GameController(this.mission)
    : super(
        GameState(
          targetScore: mission.targetScore,
          missionDescription: mission.description,
          level: mission.level,
        ),
      ) {
    _spawnInitialEggs();
  }

  final LevelMission mission;

  final Random _random = Random();

  void _spawnInitialEggs() {
    final eggs = List.generate(3, (_) => randomEgg(_random));
    state = state.copyWith(eggs: eggs);
  }

  void movePlayer(double delta) {
    final newX = (state.playerX + delta).clamp(0.0, 1.0);
    state = state.copyWith(playerX: newX);
  }

  void setPlayerPosition(double value) {
    state = state.copyWith(playerX: value.clamp(0.0, 1.0));
  }

  void updateFrame({double deltaSeconds = 1 / 60}) {
    if (state.status != GameStatus.playing) return;
    final updatedEggs = <FallingEgg>[];
    var newScore = state.score;
    var lives = state.lives;
    final speedFactor = deltaSeconds / (1 / 60);

    for (final egg in state.eggs) {
      final newY = egg.y + egg.speed * speedFactor;
      if (newY >= 0.9) {
        final catchRange = (state.playerX - egg.x).abs() < 0.12;
        if (catchRange) {
          if (egg.good) {
            newScore += 10;
          } else {
            lives -= 1;
          }
        } else if (egg.good) {
          lives -= 1;
        }
      } else {
        updatedEggs.add(egg.copyWith(y: newY));
      }
    }

    while (updatedEggs.length < 4) {
      updatedEggs.add(randomEgg(_random));
    }

    var status = state.status;
    if (lives <= 0) {
      status = GameStatus.lost;
    } else if (newScore >= state.targetScore) {
      status = GameStatus.won;
    }

    state = state.copyWith(
      eggs: updatedEggs,
      score: newScore,
      lives: lives,
      status: status,
    );
  }

  void pause() {
    if (state.status == GameStatus.playing) {
      state = state.copyWith(status: GameStatus.paused);
    }
  }

  void resume() {
    if (state.status == GameStatus.paused) {
      state = state.copyWith(status: GameStatus.playing);
    }
  }

  void restart() {
    state = GameState(
      targetScore: mission.targetScore,
      missionDescription: mission.description,
      level: mission.level,
    );
    _spawnInitialEggs();
  }
}
