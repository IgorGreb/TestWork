import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../levels/level_missions.dart';
import '../shop/shop_controller.dart';
import 'board_position.dart';
import 'egg_assets.dart';
import 'game_state.dart';
import 'game_stats_repository.dart';

final gameControllerProvider = StateNotifierProvider.autoDispose
    .family<GameController, GameState, LevelMission>(
      (ref, mission) => GameController(ref, mission),
    );

class GameController extends StateNotifier<GameState> {
  GameController._(this._ref, this.mission, this._stats)
    : super(
        GameState(
          targetScore: mission.targetScore,
          missionDescription: mission.description,
          level: mission.level,
          timeLimitSeconds: mission.timeLimitSeconds,
          timeLeftSeconds: mission.timeLimitSeconds,
        ),
      ) {
    _initializeGame();
  }

  final Ref _ref;
  final LevelMission mission;
  final Random _random = Random();
  final GameStatsRepository _stats;
  Timer? _countdownTimer;
  bool _bonusGranted = false;
  static const int _baseWinBonus = 5;
  static const int _bonusPerMove = 2;

  factory GameController(Ref ref, LevelMission mission) {
    final stats = ref.read(gameStatsRepositoryProvider);
    return GameController._(ref, mission, stats);
  }

  Future<void> _initializeGame() async {
    final best = await _stats.fetchBestScore(mission.level);
    final board = await _generatePlayableBoardAsync();
    if (!mounted) return;
    state = state.copyWith(
      board: board,
      hintPositions: null,
      lastInteraction: DateTime.now(),
      bestScore: best,
      timeLimitSeconds: mission.timeLimitSeconds,
      timeLeftSeconds: mission.timeLimitSeconds,
    );
    _startTimer();
  }

  Future<List<List<int>>> _generatePlayableBoardAsync() {
    final seed = _random.nextInt(1 << 32);
    final assetCount = eggAssetPaths.length;
    return Isolate.run(
      () => _generatePlayableBoardInIsolate(
        rows: boardRows,
        cols: boardCols,
        assetCount: assetCount,
        seed: seed,
      ),
    );
  }

  Future<void> selectCell(int row, int col) async {
    if (state.status != GameStatus.playing || state.movesLeft <= 0) return;
    final selectedRow = state.selectedRow;
    final selectedCol = state.selectedCol;

    if (selectedRow == null || selectedCol == null) {
      _setSelection(row, col);
      return;
    }

    if (selectedRow == row && selectedCol == col) {
      _clearSelection();
      return;
    }

    if (!_areAdjacent(selectedRow, selectedCol, row, col)) {
      _setSelection(row, col);
      return;
    }

    await _attemptSwap(selectedRow, selectedCol, row, col);
  }

  void _setSelection(int row, int col) {
    state = state.copyWith(
      selectedRow: row,
      selectedCol: col,
      hintPositions: null,
      lastInteraction: DateTime.now(),
    );
  }

  void _clearSelection() {
    state = state.copyWith(
      selectedRow: null,
      selectedCol: null,
      hintPositions: null,
      lastInteraction: DateTime.now(),
    );
  }

  bool _areAdjacent(int r1, int c1, int r2, int c2) {
    return (r1 == r2 && (c1 - c2).abs() == 1) ||
        (c1 == c2 && (r1 - r2).abs() == 1);
  }

  Future<void> _attemptSwap(int r1, int c1, int r2, int c2) async {
    final board = _cloneBoard(state.board);
    _swap(board, r1, c1, r2, c2);
    final groups = _detectMatchGroups(board);

    if (groups.isEmpty) {
      _clearSelection();
      return;
    }

    await _resolveBoard(board, groups, state.movesLeft - 1);
  }

  void _swap(List<List<int>> board, int r1, int c1, int r2, int c2) {
    final temp = board[r1][c1];
    board[r1][c1] = board[r2][c2];
    board[r2][c2] = temp;
  }

  List<List<int>> _cloneBoard(List<List<int>> board) {
    return board.map((row) => List<int>.from(row)).toList();
  }

