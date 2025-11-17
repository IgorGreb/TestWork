import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/features/leaderboard/leaderboard_controller.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/flame_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  Future<bool> _handleBack(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartGameScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardControllerProvider);
    return WillPopScope(
      onWillPop: () => _handleBack(context),
      child: ChickLayout(
        chickShow: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackBtnLayout(onPressed: () => _handleBack(context)),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FlamePanel(
                    title: 'LEADERBOARD',
                    child: ListView.separated(
                      itemCount: state.entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final entry = state.entries[index];
                        final isCurrent = entry.name == state.currentPlayer;
                        return _LeaderboardRow(
                          rank: index + 1,
                          name: entry.name,
                          score: entry.score,
                          stars: entry.stars,
                          highlight: isCurrent,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.score,
    required this.stars,
    this.highlight = false,
  });

  final int rank;
  final String name;
  final int score;
  final int stars;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: highlight
              ? const [Color(0xFFFFE082), Color(0xFFFFA726)]
              : const [Color(0xFFFF8BD7), Color(0xFFFC58C7)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toString().padLeft(4, '0'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$stars ★',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
