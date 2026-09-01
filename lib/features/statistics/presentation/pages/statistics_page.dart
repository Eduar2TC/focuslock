import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../app/dependencies.dart';
import '../../../focus/data/repositories/focus_session_repository.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  late FocusSessionRepository _sessionRepository;
  int _completedSessions = 0;
  Duration _totalFocusTime = Duration.zero;
  int _currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _sessionRepository = ref.read(focusSessionRepositoryProvider);
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final completed = await _sessionRepository.getCompletedCount();
    final totalTime = await _sessionRepository.getTotalFocusTime();
    final streak = await _sessionRepository.getCurrentStreak();

    if (mounted) {
      setState(() {
        _completedSessions = completed;
        _totalFocusTime = totalTime;
        _currentStreak = streak;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildOverviewSection(),
          const SizedBox(height: 24),
          _buildTodaySection(),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              'Sessions',
              '$_completedSessions completed',
              Icons.check_circle_outline,
            ),
            const SizedBox(width: 16),
            _buildStatCard(
              'Focus Time',
              _totalFocusTime.formatted,
              Icons.timer_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'Current Streak',
          '$_currentStreak days',
          Icons.local_fire_department_outlined,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No sessions today',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start a focus session to see your progress here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    bool fullWidth = false,
  }) {
    final card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );

    if (fullWidth) return card;
    return Expanded(child: card);
  }
}
