import 'dart:math';

enum GameStatus { playing, paused, won, lost }

class FallingEgg {
  final double x;
  final double y;
  final double speed;
  final bool good;

  const FallingEgg({
    required this.x,
    required this.y,
    required this.speed,
    required this.good,
  });

  FallingEgg copyWith({double? x, double? y}) {
    return FallingEgg(x: x ?? this.x, y: y ?? this.y, speed: speed, good: good);
  }
}

class GameState {
  final GameStatus status;
  final int score;
  final int lives;
  final List<FallingEgg> eggs;
  final double playerX;
  final int targetScore;
  final String missionDescription;
  final int level;

  const GameState({
    this.status = GameStatus.playing,
    this.score = 0,
    this.lives = 5,
    this.eggs = const [],
    this.playerX = 0.5,
    this.targetScore = 100,
    this.missionDescription = '',
    this.level = 1,
  });

  GameState copyWith({
    GameStatus? status,
    int? score,
    int? lives,
    List<FallingEgg>? eggs,
    double? playerX,
    int? targetScore,
    String? missionDescription,
    int? level,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      eggs: eggs ?? this.eggs,
      playerX: playerX ?? this.playerX,
      targetScore: targetScore ?? this.targetScore,
      missionDescription: missionDescription ?? this.missionDescription,
      level: level ?? this.level,
    );
  }
}

FallingEgg randomEgg(Random random) {
  final isGood = random.nextBool();
  return FallingEgg(
    x: random.nextDouble(),
    y: -0.1,
    speed: 0.0005 + random.nextDouble() * 0.01,
    good: isGood,
  );
}