  List<List<BoardPosition>> _detectMatchGroups(List<List<int>> board) {
    final groups = <List<BoardPosition>>[];

    // Horizontal scan finds streaks with the same asset id.
    for (int row = 0; row < boardRows; row++) {
      int start = 0;
      while (start < boardCols) {
        int end = start + 1;
        while (end < boardCols && board[row][start] == board[row][end]) {
          end++;
        }
        final length = end - start;
        if (length >= 3) {
          groups.add([
            for (int col = start; col < end; col++) BoardPosition(row, col),
          ]);
        }
        start = end;
      }
    }

    // Vertical scan does the same for columns to catch "T" or "+" combos.
    for (int col = 0; col < boardCols; col++) {
      int start = 0;
      while (start < boardRows) {
        int end = start + 1;
        while (end < boardRows && board[start][col] == board[end][col]) {
          end++;
        }
        final length = end - start;
        if (length >= 3) {
          groups.add([
            for (int row = start; row < end; row++) BoardPosition(row, col),
          ]);
        }
        start = end;
      }
    }

    // Detect 2x2 squares so players can clear blocks even without a line.
    for (int row = 0; row < boardRows - 1; row++) {
      for (int col = 0; col < boardCols - 1; col++) {
        final value = board[row][col];
        if (value == board[row][col + 1] &&
            value == board[row + 1][col] &&
            value == board[row + 1][col + 1]) {
          groups.add([
            BoardPosition(row, col),
            BoardPosition(row, col + 1),
            BoardPosition(row + 1, col),
            BoardPosition(row + 1, col + 1),
          ]);
        }
      }
    }

    return groups;
  }

  Future<void> _resolveBoard(
    List<List<int>> board,
    List<List<BoardPosition>> groups,
    int movesLeft,
  ) async {
    if (movesLeft < 0) movesLeft = 0;
    var newScore = state.score;
    var coins = state.coinsEarned;

    var workingGroups = groups;
    while (workingGroups.isNotEmpty) {
      final removeSet = <BoardPosition>{};
      for (final group in workingGroups) {
        removeSet.addAll(group);
        newScore += group.length * 10;
        if (group.length > 3) {
          coins += 1;
          HapticFeedback.mediumImpact();
        }
      }
      _removePositions(board, removeSet);
      // After clearing a batch we collapse and scan again to allow combos
      // triggered by the falling pieces.
      _collapseBoard(board);
      workingGroups = _detectMatchGroups(board);
    }

    var status = state.status;
    if (newScore >= state.targetScore) {
      status = GameStatus.won;
    } else if (movesLeft <= 0) {
      status = GameStatus.lost;
    }

    final coinsDelta = coins - state.coinsEarned;
    if (coinsDelta > 0) {
      _ref.read(shopControllerProvider.notifier).earnCoins(coinsDelta);
    }

    if (status == GameStatus.won || status == GameStatus.lost) {
      _stopTimer();
    }

    var updatedBest = state.bestScore;
    if (status == GameStatus.won && newScore > state.bestScore) {
      await _stats.saveBestScore(mission.level, newScore);
      updatedBest = newScore;
    }

    final playableBoard = await _ensurePlayableBoard(board);

    state = state.copyWith(
      board: playableBoard,
      score: newScore,
      coinsEarned: coins,
      movesLeft: movesLeft,
      status: status,
      selectedRow: null,
      selectedCol: null,
      hintPositions: null,
      lastInteraction: DateTime.now(),
      bestScore: updatedBest,
    );
  }

  void _removePositions(List<List<int>> board, Set<BoardPosition> toRemove) {
    for (final pos in toRemove) {
      board[pos.row][pos.col] = -1;
    }
  }

