import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../core/services/native_focus_service.dart';
import '../../../apps/data/repositories/app_repository.dart';
import '../../../../app/dependencies.dart';

class AppsPage extends ConsumerStatefulWidget {
  const AppsPage({super.key});

  @override
  ConsumerState<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends ConsumerState<AppsPage> {
  late AppRepository _appRepository;
  late NativeFocusService _nativeService;
  List<InstalledApp> _installedApps = [];
  List<BlockedApp> _blockedApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _appRepository = ref.read(appRepositoryProvider);
    _nativeService = ref.read(nativeFocusServiceProvider);
    _loadApps();
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
          SnackBar(content: Text('Failed to load apps: $e')),
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Blocked Apps'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildPermissionStatus(),
                Expanded(
                  child: _buildAppsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildPermissionStatus() {
    return FutureBuilder<Map<String, bool>>(
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
            color: AppTheme.warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.warningColor),
                  const SizedBox(width: 8),
                  Text(
                    'Permissions Required',
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
                  child: const Text('Grant Usage Access'),
                ),
              if (!hasAccessibility)
                TextButton(
                  onPressed: () => _nativeService.openAccessibilitySettings(),
                  child: const Text('Grant Accessibility Access'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppsList() {
    if (_installedApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apps, size: 64, color: AppTheme.textSecondaryColor),
            const SizedBox(height: 16),
            Text(
              'No apps found',
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
        final isBlocked = _isAppBlocked(app.packageName);

        return ListTile(
          title: Text(app.appName),
          subtitle: Text(
            app.packageName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Switch(
            value: isBlocked,
            onChanged: (_) => _toggleApp(app),
            activeColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
}
