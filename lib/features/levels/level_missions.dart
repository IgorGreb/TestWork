class LevelMission {
  final int level;
  final int targetScore;
  final String description;

  const LevelMission({
    required this.level,
    required this.targetScore,
    required this.description,
  });
}

const List<LevelMission> levelMissions = [
  LevelMission(level: 1, targetScore: 60, description: 'Score 60 points to hatch your first egg.'),
  LevelMission(level: 2, targetScore: 90, description: 'Reach 90 points without losing all lives.'),
  LevelMission(level: 3, targetScore: 120, description: 'Collect streaks and hit 120 points.'),
  LevelMission(level: 4, targetScore: 150, description: 'Stay calm and score 150 points.'),
  LevelMission(level: 5, targetScore: 180, description: 'Avoid bad eggs and reach 180 points.'),
  LevelMission(level: 6, targetScore: 210, description: 'Make it past 210 points to heat up the arena.'),
  LevelMission(level: 7, targetScore: 240, description: 'Keep the combo alive for 240 points.'),
  LevelMission(level: 8, targetScore: 280, description: 'Bring the golden blaze to 280 points.'),
  LevelMission(level: 9, targetScore: 320, description: 'Master run: 320 points unlocks everything.'),
];

LevelMission missionForLevel(int level) {
  if (level <= 0) return levelMissions.first;
  if (level > levelMissions.length) return levelMissions.last;
  return levelMissions[level - 1];
}
