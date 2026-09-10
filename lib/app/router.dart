import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/focus/domain/entities/focus_session.dart';
import '../features/focus/presentation/pages/home_page.dart';
import '../features/focus/presentation/pages/blocked_app_page.dart';
import '../features/focus/presentation/pages/pre_session_page.dart';
import '../features/focus/presentation/pages/focus_page.dart';
import '../features/focus/presentation/pages/completion_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/statistics/presentation/pages/statistics_page.dart';
import '../features/apps/presentation/pages/apps_page.dart';
import '../features/apps/presentation/pages/permissions_page.dart';
import 'app_shell.dart';
import 'dependencies.dart';

/// Where the app should land when it is launched from a cold start.
enum StartupTarget { onboarding, home, focus, blockedApp }

/// Resolves the cold-start target while honouring an active strict-mode
/// session: if FocusLock was force-closed during a strict session the user
/// must be sent straight to the "stay focused" gate instead of the home tab.
class StartupRouteNotifier extends ChangeNotifier {
  StartupRouteNotifier(this._ref);

  final Ref _ref;
  StartupTarget? _target;
  bool _started = false;

  StartupTarget? get target => _target;

  void ensureStarted() {
    if (_started) return;
    _started = true;
    _resolve();
  }

  Future<void> _resolve() async {
    bool completed;
    try {
      completed = await _ref.read(hasCompletedOnboardingProvider.future);
    } catch (_) {
      _set(StartupTarget.onboarding);
      return;
    }

    if (!completed) {
      _set(StartupTarget.onboarding);
      return;
    }

    var strict = false;
    try {
      strict =
          _ref.read(settingsRepositoryProvider).enforcementLevel == 'strict';
    } catch (_) {
      strict = false;
    }

    FocusSession? activeSession;
    try {
      final repository = _ref.read(focusSessionRepositoryProvider);
      activeSession = await repository.getActiveSession();
    } catch (_) {
      activeSession = null;
    }

    if (activeSession != null && activeSession.isActive) {
      _set(strict ? StartupTarget.blockedApp : StartupTarget.focus);
    } else {
      _set(StartupTarget.home);
    }
  }

  void _set(StartupTarget target) {
    _target = target;
    notifyListeners();
  }
}

final startupRouteProvider = Provider<StartupRouteNotifier>((ref) {
  final notifier = StartupRouteNotifier(ref);
  Future.microtask(notifier.ensureStarted);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final startup = ref.watch(startupRouteProvider);

  return GoRouter(
    initialLocation: '/startup',
    refreshListenable: startup,
    redirect: (context, state) {
      final target = startup.target;
      if (target == null) return null;
      if (state.matchedLocation == '/startup') {
        return switch (target) {
          StartupTarget.onboarding => '/onboarding',
          StartupTarget.home => '/home',
          StartupTarget.focus => '/focus',
          StartupTarget.blockedApp => '/blocked-app',
        };
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => const _StartupGate(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: '/pre-session',
                builder: (context, state) => const PreSessionPage(),
              ),
              GoRoute(
                path: '/apps',
                builder: (context, state) => const AppsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => const StatisticsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsPage(),
      ),
      GoRoute(
        path: '/focus',
        builder: (context, state) => const FocusPage(),
      ),
      GoRoute(
        path: '/blocked-app',
        builder: (context, state) => const BlockedAppPage(),
      ),
      GoRoute(
        path: '/completion',
        builder: (context, state) => const CompletionPage(),
      ),
    ],
  );
});

class _StartupGate extends StatelessWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
