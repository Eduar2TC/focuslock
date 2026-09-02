import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/extensions/extensions.dart';
import 'package:focuslock/app/dependencies.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFocusTimeAsync = ref.watch(totalFocusTimeProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _buildHeader(context),
              const SizedBox(height: 48),
              _buildStatsSection(context, totalFocusTimeAsync, currentStreakAsync),
              const Spacer(),
              _buildStartButton(context),
              const SizedBox(height: 24),
              _buildNavigationButtons(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateTime.now().greeting,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Today's focus",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, AsyncValue<Duration> totalFocusTimeAsync, AsyncValue<int> currentStreakAsync) {
    return Row(
      children: [
        Expanded(
          child: totalFocusTimeAsync.when(
            data: (duration) => _buildStatCard(
              context,
              'Focus Time',
              duration.formattedShort,
              Icons.timer_outlined,
            ),
            loading: () => _buildStatCard(
              context,
              'Focus Time',
              '...',
              Icons.timer_outlined,
            ),
            error: (_, __) => _buildStatCard(
              context,
              'Focus Time',
              'Error',
              Icons.timer_outlined,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: currentStreakAsync.when(
            data: (streak) => _buildStatCard(
              context,
              'Streak',
              '$streak ${streak == 1 ? 'day' : 'days'}',
              Icons.local_fire_department_outlined,
            ),
            loading: () => _buildStatCard(
              context,
              'Streak',
              '...',
              Icons.local_fire_department_outlined,
            ),
            error: (_, __) => _buildStatCard(
              context,
              'Streak',
              'Error',
              Icons.local_fire_department_outlined,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
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
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => context.push('/pre-session'),
        child: const Text('Start Focus'),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.push('/statistics'),
            child: const Text('Statistics'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.push('/settings'),
            child: const Text('Settings'),
          ),
        ),
      ],
    );
  }
}
