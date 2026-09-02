import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/app/dependencies.dart';
import 'package:focuslock/features/focus/data/repositories/focus_session_repository.dart';
import 'package:focuslock/features/focus/domain/entities/focus_session.dart';
import 'package:focuslock/core/extensions/extensions.dart';

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
  List<FocusSession> _todaySessions = [];

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
    final today = await _sessionRepository.getSessionsByDate(DateTime.now());

    if (mounted) {
      setState(() {
        _completedSessions = completed;
        _totalFocusTime = totalTime;
        _currentStreak = streak;
        _todaySessions = today;
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
    if (_todaySessions.isEmpty) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today (${_todaySessions.length} sessions)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ..._todaySessions.map((session) => _buildSessionCard(session)).toList(),
      ],
    );
  }

  Widget _buildSessionCard(FocusSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: session.isCompleted ? AppTheme.successColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              session.isCompleted ? Icons.check_circle : Icons.cancel,
              color: session.isCompleted ? AppTheme.successColor : AppTheme.errorColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.task,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.actualDuration.formattedShort} • ${session.completedCycles}/${session.cycles} cycles',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            session.startedAt.timeFormatted,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
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
