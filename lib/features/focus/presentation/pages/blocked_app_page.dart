import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/extensions/extensions.dart';
import 'package:focuslock/app/dependencies.dart';

class BlockedAppPage extends ConsumerWidget {
  const BlockedAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(focusSessionControllerProvider);
    final attemptedPackage = ref.watch(blockedAppAttemptProvider);
    final session = state?.session;
    final task = session?.task ?? l10n.blockedDefaultTask;
    final remaining = state?.remaining ?? Duration.zero;
    final progress = state?.progress ?? 0.0;
    final planned = state?.session.plannedDuration ?? Duration.zero;
    final isStrict =
        ref.read(settingsRepositoryProvider).enforcementLevel == 'strict';
    final allowCancel = ref.read(settingsRepositoryProvider).allowCancelSession;

    final appName = _blockedAppName(ref, l10n, attemptedPackage);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 12),
              const _Emblem(),
              const SizedBox(height: 20),
              _buildBadge(l10n),
              const SizedBox(height: 18),
              Text(
                l10n.blockedStayFocused,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.blockedBreathe,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildIntentionCard(context, l10n, task, remaining, progress, planned),
              const SizedBox(height: 12),
              _buildBlockedAppCard(context, l10n, appName),
              const SizedBox(height: 12),
              if (isStrict) _buildStrictWarning(context, l10n),
              const SizedBox(height: 24),
              _buildActionSuite(context, l10n, ref, allowCancel),
            ],
          ),
        ),
      ),
    );
  }

  String _blockedAppName(WidgetRef ref, AppLocalizations l10n, String? packageName) {
    if (packageName == null) return l10n.blockedFallbackApp;
    final repository = ref.read(appRepositoryProvider);
    final match =
        repository.getBlockedApps().where((a) => a.packageName == packageName).toList();
    if (match.isNotEmpty && match.first.appName.isNotEmpty) {
      return match.first.appName;
    }
    return packageName;
  }

  Widget _buildBadge(AppLocalizations l10n) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 6,
              height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.blockedInterventionGate,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntentionCard(
    BuildContext context,
    AppLocalizations l10n,
    String task,
    Duration remaining,
    double progress,
    Duration planned,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.blockedYouChose,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  l10n.blockedDeepWork,
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
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.terminal_rounded,
                  size: 24,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.timelapse_rounded,
                            size: 14, color: AppTheme.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          l10n.blockedTimeRemaining(remaining.timerFormatted),
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
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppTheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                '00:00',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 11,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                l10n.blockedSessionTarget(planned.inMinutes),
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

  Widget _buildBlockedAppCard(
    BuildContext context,
    AppLocalizations l10n,
    String appName,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.block_rounded,
                size: 20, color: AppTheme.tertiaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.blockedAppIsLocked(appName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.blockedFocusShield,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_rounded,
              size: 20, color: AppTheme.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildStrictWarning(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_rounded,
              size: 20, color: AppTheme.tertiaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.blockedStrictActive,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.blockedStrictWarning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSuite(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    bool allowCancel,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded,
                size: 20, color: AppTheme.onPrimaryContainer),
            label: Text(l10n.blockedReturnToFocus),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryContainer,
              foregroundColor: AppTheme.onPrimaryContainer,
              shape: const StadiumBorder(),
            ),
          ),
        ),
        if (allowCancel) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton.icon(
              onPressed: () => _showAbandonSheet(context, l10n, ref),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.onSurfaceVariant,
                backgroundColor: AppTheme.cardColor,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.lock_open_rounded, size: 18),
              label: Text(l10n.blockedEndSessionAnyway),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology_rounded,
                size: 14, color: AppTheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              l10n.blockedUrges,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAbandonSheet(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceContainerHigh,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppTheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pause_circle_rounded,
                    size: 24, color: AppTheme.onErrorContainer),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.blockedBreakStreak,
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.blockedBreath,
                textAlign: TextAlign.center,
                style:
                    Theme.of(sheetContext).textTheme.bodySmall?.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.onPrimaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(l10n.blockedKeepGoing),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    ref.read(focusSessionControllerProvider.notifier).cancel();
                    context.go('/home');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(l10n.blockedQuitSession),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Emblem extends StatefulWidget {
  const _Emblem();

  @override
  State<_Emblem> createState() => _EmblemState();
}

class _EmblemState extends State<_Emblem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          return SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.35 + (0.3 * (1 - t)),
                  child: Container(
                    width: 136,
                    height: 136,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    size: 34,
                    color: AppTheme.primaryColor,
                  ),
                ),
                for (final angle in [0.0, 1.2, 2.4, 3.6])
                  Positioned(
                    left: 57 + 52 * math.cos(angle) - 1.5,
                    top: 57 + 52 * math.sin(angle) - 1.5,
                    child: Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}