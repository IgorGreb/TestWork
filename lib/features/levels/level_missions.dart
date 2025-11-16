class LevelMission {
  final int level;
  final int targetScore;
  final String description;
  final int timeLimitSeconds;

  const LevelMission({
    required this.level,
    required this.targetScore,
    required this.description,
    this.timeLimitSeconds = 120,
  });
}

const List<LevelMission> levelMissions = [
  LevelMission(level: 1, targetScore: 60, description: 'Score 60 points to hatch your first egg.', timeLimitSeconds: 90),
  LevelMission(level: 2, targetScore: 90, description: 'Reach 90 points without running out of moves.', timeLimitSeconds: 100),
  LevelMission(level: 3, targetScore: 120, description: 'Collect streaks and hit 120 points.', timeLimitSeconds: 110),
  LevelMission(level: 4, targetScore: 150, description: 'Stay calm and score 150 points.', timeLimitSeconds: 120),
  LevelMission(level: 5, targetScore: 180, description: 'Avoid bad eggs and reach 180 points.', timeLimitSeconds: 130),
  LevelMission(level: 6, targetScore: 210, description: 'Make it past 210 points to heat up the arena.', timeLimitSeconds: 135),
  LevelMission(level: 7, targetScore: 240, description: 'Keep the combo alive for 240 points.', timeLimitSeconds: 140),
  LevelMission(level: 8, targetScore: 280, description: 'Bring the golden blaze to 280 points.', timeLimitSeconds: 150),
  LevelMission(level: 9, targetScore: 320, description: 'Master run: 320 points unlocks everything.', timeLimitSeconds: 160),
];

LevelMission missionForLevel(int level) {
  if (level <= 0) return levelMissions.first;
  if (level > levelMissions.length) return levelMissions.last;
  return levelMissions[level - 1];
}
