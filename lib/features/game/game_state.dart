import 'board_position.dart';

enum GameStatus { playing, paused, won, lost }

class GameState {
  final GameStatus status;
  final int score;
  final int coinsEarned;
  final int movesLeft;
  final List<List<int>> board;
  final int? selectedRow;
  final int? selectedCol;
  final List<BoardPosition>? hintPositions;
  final DateTime lastInteraction;
  final int targetScore;
  final String missionDescription;
  final int level;
  final int timeLeftSeconds;
  final int timeLimitSeconds;
  final int bestScore;

  GameState({
    this.status = GameStatus.playing,
    this.score = 0,
    this.coinsEarned = 0,
    this.movesLeft = 25,
    this.board = const [],
    this.selectedRow,
    this.selectedCol,
    this.hintPositions,
    DateTime? lastInteraction,
    this.targetScore = 100,
    this.missionDescription = '',
    this.level = 1,
    this.timeLeftSeconds = 0,
    this.timeLimitSeconds = 0,
    this.bestScore = 0,
  }) : lastInteraction = lastInteraction ?? DateTime.now();

  GameState copyWith({
    GameStatus? status,
    int? score,
    int? coinsEarned,
    int? movesLeft,
    List<List<int>>? board,
    int? selectedRow,
    int? selectedCol,
    List<BoardPosition>? hintPositions,
    DateTime? lastInteraction,
    int? targetScore,
    String? missionDescription,
    int? level,
    int? timeLeftSeconds,
    int? timeLimitSeconds,
    int? bestScore,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      movesLeft: movesLeft ?? this.movesLeft,
      board: board ?? this.board,
      selectedRow: selectedRow,
      selectedCol: selectedCol,
      hintPositions: hintPositions,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      targetScore: targetScore ?? this.targetScore,
      missionDescription: missionDescription ?? this.missionDescription,
      level: level ?? this.level,
      timeLeftSeconds: timeLeftSeconds ?? this.timeLeftSeconds,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      bestScore: bestScore ?? this.bestScore,
    );
  }
}
