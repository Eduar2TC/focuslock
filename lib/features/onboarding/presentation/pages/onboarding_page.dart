import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../core/extensions/extensions.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      title: 'Welcome to FocusLock',
      subtitle: 'A tool for deep work, not another distraction.',
      icon: Icons.lock_outline,
    ),
    _OnboardingStep(
      title: 'Define Your Intention',
      subtitle: 'Tell us what you want to accomplish. This creates commitment.',
      icon: Icons.edit_outlined,
    ),
    _OnboardingStep(
      title: 'Set Your Timer',
      subtitle: 'Choose how long you want to focus. Start with 25 minutes.',
      icon: Icons.timer_outlined,
    ),
    _OnboardingStep(
      title: 'Choose Your Distractions',
      subtitle: 'Select the apps that pull you away from your work.',
      icon: Icons.block_outlined,
    ),
    _OnboardingStep(
      title: 'Grant Permissions',
      subtitle: 'FocusLock needs these to protect your focus time.',
      icon: Icons.security_outlined,
    ),
    _OnboardingStep(
      title: "You're Ready",
      subtitle: 'Put your phone down and start working. We will handle the rest.',
      icon: Icons.check_circle_outline,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('hasCompletedOnboarding', true);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          step.icon,
                          size: 80,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 48),
                        Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          step.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppTheme.primaryColor
                              : AppTheme.dividerColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _steps.length - 1 ? 'Get Started' : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
