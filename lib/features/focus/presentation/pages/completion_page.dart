import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/extensions/extensions.dart';
import 'package:focuslock/app/dependencies.dart';
import 'package:focuslock/shared/widgets/widgets.dart';

class CompletionPage extends ConsumerWidget {
  const CompletionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionState = ref.watch(focusSessionControllerProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);

    if (sessionState == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final session = sessionState.session;
    final controller = ref.read(focusSessionControllerProvider.notifier);
    final score = controller.calculateScore();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusBadge(context, session.isCompleted),
              const SizedBox(height: 32),
              Text(
                session.isCompleted
                    ? l10n.completionTitleCompleted
                    : l10n.completionTitleCancelled,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (session.isCompleted) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.completionEncourage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                session.actualDuration.formatted,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 32),
              InfoCard(
                label: l10n.completionInfoTask,
                value: session.task,
                icon: Icons.task_outlined,
              ),
              const SizedBox(height: 24),
              _buildScoreCard(context, l10n, score),
              const SizedBox(height: 24),
              currentStreakAsync.when(
                data: (streak) => InfoCard(
                  label: l10n.completionInfoCurrentStreak,
                  value:
                      '$streak ${streak == 1 ? l10n.commonDay : l10n.commonDays}',
                  icon: Icons.local_fire_department_outlined,
                  iconColor: AppTheme.warningColor,
                ),
                loading: () => InfoCard(
                  label: l10n.completionInfoCurrentStreak,
                  value: '...',
                  icon: Icons.local_fire_department_outlined,
                  iconColor: AppTheme.warningColor,
                ),
                error: (_, __) => InfoCard(
                  label: l10n.completionInfoCurrentStreak,
                  value: '0 ${l10n.commonDays}',
                  icon: Icons.local_fire_department_outlined,
                  iconColor: AppTheme.warningColor,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  child: Text(l10n.completionDoneButton),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isCompleted) {
    final color = isCompleted ? AppTheme.successColor : AppTheme.errorColor;
    final icon = isCompleted ? Icons.check_circle_outline : Icons.cancel;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(isCompleted ? 0.12 : 0.08),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 64, color: color),
    );
  }

  Widget _buildScoreCard(
      BuildContext context, AppLocalizations l10n, int score) {
    final isPositive = score >= 0;
    final valueColor = isPositive ? AppTheme.successColor : AppTheme.errorColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: isPositive
            ? Border.all(color: AppTheme.successColor.withOpacity(0.25))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star_outline,
                color: isPositive ? AppTheme.warningColor : AppTheme.errorColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isPositive ? '+$score' : '$score',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: valueColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.completionInfoScore,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
