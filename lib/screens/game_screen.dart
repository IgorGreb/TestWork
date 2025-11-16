import 'dart:async';

import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/features/game/egg_assets.dart';
import 'package:chick_game_prototype/features/game/game_controller.dart';
import 'package:chick_game_prototype/features/game/game_state.dart';
import 'package:chick_game_prototype/features/levels/level_missions.dart';
import 'package:chick_game_prototype/features/levels/levels_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  LevelMission? _mission;
  bool _reportedWin = false;
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();
    // Ping the board once per second and surface a hint whenever the player
    // has been idle for more than five seconds.
    _hintTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final mission = _mission;
      if (mission == null) return;
      final provider = gameControllerProvider(mission);
      final current = ref.read(provider);
      if (current.status != GameStatus.playing) return;
      if (current.board.isEmpty) return;
      if (current.hintPositions != null) return;
      if (DateTime.now().difference(current.lastInteraction) >
          const Duration(seconds: 5)) {
        ref.read(provider.notifier).requestHint();
      }
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  void _ensureMission(BuildContext context) {
    if (_mission != null) return;
    final args = ModalRoute.of(context)?.settings.arguments as int?;
    final level = args ?? 1;
    // Cache the mission definition only once, otherwise a hot reload would
    // re-create the provider with a different instance.
    _mission = missionForLevel(level);
  }

  @override
  Widget build(BuildContext context) {
    _ensureMission(context);
    final mission = _mission;
    if (mission == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final gameProvider = gameControllerProvider(mission);
    final state = ref.watch(gameProvider);

    if (state.status == GameStatus.won && !_reportedWin) {
      _reportedWin = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(levelsControllerProvider.notifier)
            .completeMission(state.level);
        ref.read(gameProvider.notifier).finalizeCoins();
      });
    }
    if (state.status != GameStatus.won) {
      _reportedWin = false;
    }

    return ChickLayout(
      chickShow: 0,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: ${state.score} / ${state.targetScore}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(
                      state.status == GameStatus.paused
                          ? Icons.play_arrow
                          : Icons.pause,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final notifier = ref.read(gameProvider.notifier);
                      if (state.status == GameStatus.paused) {
                        notifier.resume();
                      } else {
                        notifier.pause();
                      }
                    },
                  ),
                ],
              ),
              Text(
                'Moves: ${state.movesLeft}    Coins: ${state.coinsEarned}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                'Time: ${_formatTime(state.timeLeftSeconds)}',
                style: const TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: _BoardView(
                    state: state,
                    onTap: (row, col) {
                      ref.read(gameProvider.notifier).selectCell(row, col);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Mission: ${state.missionDescription}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          if (state.status == GameStatus.won || state.status == GameStatus.lost)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _EndOfGameCard(
                  state: state,
                  onHome: () => Navigator.pop(context),
                  onRestart: () => ref.read(gameProvider.notifier).restart(),
                  onNext: state.status == GameStatus.won &&
                          state.level < levelMissions.length
                      ? () {
                        final nextLevel = state.level + 1;
                        Navigator.pushReplacementNamed(
                          context,
                          '/game',
                          arguments: nextLevel,
                        );
                      }
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }
}

class _BoardView extends StatelessWidget {
  final GameState state;
  final void Function(int, int) onTap;

  const _BoardView({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (state.board.isEmpty) {
      return const SizedBox.shrink();
    }
    final rows = state.board.length;
    final cols = state.board.first.length;
    final hint = state.hintPositions ?? const [];
    return AspectRatio(
      aspectRatio: cols / rows,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: rows * cols,
        itemBuilder: (context, index) {
          final row = index ~/ cols;
          final col = index % cols;
          final value = state.board[row][col];
          final selected = state.selectedRow == row && state.selectedCol == col;
          final isHint = hint.any((p) => p.row == row && p.col == col);
          return GestureDetector(
            onTap: () => onTap(row, col),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      selected
                          ? Colors.white
                          : isHint
                          ? Colors.yellowAccent
                          : Colors.transparent,
                  width: 3,
                ),
                image: DecorationImage(
                  image: AssetImage(eggAssetPaths[value]),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EndOfGameCard extends StatelessWidget {
  const _EndOfGameCard({
    required this.state,
    required this.onHome,
    required this.onRestart,
    this.onNext,
  });

  final GameState state;
  final VoidCallback onHome;
  final VoidCallback onRestart;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final isWin = state.status == GameStatus.won;
    final title = isWin ? 'YOU WIN!' : 'TIME\'S UP!';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1F),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.orangeAccent, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.35),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          _ScorePill(label: 'SCORE', value: state.score),
          const SizedBox(height: 12),
          _ScorePill(label: 'BEST', value: state.bestScore),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FlatActionButton(label: 'HOME', onPressed: onHome),
              _FlatActionButton(label: 'RESTART', onPressed: onRestart),
            ],
          ),
          if (isWin && onNext != null) ...[
            const SizedBox(height: 28),
            _NextButton(onPressed: onNext),
          ],
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF38E063), Color(0xFF179940)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            value.toString().padLeft(4, '0'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlatActionButton extends StatelessWidget {
  const _FlatActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: const Color(0xFFFF4BC9),
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: Colors.pinkAccent.withOpacity(0.5),
        ),
        onPressed: onPressed,
        child: const Text(
          'NEXT',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
