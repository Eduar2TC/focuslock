import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/extensions/extensions.dart';
import 'package:focuslock/features/focus/presentation/controllers/focus_session_controller.dart';
import 'package:focuslock/app/dependencies.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recoverOrStartSession();
    });
  }

  void _recoverOrStartSession() {
    final controller = ref.read(focusSessionControllerProvider.notifier);
    final sessionState = ref.read(focusSessionControllerProvider);
    
    if (sessionState != null && sessionState.session.isActive) {
      controller.recoverSession();
    } else {
      controller.startSession();
    }
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

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(focusSessionControllerProvider);

    if (sessionState == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              _buildTaskTitle(sessionState.session.task),
              const Spacer(),
              _buildTimer(sessionState.remaining),
              const SizedBox(height: 24),
              _buildCycleIndicator(sessionState.currentCycle, sessionState.session.cycles),
              const SizedBox(height: 48),
              _buildProgressBar(sessionState.progress),
              const Spacer(),
              _buildControls(sessionState.isPaused),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTitle(String task) {
    return Text(
      task.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTimer(Duration remaining) {
    return Text(
      remaining.timerFormatted,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: 72,
        fontWeight: FontWeight.w300,
        letterSpacing: 4,
      ),
    );
  }

  Widget _buildCycleIndicator(int current, int total) {
    return Text(
      'Cycle $current of $total',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondaryColor,
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.surfaceColor,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildControls(bool isPaused) {
    final controller = ref.read(focusSessionControllerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isPaused)
          _buildControlButton(
            'Resume',
            Icons.play_arrow_rounded,
            () => _safeCall(() => controller.resume()),
          )
        else
          _buildControlButton(
            'Pause',
            Icons.pause_rounded,
            () => _safeCall(() => controller.pause()),
          ),
        const SizedBox(width: 24),
        _buildControlButton(
          'Cancel',
          Icons.close_rounded,
          () => _showCancelDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  void _safeCall(VoidCallback action) {
    try {
      action();
    } catch (e) {
      _showError('Operation failed: $e');
    }
  }

  Widget _buildControlButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDestructive ? AppTheme.errorColor.withOpacity(0.1) : AppTheme.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isDestructive ? AppTheme.errorColor : AppTheme.textColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDestructive ? AppTheme.errorColor : AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Cancel Session?'),
        content: const Text('Your progress will be saved but the session will be marked as cancelled.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Focus'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(focusSessionControllerProvider.notifier).cancel();
              context.go('/home');
            },
            child: const Text(
              'Cancel Session',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
