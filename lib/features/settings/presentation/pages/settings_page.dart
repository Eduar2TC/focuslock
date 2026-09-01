import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../settings/data/repositories/settings_repository.dart';
import '../../../../app/dependencies.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late SettingsRepository _settings;

  @override
  void initState() {
    super.initState();
    _settings = ref.read(settingsRepositoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildSection(
            'Focus',
            [
              _buildDurationSetting(
                'Focus Duration',
                _settings.focusDuration,
                (value) async {
                  await _settings.setFocusDuration(value);
                  setState(() {});
                },
                min: 5,
                max: 120,
                suffix: 'min',
              ),
              _buildDurationSetting(
                'Short Break',
                _settings.shortBreak,
                (value) async {
                  await _settings.setShortBreak(value);
                  setState(() {});
                },
                min: 1,
                max: 30,
                suffix: 'min',
              ),
              _buildDurationSetting(
                'Long Break',
                _settings.longBreak,
                (value) async {
                  await _settings.setLongBreak(value);
                  setState(() {});
                },
                min: 5,
                max: 60,
                suffix: 'min',
              ),
              _buildDurationSetting(
                'Cycles',
                _settings.cycles,
                (value) async {
                  await _settings.setCycles(value);
                  setState(() {});
                },
                min: 1,
                max: 10,
                suffix: '',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Blocking',
            [
              _buildSwitchSetting(
                'Allow Emergency Exit',
                _settings.allowEmergencyExit,
                (value) async {
                  await _settings.setAllowEmergencyExit(value);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Notifications',
            [
              _buildSwitchSetting(
                'Sound',
                _settings.soundEnabled,
                (value) async {
                  await _settings.setSoundEnabled(value);
                  setState(() {});
                },
              ),
              _buildSwitchSetting(
                'Vibration',
                _settings.vibrationEnabled,
                (value) async {
                  await _settings.setVibrationEnabled(value);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Data',
            [
              _buildActionSetting(
                'Export Data',
                Icons.download_outlined,
                () {
                  // TODO: Implement data export
                },
              ),
              _buildActionSetting(
                'Delete History',
                Icons.delete_outline,
                () {
                  // TODO: Implement delete history
                },
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSetting(
    String label,
    int value,
    Function(int) onChanged, {
    required int min,
    required int max,
    required String suffix,
  }) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline, size: 20),
          ),
          SizedBox(
            width: 48,
            child: Center(
              child: Text(
                '$value$suffix',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }

  Widget _buildActionSetting(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? AppTheme.errorColor : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
