import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/extensions/extensions.dart';
import 'package:focuslock/app/dependencies.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage>
    with WidgetsBindingObserver {
  bool _sessionStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recoverOrStartSession();
      _checkBlockedAppAttempt();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBlockedAppAttempt();
    }
  }

  Future<void> _checkBlockedAppAttempt() async {
    if (!mounted) return;
    try {
      final attempt = await ref
          .read(nativeFocusServiceProvider)
          .getLastBlockedAppAttempt();
      if (attempt == null || !mounted) return;
      final sessionState = ref.read(focusSessionControllerProvider);
      if (sessionState == null || !sessionState.session.isActive) return;

      final packageName = attempt['packageName'] ?? attempt.values.first;
      ref.read(blockedAppAttemptProvider.notifier).state = packageName;
      ref.read(focusSessionControllerProvider.notifier)
          .onBlockedAppAttempted(packageName);
      if (mounted) {
        context.push('/blocked-app');
      }
    } catch (_) {
      // Ignore bridge errors while running in a non-Android environment.
    }
  }

  void _recoverOrStartSession() {
    if (_sessionStarted) return;
    _sessionStarted = true;
    final controller = ref.read(focusSessionControllerProvider.notifier);
    final sessionState = ref.read(focusSessionControllerProvider);

    if (sessionState != null && sessionState.session.isActive) {
      controller.recoverSession();
    } else {
      controller.startSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionState = ref.watch(focusSessionControllerProvider);

    ref.listen(focusSessionControllerProvider, (previous, next) {
      if (next != null && next.session.isCompleted && mounted) {
        context.go('/completion');
      }
    });

    if (sessionState == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isBreak = sessionState.isBreak;
    final settings = ref.read(settingsRepositoryProvider);
    final isStrict = settings.enforcementLevel == 'strict';
    final blockedCount =
        ref.read(appRepositoryProvider).getActiveBlockedPackages().length;

    final remaining =
        isBreak ? sessionState.breakRemaining : sessionState.remaining;
    final fraction = isBreak
        ? (sessionState.breakTotal.inSeconds <= 0
            ? 0.0
            : sessionState.breakRemaining.inSeconds /
                sessionState.breakTotal.inSeconds)
        : (sessionState.session.plannedDuration.inSeconds <= 0
            ? 0.0
            : sessionState.remaining.inSeconds /
                sessionState.session.plannedDuration.inSeconds);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildModeChip(isStrict, sessionState.currentCycle,
                  sessionState.session.cycles),
              const Spacer(),
              _FocusRing(
                fraction: fraction,
                child: _buildTimerCenter(
                  remaining,
                  isBreak,
                  sessionState.isPaused,
                ),
              ),
              const Spacer(),
              _buildTaskContext(sessionState.session.task, blockedCount),
              const SizedBox(height: 14),
              _buildZenPill(),
              const SizedBox(height: 28),
              if (isBreak)
                _buildBreakActions(l10n)
              else
                _buildControls(l10n, sessionState.isPaused),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeChip(bool isStrict, int currentCycle, int totalCycles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isStrict ? 'STRICT FOCUS' : 'STANDARD FOCUS',
            style: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '•',
            style: TextStyle(color: AppTheme.outlineColor, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Text(
            'CYCLE $currentCycle OF $totalCycles',
            style: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCenter(
    Duration remaining,
    bool isBreak,
    bool isPaused,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_rounded,
          size: 26,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 6),
        Text(
          remaining.timerFormatted,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 64,
            height: 1.05,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.5,
            color: AppTheme.onSurface,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isBreak ? 'BREAK TIME' : 'RESTRICTED MODE',
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        if (isPaused) ...[
          const SizedBox(height: 6),
          const Text(
            'PAUSED',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: AppTheme.warningColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTaskContext(String task, int blockedCount) {
    return Column(
      children: [
        Text(
          task,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_rounded,
              size: 15,
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              checkedMessage(blockedCount),
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 13,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String checkedMessage(int blockedCount) {
    return blockedCount == 0
        ? 'No apps blocked'
        : blockedCount == 1
            ? 'Phone is locked down • 1 app blocked'
            : 'Phone is locked down • $blockedCount apps blocked';
  }

  Widget _buildZenPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.spa_rounded, size: 16, color: AppTheme.tertiaryColor),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Put your phone down and dive in.',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(AppLocalizations l10n, bool isPaused) {
    final controller = ref.read(focusSessionControllerProvider.notifier);
    final settings = ref.read(settingsRepositoryProvider);
    final allowCancel = settings.allowCancelSession;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: () => _safeCall(
              () => isPaused ? controller.resume() : controller.pause(),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: isPaused
                  ? AppTheme.primaryContainer
                  : AppTheme.surfaceContainerHigh,
              foregroundColor:
                  isPaused ? AppTheme.onPrimaryContainer : AppTheme.onSurface,
              shape: const StadiumBorder(),
            ),
            icon: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              size: 20,
              color: isPaused ? AppTheme.onPrimaryContainer : AppTheme.primaryColor,
            ),
            label: Text(isPaused ? 'Resume Focus' : 'Pause Session'),
          ),
        ),
        if (allowCancel) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _showEndSessionSheet(l10n),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.outlineColor,
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.power_settings_new_rounded, size: 15),
            label: const Text('End session early'),
          ),
        ],
      ],
    );
  }

  Widget _buildBreakActions(AppLocalizations l10n) {
    final controller = ref.read(focusSessionControllerProvider.notifier);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: () => _safeCall(() => controller.completeBreak()),
        icon: const Icon(Icons.skip_next_rounded,
            size: 20, color: AppTheme.onPrimaryContainer),
        label: const Text('Skip Break'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primaryContainer,
          foregroundColor: AppTheme.onPrimaryContainer,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  void _safeCall(VoidCallback action) {
    try {
      action();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  void _showEndSessionSheet(AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceContainerHigh,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded,
                    size: 20, color: AppTheme.errorColor),
              ),
              const SizedBox(height: 14),
              Text(
                'Break Focus Session?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Your current streak will reset for today.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceContainerHighest,
                          side: BorderSide.none,
                        ),
                        child: const Text('Keep Focusing'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _safeCall(() =>
                              ref.read(focusSessionControllerProvider.notifier).cancel());
                          context.go('/home');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.errorContainer,
                          foregroundColor: AppTheme.onErrorContainer,
                        ),
                        child: const Text('Unlock Phone'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FocusRing extends StatelessWidget {
  const _FocusRing({required this.fraction, required this.child});

  final double fraction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxSize = math.min(320.0, MediaQuery.sizeOf(context).width - 56);
    final size = math.max(240.0, maxSize);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size - 24,
            height: size - 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _RingPainter(
                fraction: fraction.clamp(0.0, 1.0),
                trackColor: AppTheme.surfaceContainerHigh.withValues(alpha: 0.6),
                progressColor: AppTheme.primaryContainer,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.trackColor,
    required this.progressColor,
  });

  final double fraction;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = size.center(Offset.zero);
    final radius = (size.longestSide - strokeWidth - 8) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = progressColor;
    final sweep = 2 * math.pi * fraction;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}