  void _collapseBoard(List<List<int>> board) {
    for (int col = 0; col < boardCols; col++) {
      int writeRow = boardRows - 1;
      for (int row = boardRows - 1; row >= 0; row--) {
        final value = board[row][col];
        if (value != -1) {
          board[writeRow][col] = value;
          writeRow--;
        }
      }
      while (writeRow >= 0) {
        // Spawn new random eggs above the gap once everything fell down.
        board[writeRow][col] = _random.nextInt(eggAssetPaths.length);
        writeRow--;
      }
    }
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

  Future<void> restart() async {
    _stopTimer();
    final best = await _stats.fetchBestScore(mission.level);
    final board = await _generatePlayableBoardAsync();
    if (!mounted) return;
    _bonusGranted = false;
    state = GameState(
      board: board,
      targetScore: mission.targetScore,
      missionDescription: mission.description,
      level: mission.level,
      timeLimitSeconds: mission.timeLimitSeconds,
      timeLeftSeconds: mission.timeLimitSeconds,
      bestScore: best,
    );
    _startTimer();
  }

  void finalizeCoins() {
    if (_bonusGranted || state.status != GameStatus.won) return;
    final movesBonus = state.movesLeft * _bonusPerMove;
    final totalBonus = _baseWinBonus + movesBonus;
    _bonusGranted = true;
    if (totalBonus <= 0) return;
    _ref.read(shopControllerProvider.notifier).earnCoins(totalBonus);
    state = state.copyWith(
      coinsEarned: state.coinsEarned + totalBonus,
      lastInteraction: DateTime.now(),
    );
  }

  void requestHint() {
    if (state.status != GameStatus.playing || state.board.isEmpty) return;
    final hint = _findHint(state.board);
    if (hint != null) {
      state = state.copyWith(
        hintPositions: hint,
        lastInteraction: DateTime.now(),
      );
    }
  }

  List<BoardPosition>? _findHint(List<List<int>> board) {
    for (int row = 0; row < boardRows; row++) {
      for (int col = 0; col < boardCols; col++) {
        if (col + 1 < boardCols) {
          final clone = _cloneBoard(board);
          _swap(clone, row, col, row, col + 1);
          // Look ahead to see if a simple swap yields a valid group.
          final matches = _detectMatchGroups(clone);
          if (matches.isNotEmpty) return matches.first;
        }
        if (row + 1 < boardRows) {
          final clone = _cloneBoard(board);
          _swap(clone, row, col, row + 1, col);
          // Return the first detected match to highlight on the board.
          final matches = _detectMatchGroups(clone);
          if (matches.isNotEmpty) return matches.first;
        }
      }
    }
    return null;
  }

  Future<List<List<int>>> _ensurePlayableBoard(List<List<int>> board) async {
    if (_findHint(board) != null) {
      return _cloneBoard(board);
    }
    return _generatePlayableBoardAsync();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (state.status != GameStatus.playing) return;
      final remaining = state.timeLeftSeconds - 1;
      if (remaining <= 0) {
        _handleTimeExpired();
      } else {
        state = state.copyWith(timeLeftSeconds: remaining);
      }
    });
  }

  void _handleTimeExpired() {
    _stopTimer();
    state = state.copyWith(
      status: GameStatus.lost,
      timeLeftSeconds: 0,
      selectedRow: null,
      selectedCol: null,
      hintPositions: null,
      lastInteraction: DateTime.now(),
    );
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

List<List<int>> _generatePlayableBoardInIsolate({
  required int rows,
  required int cols,
  required int assetCount,
  required int seed,
}) {
  final random = Random(seed);
  List<List<int>> board;
  do {
    board = _generateBoardInIsolate(random, rows, cols, assetCount);
  } while (!_hasAvailableMove(board, rows, cols));
  return board;
}

List<List<int>> _generateBoardInIsolate(
  Random random,
  int rows,
  int cols,
  int assetCount,
) {
  final board = List.generate(
    rows,
    (_) => List<int>.filled(cols, 0),
  );
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      int value;
      do {
        value = random.nextInt(assetCount);
      } while (_createsMatchIsolate(board, row, col, value));
      board[row][col] = value;
    }
  }
  return board;
}

bool _createsMatchIsolate(
  List<List<int>> board,
  int row,
  int col,
  int value,
) {
  if (col >= 2 &&
      board[row][col - 1] == value &&
      board[row][col - 2] == value) {
    return true;
  }
  if (row >= 2 &&
      board[row - 1][col] == value &&
      board[row - 2][col] == value) {
    return true;
  }
  if (row >= 1 &&
      col >= 1 &&
      board[row - 1][col] == value &&
      board[row][col - 1] == value &&
      board[row - 1][col - 1] == value) {
    return true;
  }
  return false;
}

bool _hasAvailableMove(List<List<int>> board, int rows, int cols) {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      if (col + 1 < cols) {
        _swapValues(board, row, col, row, col + 1);
        final hasMatch = _hasAnyMatch(board, rows, cols);
        _swapValues(board, row, col, row, col + 1);
        if (hasMatch) return true;
      }
      if (row + 1 < rows) {
        _swapValues(board, row, col, row + 1, col);
        final hasMatch = _hasAnyMatch(board, rows, cols);
        _swapValues(board, row, col, row + 1, col);
        if (hasMatch) return true;
      }
    }
  }
  return false;
}

bool _hasAnyMatch(List<List<int>> board, int rows, int cols) {
  for (int row = 0; row < rows; row++) {
    int start = 0;
    while (start < cols) {
      int end = start + 1;
      while (end < cols && board[row][start] == board[row][end]) {
        end++;
      }
      if (end - start >= 3 && board[row][start] != -1) {
        return true;
      }
      start = end;
    }
  }
  for (int col = 0; col < cols; col++) {
    int start = 0;
    while (start < rows) {
      int end = start + 1;
      while (end < rows && board[start][col] == board[end][col]) {
        end++;
      }
      if (end - start >= 3 && board[start][col] != -1) {
        return true;
      }
      start = end;
    }
  }
  for (int row = 0; row < rows - 1; row++) {
    for (int col = 0; col < cols - 1; col++) {
      final value = board[row][col];
      if (value >= 0 &&
          value == board[row][col + 1] &&
          value == board[row + 1][col] &&
          value == board[row + 1][col + 1]) {
        return true;
      }
    }
  }
  return false;
}

void _swapValues(
  List<List<int>> board,
  int r1,
  int c1,
  int r2,
  int c2,
) {
  final temp = board[r1][c1];
  board[r1][c1] = board[r2][c2];
  board[r2][c2] = temp;
}
