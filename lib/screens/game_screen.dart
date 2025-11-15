import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/features/game/game_controller.dart';
import 'package:chick_game_prototype/features/game/game_state.dart';
import 'package:chick_game_prototype/features/levels/level_missions.dart';
import 'package:chick_game_prototype/features/levels/levels_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  Ticker? _ticker;
  Duration? _lastTick;
  double _accumulator = 0;
  static const double _step = 1 / 45;
  LevelMission? _mission;
  bool _reportedWin = false;

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _ensureMission() {
    if (_mission != null) return;
    final args = ModalRoute.of(context)?.settings.arguments as int?;
    final level = args ?? 1;
    _mission = missionForLevel(level);
  }

  void _startLoop(WidgetRef ref) {
    if (_ticker != null || _mission == null) return;
    final mission = _mission!;
    _ticker = createTicker((elapsed) {
      if (_lastTick == null) {
        _lastTick = elapsed;
        return;
      }
      final delta =
          (elapsed - _lastTick!).inMicroseconds /
          Duration.microsecondsPerSecond;
      _lastTick = elapsed;
      _accumulator += delta;
      while (_accumulator >= _step) {
        ref
            .read(gameControllerProvider(mission).notifier)
            .updateFrame(deltaSeconds: _step);
        _accumulator -= _step;
      }
    })..start();
  }

  @override
  Widget build(BuildContext context) {
    _ensureMission();
    final mission = _mission;
    if (mission == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _startLoop(ref);

    final gameProvider = gameControllerProvider(mission);
    final state = ref.watch(gameProvider);

    if (state.status == GameStatus.won && !_reportedWin) {
      _reportedWin = true;
      ref.read(levelsControllerProvider.notifier).completeMission(state.level);
    }
    if (state.status != GameStatus.won) {
      _reportedWin = false;
    }

    return ChickLayout(
      chickShow: 0,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GamePainter(state))),
          Positioned(
            left: 16,
            top: 16,
            child: Text('Score: ${state.score}  Lives: ${state.lives}'),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Goal: ${state.targetScore}'),
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
          ),
          if (state.status == GameStatus.won || state.status == GameStatus.lost)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.status == GameStatus.won ? 'YOU WIN!' : 'YOU LOSE!',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('HOME'),
                      ),
                      TextButton(
                        onPressed:
                            () => ref.read(gameProvider.notifier).restart(),
                        child: const Text('RESTART'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white54,
                  value: state.playerX,
                  onChanged: (value) {
                    ref.read(gameProvider.notifier).setPlayerPosition(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Mission: ${state.missionDescription}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  final GameState state;

  _GamePainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final playerPaint = Paint()..color = Colors.orange;
    final eggPaintGood = Paint()..color = Colors.yellow;
    final eggPaintBad = Paint()..color = Colors.red;
    final playerX = state.playerX * size.width;
    canvas.drawCircle(Offset(playerX, size.height / 1.2), 40, playerPaint);

    for (final egg in state.eggs) {
      final paint = egg.good ? eggPaintGood : eggPaintBad;
      canvas.drawCircle(
        Offset(egg.x * size.width, egg.y * size.height),
        15,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
