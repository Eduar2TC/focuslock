import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/services/native_focus_service.dart';
import 'package:focuslock/app/dependencies.dart';

/// Gate shown before starting a strict session. A strict session cannot
/// actually block anything unless the native permissions are granted, so the
/// user is sent here instead of silently starting a fake-blocked session.
class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});

  @override
  ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends ConsumerState<PermissionsPage>
    with WidgetsBindingObserver {
  late NativeFocusService _nativeService;
  Map<String, bool> _permissions = const {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nativeService = ref.read(nativeFocusServiceProvider);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check after the user returns from the system settings screens.
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    try {
      final result = await _nativeService.hasRequiredPermissions();
      if (mounted) {
        setState(() {
          _permissions = result;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  bool get _hasUsage => _permissions['usageStats'] ?? false;
  bool get _hasAccessibility => _permissions['accessibility'] ?? false;
  bool get _allGranted => _hasUsage && _hasAccessibility;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.permissionsPageTitle),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Icon(
                      Icons.security_rounded,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.permissionsPageSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 28),
                    _PermissionTile(
                      icon: Icons.monitor_heart_outlined,
                      label: l10n.permissionsUsageStats,
                      granted: _hasUsage,
                      actionLabel: l10n.appsGrantUsageAccess,
                      onAction: () => _nativeService.openUsageSettings(),
                    ),
                    const SizedBox(height: 12),
                    _PermissionTile(
                      icon: Icons.accessibility_new_rounded,
                      label: l10n.permissionsAccessibility,
                      granted: _hasAccessibility,
                      actionLabel: l10n.appsGrantAccessibilityAccess,
                      onAction: () =>
                          _nativeService.openAccessibilitySettings(),
                    ),
                    const SizedBox(height: 20),
                    if (_allGranted) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.successColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.successColor,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.permissionsAllGranted,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppTheme.successColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _allGranted ? () => Navigator.pop(context) : null,
              icon: const Icon(Icons.lock_open_rounded, size: 20),
              label: Text(l10n.permissionsContinue),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.onPrimaryColor,
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.label,
    required this.granted,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String label;
  final bool granted;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = granted ? AppTheme.successColor : AppTheme.warningColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  granted ? l10n.permissionsGranted : l10n.permissionsMissing,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          if (!granted)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
        ],
      ),
    );
  }
}
