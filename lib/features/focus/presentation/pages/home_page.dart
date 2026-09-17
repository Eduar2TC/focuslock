import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/dependencies.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/focus_session.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionState = ref.watch(focusSessionControllerProvider);
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final hasActiveSession = sessionState != null && sessionState.session.isActive;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
      children: [
        _buildHeader(context, l10n),
        const SizedBox(height: 20),
        _buildFocusSummaryCard(
          context,
          l10n,
          dashboardAsync.when(
            data: (data) => data,
            loading: () => const HomeDashboardData(
              todayFocusTime: Duration.zero,
              todayCompletedCount: 0,
              bestStreak: 0,
              weekActivity: [false, false, false, false, false, false, false],
              recent: [],
            ),
            error: (_, __) => const HomeDashboardData(
              todayFocusTime: Duration.zero,
              todayCompletedCount: 0,
              bestStreak: 0,
              weekActivity: [false, false, false, false, false, false, false],
              recent: [],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildStartOrResumeButton(context, l10n, hasActiveSession),
        const SizedBox(height: 20),
        _buildStreakCard(context, l10n, dashboardAsync, currentStreakAsync),
        const SizedBox(height: 28),
        _buildRecentActivity(
          context,
          l10n,
          dashboardAsync.when(
            data: (data) => data.recent,
            loading: () => const [],
            error: (_, __) => const [],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final now = DateTime.now();
    final dateLabel = DateFormat('EEEE, MMM d', l10n.localeName).format(now);
    final greeting = now.greeting(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                dateLabel,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.homeCalmMind,
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.homeScheduleReady,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFocusSummaryCard(
    BuildContext context,
    AppLocalizations l10n,
    HomeDashboardData data,
  ) {
    final goal = AppConstants.dailyFocusGoalMinutes.minutes;
    final goalLabel = goal.formattedShort;
    final percent = goal.inSeconds == 0 ? 0.0 : (data.todayFocusTime.inSeconds / goal.inSeconds).clamp(0.0, 1.0);
    final percentLabel = (percent * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -48,
            top: -48,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeTitle,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.graphic_eq,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      data.todayFocusTime.formattedShort,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '/ $goalLabel',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 6,
                    backgroundColor: AppTheme.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation(
                      AppTheme.primaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.homeSessionsCompleted(data.todayCompletedCount),
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.homeGoalPercent(percentLabel),
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartOrResumeButton(
    BuildContext context,
    AppLocalizations l10n,
    bool hasActiveSession,
  ) {
    final label = hasActiveSession ? l10n.homeResumeSession : l10n.homeStartButton;
    final icon = hasActiveSession ? Icons.timer_rounded : Icons.play_arrow_rounded;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton.icon(
        onPressed: () => hasActiveSession ? context.go('/focus') : context.push('/pre-session'),
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primaryContainer,
          foregroundColor: AppTheme.onPrimaryContainer,
          elevation: 8,
          shadowColor: AppTheme.primaryContainer.withValues(alpha: 0.4),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          elevation: const WidgetStatePropertyAll(8),
        ),
      ),
    );
  }

  Widget _buildStreakCard(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<HomeDashboardData> dashboardAsync,
    AsyncValue<int> currentStreakAsync,
  ) {
    final data = dashboardAsync.when(
      data: (d) => d,
      loading: () => null,
      error: (_, __) => null,
    );
    final streak = currentStreakAsync.maybeWhen(
      data: (v) => v,
      orElse: () => 0,
    );
    final bestStreak = data?.bestStreak ?? 0;
    final week = data?.weekActivity ?? const <bool>[];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.tertiaryColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: AppTheme.tertiaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeStreakLabel(streak),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l10n.homeBestStreak(bestStreak),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  l10n.homeStreakActive,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (week.length == 7)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isToday = i == 6;
                final active = week[i];
                return _WeekDayDot(
                  label: DateFormat('E', l10n.localeName).format(DateTime.now().subtract(Duration(days: 6 - i))).substring(0, 1),
                  active: active,
                  isToday: isToday,
                  showActiveBadge: streak > 0,
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    AppLocalizations l10n,
    List<FocusSession> recent,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.homeRecentActivity,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/statistics'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.homeViewAll),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.history, size: 20, color: AppTheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.homeRecentEmpty,
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...recent.map((session) => _RecentActivityItem(session: session)),
      ],
    );
  }
}

class _WeekDayDot extends StatelessWidget {
  const _WeekDayDot({
    required this.label,
    required this.active,
    required this.isToday,
    required this.showActiveBadge,
  });

  final String label;
  final bool active;
  final bool isToday;
  final bool showActiveBadge;

  @override
  Widget build(BuildContext context) {
    final fillColor = isToday ? AppTheme.primaryColor : AppTheme.primaryContainer;
    final fgColor = isToday ? AppTheme.onPrimaryColor : AppTheme.onPrimaryContainer;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 11,
            fontWeight: showActiveBadge && isToday ? FontWeight.w700 : FontWeight.w400,
            color: showActiveBadge && isToday ? AppTheme.primaryColor : AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: showActiveBadge && active ? fillColor : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: showActiveBadge && active ? fillColor : AppTheme.surfaceContainerHighest,
              width: 1,
            ),
            boxShadow: showActiveBadge && isToday
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: showActiveBadge && active
              ? Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: fgColor,
                )
              : null,
        ),
      ],
    );
  }
}

class _RecentActivityItem extends StatelessWidget {
  const _RecentActivityItem({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    final completed = session.isCompleted;
    final l10n = AppLocalizations.of(context)!;
    final icon = completed ? Icons.code : Icons.menu_book;
    final statusLabel = completed ? l10n.homeRecentCompleted : l10n.homeRecentCancelled;
    final statusColor = completed ? AppTheme.primaryContainer : AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: completed ? AppTheme.primaryColor : AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.task,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.actualDuration.formattedShort} • ${session.startedAt.timeFormatted(AppLocalizations.of(context)!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                statusLabel,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 11,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
