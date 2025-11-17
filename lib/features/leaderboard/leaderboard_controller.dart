import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/profile_controller.dart';
import 'leaderboard_state.dart';

final leaderboardControllerProvider = Provider<LeaderboardState>((ref) {
  final profile = ref.watch(profileControllerProvider);
  final mockEntries = [
    LeaderboardEntry(
      name: profile.username.isEmpty ? 'You' : profile.username,
      score: 1500,
      stars: 5,
    ),
    const LeaderboardEntry(name: 'Chicky', score: 1200, stars: 4),
    const LeaderboardEntry(name: 'Eggbert', score: 1100, stars: 4),
    const LeaderboardEntry(name: 'Fluffy', score: 900, stars: 3),
    const LeaderboardEntry(name: 'Sunny', score: 850, stars: 3),
  ];
  return LeaderboardState(
    entries: mockEntries,
    currentPlayer: profile.username.isEmpty ? 'You' : profile.username,
  );
});
