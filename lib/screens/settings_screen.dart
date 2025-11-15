import 'package:chick_game_prototype/features/settings/settings_controller.dart';
import 'package:chick_game_prototype/features/settings/settings_state.dart';
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
        content: Text(
          success ? 'Settings saved!' : 'Could not save settings',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentState = ref.watch(settingsControllerProvider);
    final viewState = _pendingState ?? currentState;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Sound'),
            value: viewState.soundEnabled,
            onChanged: (value) {
              _onToggle(
                value: value,
                updater: (state) => state.copyWith(soundEnabled: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            value: viewState.vibrationEnabled,
            onChanged: (value) {
              _onToggle(
                value: value,
                updater: (state) => state.copyWith(vibrationEnabled: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: viewState.notificationsEnabled,
            onChanged: (value) {
              _onToggle(
                value: value,
                updater: (state) => state.copyWith(notificationsEnabled: value),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
