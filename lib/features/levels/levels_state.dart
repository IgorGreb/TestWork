class LevelsState {
  final int unlockedCount;
  final Set<int> completedLevels;

  const LevelsState({
    this.unlockedCount = 1,
    this.completedLevels = const <int>{},
  });

  LevelsState copyWith({int? unlockedCount, Set<int>? completedLevels}) {
    return LevelsState(
      unlockedCount: unlockedCount ?? this.unlockedCount,
      completedLevels: completedLevels ?? this.completedLevels,
    );
  }
}
