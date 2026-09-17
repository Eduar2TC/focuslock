import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/app/dependencies.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';
import 'package:focuslock/core/constants/app_constants.dart';
import 'package:focuslock/core/extensions/extensions.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  StatsPeriod _period = StatsPeriod.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(statisticsProvider);

    return statsAsync.when(
      data: (data) => _buildContent(context, l10n, data),
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      ),
      error: (_, __) => _buildError(context, l10n),
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.analytics_outlined,
            size: 48,
            color: AppTheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(l10n.statsErrorLoad('')),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    if (!data.hasAnyCompleted) {
      return _buildEmptyState(context, l10n, data);
    }

    final period = data.of(_period);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
      children: [
        _buildHeader(context, l10n, period),
        const SizedBox(height: 16),
        _PeriodSwitcher(
          period: _period,
          onChanged: (value) => setState(() => _period = value),
        ),
        const SizedBox(height: 16),
        _buildMetricsGrid(context, l10n, data),
        const SizedBox(height: 16),
        _buildFocusChartCard(context, l10n, data),
        const SizedBox(height: 16),
        _buildInterventionsCard(context, l10n, data),
        const SizedBox(height: 16),
        _buildQualityCard(context, l10n, data),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
      children: [
        _buildHeader(context, l10n, data.week),
        const SizedBox(height: 16),
        _PeriodSwitcher(
          period: _period,
          onChanged: (value) => setState(() => _period = value),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.outlineVariant.withValues(alpha: 0.3),
            ),
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
                l10n.statsEmptyTodayTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.statsEmptyTodayDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => context.push('/pre-session'),
                  child: Text(l10n.statsEmptyTodayCta),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    PeriodData period,
  ) {
    final range = period.start == period.end
        ? DateFormat('MMM d', l10n.localeName).format(period.start)
        : '${DateFormat('MMM d', l10n.localeName).format(period.start)} – '
            '${DateFormat('MMM d', l10n.localeName).format(period.end)}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.statsAppbarTitle,
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const _PulseDot(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.statsSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _RangeBadge(range: range),
      ],
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    final period = data.of(_period);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFocusTimeMetric(l10n, period),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSessionsMetric(l10n, period),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSuccessRateMetric(l10n, period),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStreakMetric(l10n, data, period),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFocusTimeMetric(AppLocalizations l10n, PeriodData period) {
    final showDelta = period.previousFocusTime > Duration.zero;
    final percent = showDelta
        ? ((period.focusTime.inSeconds - period.previousFocusTime.inSeconds) *
                100 /
                period.previousFocusTime.inSeconds)
            .round()
        : 0;
    final positive = percent >= 0;
    final delta = switch (_period) {
      StatsPeriod.today => l10n.statsDeltaToday(_formatDelta(percent)),
      StatsPeriod.week => l10n.statsDeltaWeek(_formatDelta(percent)),
      StatsPeriod.month => l10n.statsDeltaMonth(_formatDelta(percent)),
    };

    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricHeader(
            label: l10n.statsTotalFocusTimeLabel,
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(height: 10),
          Text(
            period.focusTime.formattedShort,
            style: _metricValueStyle,
          ),
          if (showDelta) ...[
            const SizedBox(height: 4),
            _DeltaRow(text: delta, positive: positive),
          ],
          const SizedBox(height: 10),
          _MetricFooter(
            text: l10n.statsDailyAvg(period.dailyAverage.formattedShort),
          ),
        ],
      ),
    );
  }

  static String _formatDelta(int percent) =>
      percent >= 0 ? '+$percent%' : '$percent%';

  Widget _buildSessionsMetric(AppLocalizations l10n, PeriodData period) {
    final total = period.completed + period.cancelledOrInterrupted;
    final percent = (period.completionRate * 100).round();

    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricHeader(
            label: l10n.statsSessionsLabel,
            icon: Icons.task_alt,
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: _metricValueStyle,
              children: [
                TextSpan(text: '${period.completed}'),
                TextSpan(
                  text: ' / $total ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                // Removed hardcoded 'done' - use localized pattern instead
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.statsCompletionRate(percent),
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : period.completionRate,
              minHeight: 5,
              backgroundColor: AppTheme.cardColor,
              valueColor: const AlwaysStoppedAnimation(
                AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessRateMetric(AppLocalizations l10n, PeriodData period) {
    final percent = (period.completionRate * 100).round();
    final pauses = period.cancelledOrInterrupted;

    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricHeader(
            label: l10n.statsSuccessRateLabel,
            icon: Icons.verified_outlined,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$percent%', style: _metricValueStyle),
                    const SizedBox(height: 2),
                    Text(
                      l10n.statsSuccessRateSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _DonutRing(percent: period.completionRate),
            ],
          ),
          const SizedBox(height: 10),
          _MetricFooter(
            text: pauses == 0 ? '' : l10n.statsPausesUsed(pauses),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakMetric(
    AppLocalizations l10n,
    StatisticsData data,
    PeriodData period,
  ) {
    final best = data.bestStreak;

    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricHeader(
            label: l10n.statsCurrentStreakLabel,
            icon: Icons.local_fire_department_rounded,
            iconColor: AppTheme.tertiaryColor,
            iconTint: AppTheme.tertiaryColor.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: _metricValueStyle,
              children: [
                TextSpan(text: '${data.currentStreak}'),
                TextSpan(
                  text: ' ${l10n.statsDays(data.currentStreak)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.statsBestStreak(best),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.outlineVariant,
                  width: 0.6,
                ),
              ),
            ),
            child: Row(
              children: List.generate(7, (i) {
                final active = data.weekActivity[i];
                return Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: active
                          ? AppTheme.primaryColor
                          : AppTheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusChartCard(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    final period = data.of(_period);
    final goal = AppConstants.dailyFocusGoalMinutes.minutes;
    final bucketSize = _period == StatsPeriod.month ? 6 : 1;
    final chartGoal = goal * bucketSize;
    final goalLabel = '${(chartGoal.inMinutes / 60).toStringAsFixed(1)}h';
    final todayValue = data.today.focusTime.formattedShort;

    String totalLabel;
    if (_period == StatsPeriod.week) {
      totalLabel = l10n.statsWeeklyTotal(period.focusTime.formattedShort);
    } else {
      totalLabel = l10n.statsPeriodTotal(period.focusTime.formattedShort);
    }

    final weekThreshold = switch (_period) {
      StatsPeriod.today => goal * 0.85,
      StatsPeriod.week => goal * 7 * 0.85,
      StatsPeriod.month => goal * 30 * 0.85,
    };
    final onTrack = period.focusTime >= weekThreshold;
    final periodGoalLabel = switch (_period) {
      StatsPeriod.today => goal.formattedShort,
      StatsPeriod.week => (goal * 7).formattedShort,
      StatsPeriod.month => (goal * 30).formattedShort,
    };

    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsFocusChartTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.statsDailyTarget(goalLabel),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.statsTodayChip(todayValue),
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BarChart(period: period, goal: chartGoal, goalLabel: goalLabel),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.outlineVariant, width: 0.6),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    totalLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                if (onTrack)
                  Text(
                    l10n.statsOnTrack(periodGoalLabel),
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterventionsCard(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    final period = data.of(_period);
    final total = period.blockedAttempts;
    final apps = data.blockedApps;

    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsInterventionsTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.statsInterventionsSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  l10n.statsInterventionsTotal(total),
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (apps.isEmpty)
            Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppTheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.statsBlockedAppsEmpty,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            )
          else
            ...apps.map(
              (app) => _BlockedAppRow(app: app, l10n: l10n),
            ),
        ],
      ),
    );
  }

  Widget _buildQualityCard(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    final windowRange = _peekWindow(context, l10n, data);
    final beforeNoon = (data.beforeNoonRate * 100).round();

    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.statsQualityTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withValues(
                          alpha: 0.20,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.statsInsightChip,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.statsPeakWindow(windowRange.$1, windowRange.$2),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.statsInsightBody(beforeNoon),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.statsConsistencyTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Text(
                l10n.statsConsistencyValue(data.weekConsistencyScore),
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ConsistencyMatrix(activity: data.weekActivity),
        ],
      ),
    );
  }

  (String, String) _peekWindow(
    BuildContext context,
    AppLocalizations l10n,
    StatisticsData data,
  ) {
    if (data.peakHour < 0) {
      final morning = DateTime(DateTime.now().year, 1, 1, 9);
      final late = DateTime(DateTime.now().year, 1, 1, 11);
      return (morning.timeFormatted(l10n), late.timeFormatted(l10n));
    }
    final year = DateTime.now().year;
    final start = DateTime(year, 1, 1, data.peakHour);
    final end = DateTime(year, 1, 1, data.peakHour + 1);
    return (start.timeFormatted(l10n), end.timeFormatted(l10n));
  }
}

const _metricValueStyle = TextStyle(
  fontFamily: AppTheme.fontFamily,
  fontSize: 22,
  fontWeight: FontWeight.w700,
  letterSpacing: -0.3,
  color: AppTheme.onSurface,
);

class _CardBox extends StatelessWidget {
  const _CardBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: child,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: child,
    );
  }
}

class _MetricHeader extends StatelessWidget {
  const _MetricHeader({
    required this.label,
    required this.icon,
    this.iconColor = AppTheme.primaryColor,
    this.iconTint,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color? iconTint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: iconTint ?? AppTheme.primaryContainer.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: iconColor),
        ),
      ],
    );
  }
}

class _MetricFooter extends StatelessWidget {
  const _MetricFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.outlineVariant, width: 0.6),
        ),
      ),
      child: text.isEmpty
          ? const SizedBox.shrink()
          : Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 9.5,
                    letterSpacing: 0.2,
                  ),
            ),
    );
  }
}

