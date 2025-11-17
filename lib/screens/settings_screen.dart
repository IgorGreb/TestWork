import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/features/settings/settings_controller.dart';
import 'package:chick_game_prototype/features/settings/settings_state.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/start_btn_widget.dart';
import 'package:chick_game_prototype/widgets/flame_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  SettingsState? _pendingState;
  ProviderSubscription<SettingsState>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listenManual<SettingsState>(
      settingsControllerProvider,
      (prev, next) {
        if (!mounted) return;
        setState(() {
          _pendingState = next;
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  void _onToggle({
    required bool value,
    required SettingsState Function(SettingsState current) updater,
  }) {
    setState(() {
      final baseState = _pendingState ?? ref.read(settingsControllerProvider);
      _pendingState = updater(baseState!);
    });
  }

  Future<void> _save() async {
    final notifier = ref.read(settingsControllerProvider.notifier);
    final success = await notifier.save(_pendingState ?? notifier.state);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Settings saved!' : 'Could not save settings'),
      ),
    );
  }

  Future<bool> _handleBack() async {
    if (!mounted) return false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartGameScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final currentState = ref.watch(settingsControllerProvider);
    final viewState = _pendingState ?? currentState;

    return WillPopScope(
      onWillPop: _handleBack,
      child: ChickLayout(
        chickShow: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackBtnLayout(onPressed: _handleBack),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FlamePanel(
                    title: 'SETTINGS',
                    child: ListView(
                      children: [
                        _SettingToggle(
                          label: 'Music',
                          value: viewState.musicEnabled,
                          onChanged:
                              (value) => _onToggle(
                                value: value,
                                updater:
                                    (state) =>
                                        state.copyWith(musicEnabled: value),
                              ),
                        ),
                        _SettingToggle(
                          label: 'Sound',
                          value: viewState.soundEnabled,
                          onChanged:
                              (value) => _onToggle(
                                value: value,
                                updater:
                                    (state) =>
                                        state.copyWith(soundEnabled: value),
                              ),
                        ),
                        _SettingToggle(
                          label: 'Vibration',
                          value: viewState.vibrationEnabled,
                          onChanged:
                              (value) => _onToggle(
                                value: value,
                                updater:
                                    (state) =>
                                        state.copyWith(vibrationEnabled: value),
                              ),
                        ),
                        _SettingToggle(
                          label: 'Notifications',
                          value: viewState.notificationsEnabled,
                          onChanged:
                              (value) => _onToggle(
                                value: value,
                                updater:
                                    (state) => state.copyWith(
                                      notificationsEnabled: value,
                                    ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StartBtnWidget(
                  label: 'Save',
                  widthFactor: 0.6,
                  heightFactor: 0.13,
                  fontFactor: 0.08,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF8E2F8C).withOpacity(0.4),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF64FFDA),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
