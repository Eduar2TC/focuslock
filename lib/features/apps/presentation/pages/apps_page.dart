import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/core/services/native_focus_service.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';
import 'package:focuslock/app/dependencies.dart';
import 'package:focuslock/core/models/app_models.dart';

class AppsPage extends ConsumerStatefulWidget {
  const AppsPage({super.key});

  @override
  ConsumerState<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends ConsumerState<AppsPage> with WidgetsBindingObserver {
  late AppRepository _appRepository;
  late NativeFocusService _nativeService;
  List<InstalledApp> _installedApps = [];
  List<BlockedApp> _blockedApps = [];
  bool _isLoading = true;
  int _permissionsKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appRepository = ref.read(appRepositoryProvider);
    _nativeService = ref.read(nativeFocusServiceProvider);
    _loadApps();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _permissionsKey++);
    }
  }

  Future<void> _loadApps() async {
    try {
      final installed = await _nativeService.getInstalledApps();
      final blocked = _appRepository.getBlockedApps();

      if (mounted) {
        setState(() {
          _installedApps = installed;
          _blockedApps = blocked;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.appsErrorLoad('$e')),
          ),
        );
      }
    }
  }

  bool _isAppBlocked(String packageName) {
    return _blockedApps.any((app) => app.packageName == packageName);
  }

  Future<void> _toggleApp(InstalledApp app) async {
    if (_isAppBlocked(app.packageName)) {
      await _appRepository.removeBlockedApp(app.packageName);
    } else {
      await _appRepository.addBlockedApp(BlockedApp(
        packageName: app.packageName,
        appName: app.appName,
      ));
    }

    setState(() {
      _blockedApps = _appRepository.getBlockedApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.appsAppbarTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildPermissionStatus(l10n),
                Expanded(
                  child: _buildAppsList(l10n),
                ),
              ],
            ),
    );
  }

  Widget _buildPermissionStatus(AppLocalizations l10n) {
    return FutureBuilder<Map<String, bool>>(
      key: ValueKey(_permissionsKey),
      future: _nativeService.hasRequiredPermissions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final permissions = snapshot.data!;
        final hasUsage = permissions['usageStats'] ?? false;
        final hasAccessibility = permissions['accessibility'] ?? false;

        if (hasUsage && hasAccessibility) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.warningColor),
                  const SizedBox(width: 8),
                  Text(
                    l10n.appsPermissionsRequired,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.warningColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (!hasUsage)
                TextButton(
                  onPressed: () => _nativeService.openUsageSettings(),
                  child: Text(l10n.appsGrantUsageAccess),
                ),
              if (!hasAccessibility)
                TextButton(
                  onPressed: () => _nativeService.openAccessibilitySettings(),
                  child: Text(l10n.appsGrantAccessibilityAccess),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppsList(AppLocalizations l10n) {
    if (_installedApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apps, size: 64, color: AppTheme.textSecondaryColor),
            const SizedBox(height: 16),
            Text(
              l10n.appsEmptyTitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _installedApps.length,
      itemBuilder: (context, index) {
        final app = _installedApps[index];
        
        return ListTile(
          title: Text(app.appName),
          subtitle: Text(
            app.packageName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
trailing: Switch(
            value: _isAppBlocked(app.packageName),
            onChanged: (_) => _toggleApp(app),
            activeThumbColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
}
