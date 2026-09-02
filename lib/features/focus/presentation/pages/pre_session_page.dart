import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/features/settings/data/repositories/settings_repository.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';
import 'package:focuslock/features/apps/presentation/pages/apps_page.dart';
import 'package:focuslock/features/focus/presentation/controllers/focus_session_controller.dart';
import 'package:focuslock/app/dependencies.dart';

class PreSessionPage extends ConsumerStatefulWidget {
  const PreSessionPage({super.key});

  @override
  ConsumerState<PreSessionPage> createState() => _PreSessionPageState();
}

class _PreSessionPageState extends ConsumerState<PreSessionPage> {
  final TextEditingController _taskController = TextEditingController();
  int _selectedDuration = 25;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsRepositoryProvider);
    _selectedDuration = settings.focusDuration;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('New Session'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildTaskInput(),
              const SizedBox(height: 32),
              _buildDurationSelector(),
              const SizedBox(height: 32),
              _buildBlockedAppsSection(),
              const SizedBox(height: 32),
              _buildStartButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are you going to work on?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Build my Flutter app',
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [15, 25, 30, 45, 60].map((duration) {
            final isSelected = _selectedDuration == duration;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDuration = duration),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${duration}m',
                      style: TextStyle(
                        color: isSelected ? AppTheme.textColor : AppTheme.textSecondaryColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBlockedAppsSection() {
    final appRepository = ref.read(appRepositoryProvider);
    final blockedApps = appRepository.getBlockedApps();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Blocked Apps',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => context.push('/apps'),
              child: const Text('Edit'),
            ),
          ],
        ),
        if (blockedApps.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.textSecondaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No apps blocked. Tap Edit to select apps.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: blockedApps
                .where((app) => app.enabled)
                .map((app) => Chip(
                      label: Text(app.appName),
                      backgroundColor: AppTheme.surfaceColor,
                      side: const BorderSide(color: AppTheme.dividerColor),
                    ))
                .toList(),
          ),
      ],
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          final task = _taskController.text.trim();
          if (task.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a task')),
            );
            return;
          }

          try {
            final controller = ref.read(focusSessionControllerProvider.notifier);
            controller.prepareSession(task);
            context.push('/focus');
          } catch (e) {
            _showError('Failed to prepare session: $e');
          }
        },
        child: const Text('Start Focus'),
      ),
    );
  }
}