class _DeltaRow extends StatelessWidget {
  const _DeltaRow({required this.text, required this.positive});

  final String text;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          positive
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
          size: 13,
          color: positive ? AppTheme.primaryColor : AppTheme.errorColor,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: positive ? AppTheme.primaryColor : AppTheme.errorColor,
          ),
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);
  late final Animation<double> _opacity =
      Tween<double>(begin: 0.5, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppTheme.secondaryColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _RangeBadge extends StatelessWidget {
  const _RangeBadge({required this.range});

  final String range;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 13,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 5),
          Text(
            range,
            style: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSwitcher extends StatelessWidget {
  const _PeriodSwitcher({required this.period, required this.onChanged});

  final StatsPeriod period;
  final ValueChanged<StatsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const labels = _PeriodMeta();

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          _buildItem(context, StatsPeriod.today, labels.today(l10n)),
          _buildItem(context, StatsPeriod.week, labels.week(l10n)),
          _buildItem(context, StatsPeriod.month, labels.month(l10n)),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    StatsPeriod value,
    String label,
  ) {
    final selected = period == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppTheme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: selected
                ? Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.25),
                  )
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected
                  ? AppTheme.primaryColor
                  : AppTheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodMeta {
  const _PeriodMeta();

  String today(AppLocalizations l10n) => l10n.statsTodayLabel;
  String week(AppLocalizations l10n) => l10n.statsPeriodWeek;
  String month(AppLocalizations l10n) => l10n.statsPeriodMonth;
}

class _DonutRing extends StatelessWidget {
  const _DonutRing({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: CustomPaint(
        painter: _DonutPainter(
          progress: percent.clamp(0.0, 1.0),
          background: AppTheme.cardColor,
          foreground: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.progress,
    required this.background,
    required this.foreground,
  });

  final double progress;
  final Color background;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 1.5;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    stroke.color = background;
    canvas.drawCircle(center, radius, stroke);

    stroke.color = foreground;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      stroke,
    );
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.foreground != foreground ||
      oldDelegate.background != background;
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.period,
    required this.goal,
    required this.goalLabel,
  });

  final PeriodData period;
  final Duration goal;
  final String goalLabel;

  static const double _chartHeight = 168;

  @override
  Widget build(BuildContext context) {
    final maxBar = period.bars.fold<Duration>(
      Duration.zero,
      (max, b) => b.value > max ? b.value : max,
    );
    final maxValue = _maxOf(
      goal * 2,
      maxBar * 1.15,
    );

    const maxBarHeight = _chartHeight - 40;
    final guidelineTop = 4 + maxBarHeight * (1 - goal.inSeconds / maxValue.inSeconds);

    return SizedBox(
      height: _chartHeight,
      child: Stack(
        children: [
          Positioned(
            top: guidelineTop,
            left: 0,
            right: 0,
            child: Row(
              children: [
                const Expanded(child: _DashedLine()),
                const SizedBox(width: 6),
                Text(
                  goalLabel,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 9,
                    color: AppTheme.outlineColor,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bar in period.bars)
                  Expanded(
                    child: _buildBar(context, bar, maxValue, maxBarHeight),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    BuildContext context,
    StatsBar bar,
    Duration maxValue,
    double maxBarHeight,
  ) {
    final barHeight = bar.value == Duration.zero
        ? 6.0
        : (bar.value.inSeconds / maxValue.inSeconds * maxBarHeight)
            .clamp(6.0, maxBarHeight)
            .toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          _barLabel(bar.value),
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 9,
            height: 1.2,
            color: bar.highlighted
                ? AppTheme.primaryColor
                : (bar.value == Duration.zero
                    ? AppTheme.outlineColor.withValues(alpha: 0.5)
                    : AppTheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: 18,
          height: barHeight,
          decoration: BoxDecoration(
            color: bar.highlighted
                ? AppTheme.primaryColor
                : AppTheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),
            border: bar.value == Duration.zero
                ? Border.all(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.4),
                  )
                : null,
            boxShadow: bar.highlighted
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _dayLabel(context, bar),
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 10,
            fontWeight: bar.highlighted ? FontWeight.w700 : FontWeight.w500,
            color: bar.highlighted
                ? AppTheme.primaryColor
                : AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _barLabel(Duration value) {
    if (value == Duration.zero) return '—';
    if (value >= const Duration(minutes: 57)) {
      return '${(value.inSeconds / 3600).toStringAsFixed(1)}h';
    }
    return '${value.inMinutes}m';
  }

  String _dayLabel(BuildContext context, StatsBar bar) {
    if (period.bars.length == 5) {
      final index = period.bars.indexOf(bar);
      return 'W${index + 1}';
    }
    final l10n = AppLocalizations.of(context)!;
    return DateFormat('E', l10n.localeName)
        .format(bar.date)
        .substring(0, 1);
  }

  static Duration _maxOf(Duration a, Duration b) => a > b ? a : b;
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(color: AppTheme.outlineVariant),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashGap = 3.0;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _BlockedAppRow extends StatelessWidget {
  const _BlockedAppRow({required this.app, required this.l10n});

  final BlockedApp app;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              app.appName.isNotEmpty ? app.appName[0].toUpperCase() : '•',
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              app.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              l10n.statsAppBlocking,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsistencyMatrix extends StatelessWidget {
  const _ConsistencyMatrix({required this.activity});

  final List<bool> activity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();

    return Row(
      children: List.generate(7, (i) {
        final date = today.subtract(Duration(days: 6 - i));
        final active = activity[i];
        final isToday = i == 6;
        final dayLetter = DateFormat('E', l10n.localeName)
            .format(date)
            .substring(0, 1);

        return Expanded(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: active
                        ? (isToday
                            ? AppTheme.primaryColor
                            : AppTheme.primaryContainer)
                        : AppTheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday
                        ? Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.5),
                            width: 2,
                          )
                        : null,
                  ),
                  child: isToday && active
                      ? const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: AppTheme.onPrimaryColor,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                dayLetter,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 9,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: isToday
                      ? AppTheme.primaryColor
                      : (active ? AppTheme.onSurfaceVariant : AppTheme.outlineColor),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
