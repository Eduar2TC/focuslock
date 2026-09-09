import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/focus/presentation/pages/home_page.dart';
import '../features/focus/presentation/pages/blocked_app_page.dart';
import '../features/focus/presentation/pages/pre_session_page.dart';
import '../features/focus/presentation/pages/focus_page.dart';
import '../features/focus/presentation/pages/completion_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/statistics/presentation/pages/statistics_page.dart';
import '../features/apps/presentation/pages/apps_page.dart';
import 'app_shell.dart';
import 'dependencies.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);

  return GoRouter(
    initialLocation: hasCompletedOnboarding.when(
      data: (completed) => completed ? '/home' : '/onboarding',
      loading: () => '/onboarding',
      error: (_, __) => '/onboarding',
    ),
    routes: [
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