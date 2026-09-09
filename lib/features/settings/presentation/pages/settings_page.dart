import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/features/settings/data/repositories/settings_repository.dart';
import 'package:focuslock/app/dependencies.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.settingsAppbarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildSection(
            l10n.settingsSectionFocus,
            [
              _buildDurationSetting(
                l10n.settingsFocusDuration,
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
                l10n.settingsShortBreak,
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
                l10n.settingsLongBreak,
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
                l10n.settingsCycles,
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
            l10n.settingsSectionBlocking,
            [
              _buildSwitchSetting(
                l10n.settingsAllowBypassBlocking,
                _settings.allowEmergencyExit,
                (value) async {
                  await _settings.setAllowEmergencyExit(value);
                  setState(() {});
                },
              ),
              _buildSwitchSetting(
                l10n.settingsAllowCancelSession,
                _settings.allowCancelSession,
                (value) async {
                  await _settings.setAllowCancelSession(value);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            l10n.settingsSectionNotifications,
            [
              _buildSwitchSetting(
                l10n.settingsSound,
                _settings.soundEnabled,
                (value) async {
                  await _settings.setSoundEnabled(value);
                  setState(() {});
                },
              ),
              _buildSwitchSetting(
                l10n.settingsVibration,
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
            l10n.settingsSectionData,
            [
              _buildActionSetting(
                l10n.settingsExportData,
                Icons.download_outlined,
                () => _exportData(l10n),
              ),
              _buildActionSetting(
                l10n.settingsDeleteHistory,
                Icons.delete_outline,
                () => _showDeleteConfirmation(l10n),
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(AppLocalizations l10n) async {
    try {
      final sessionRepository = ref.read(focusSessionRepositoryProvider);
      final sessions = await sessionRepository.getAllSessions();

      final data = {
        'sessions': sessions
            .map((s) => {
                  'id': s.id,
                  'task': s.task,
                  'startedAt': s.startedAt.toIso8601String(),
                  'endedAt': s.endedAt?.toIso8601String(),
                  'plannedDuration': s.plannedDuration.inSeconds,
                  'actualDuration': s.actualDuration.inSeconds,
                  'status': s.status.name,
                  'cycles': s.cycles,
                  'completedCycles': s.completedCycles,
                  'interruptionCount': s.interruptionCount,
                  'blockedAttemptCount': s.blockedAttemptCount,
                  'score': s.score,
                })
            .toList(),
        'exportedAt': DateTime.now().toIso8601String(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/focuslock_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      if (!mounted) return;

      await Share.shareXFiles([XFile(file.path)],
          text: 'FocusLock Data Export');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsExportSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.settingsExportError(e.toString())),
            backgroundColor: AppTheme.errorColor),
      );
    }
  }

  void _showDeleteConfirmation(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(l10n.settingsDeleteDialogTitle),
        content: Text(l10n.settingsDeleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllHistory(l10n);
            },
            child: Text(l10n.commonDelete,
                style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllHistory(AppLocalizations l10n) async {
    try {
      final database = ref.read(databaseProvider);
      await database.delete(database.focusSessions).go();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDeleteSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.settingsDeleteError(e.toString())),
            backgroundColor: AppTheme.errorColor),
      );
    }
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
      activeThumbColor: AppTheme.primaryColor,
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
