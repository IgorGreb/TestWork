class SettingsState {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool notificationsEnabled;

  const SettingsState({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
