class LeaderboardEntry {
  final String name;
  final int score;
  final int stars;

  const LeaderboardEntry({
    required this.name,
    required this.score,
    required this.stars,
  });
}

class LeaderboardState {
  final List<LeaderboardEntry> entries;
  final String currentPlayer;

  const LeaderboardState({
    this.entries = const [],
    this.currentPlayer = '',
  });
}
