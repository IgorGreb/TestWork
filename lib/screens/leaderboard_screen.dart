import 'package:chick_game_prototype/features/leaderboard/leaderboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.builder(
        itemCount: state.entries.length,
        itemBuilder: (context, index) {
          final entry = state.entries[index];
          final isCurrent = entry.name == state.currentPlayer;
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(entry.name),
            subtitle: Text('${entry.score} pts • ${entry.stars}★'),
            tileColor: isCurrent ? Colors.orange.withOpacity(0.2) : null,
          );
        },
      ),
    );
  }
}
