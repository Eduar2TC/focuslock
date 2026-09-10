import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focuslock/l10n/app_localizations.dart';
import 'package:focuslock/shared/theme/app_theme.dart';
import 'package:focuslock/app/dependencies.dart';
import 'package:focuslock/features/apps/data/repositories/app_repository.dart';

class PreSessionPage extends ConsumerStatefulWidget {
  const PreSessionPage({super.key});

  @override
  ConsumerState<PreSessionPage> createState() => _PreSessionPageState();
}

class _PreSessionPageState extends ConsumerState<PreSessionPage> {
  static const int _maxVisibleChips = 5;

  final TextEditingController _taskController = TextEditingController();
  late int _selectedDuration;
  late String _selectedMode;

  int get _selectedModeDuration => _selectedDuration;

  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsRepositoryProvider);
    _selectedDuration = settings.focusDuration;
    _selectedMode = settings.enforcementLevel == 'strict' ? 'strict' : 'normal';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_prefilled) {
      _prefilled = true;
      _taskController.text =
          AppLocalizations.of(context)!.presessionTaskDefault;
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  List<int> get _durationOptions {
    final options = <int>[15, 25, 45, 60];
    if (!options.contains(_selectedDuration)) {
      options.insert(0, _selectedDuration);
    }
    return options;
  }

  List<BlockedApp> get _enabledBlockedApps {
    final repository = ref.read(appRepositoryProvider);
    return repository.getBlockedApps().where((app) => app.enabled).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            _buildSetupHeader(l10n),
            const SizedBox(height: 20),
            _buildTaskInput(l10n),
            const SizedBox(height: 24),
            _buildDurationSelector(l10n),
            const SizedBox(height: 24),
            _buildBlockedAppsSection(l10n),
            const SizedBox(height: 24),
            _buildEnforcementMode(l10n),
            const SizedBox(height: 28),
            _buildStartButton(l10n),
            const SizedBox(height: 16),
            _buildFaceDownTip(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user,
                              size: 14, color: AppTheme.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            l10n.presessionSetupChip,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.presessionReadyTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.presessionReadySubtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SizedBox(
                width: 48,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_clock,
                      size: 26, color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.presessionTaskLabel,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 15),
              ),
            ),
            Text(
              l10n.presessionRequired,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.edit_note,
                  size: 22, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _taskController,
                  style:
                      const TextStyle(fontSize: 16, color: AppTheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: l10n.presessionTaskHint,
                    hintStyle:
                        const TextStyle(color: AppTheme.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              IconButton(
                onPressed: _taskController.clear,
                icon: const Icon(Icons.close,
                    size: 18, color: AppTheme.onSurfaceVariant),
                tooltip: l10n.commonClear,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.presessionDurationLabel,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 32),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.presessionCustom),
                  const SizedBox(width: 2),
                  const Icon(Icons.tune, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: _durationOptions.map((minutes) {
            final isSelected = _selectedDuration == minutes;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDuration = minutes),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryContainer
                        : AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$minutes',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 20,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? AppTheme.onPrimaryContainer
                              : AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.presessionMin,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.onPrimaryContainer
                              : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBlockedAppsSection(AppLocalizations l10n) {
    final apps = _enabledBlockedApps;
    final visible = apps.take(_maxVisibleChips).toList();
    final extra = apps.length - visible.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    l10n.presessionAppsToBlock,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      l10n.presessionActiveCount(apps.length),
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push('/apps'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                minimumSize: const Size(0, 32),
              ),
              icon: const Icon(Icons.edit, size: 15),
              label: Text(l10n.presessionManage),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (apps.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              l10n.presessionNoBlockedApps,
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...visible.map((app) => _AppBlockChip(app: app)),
              if (extra > 0)
                GestureDetector(
                  onTap: () => context.push('/apps'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      l10n.presessionMoreCount(extra),
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildEnforcementMode(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            l10n.presessionEnforcementMode,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
        ),
        const SizedBox(height: 12),
        _ModeCard(
          title: l10n.modeStandard,
          icon: Icons.lock_open_rounded,
          description: l10n.modeStandardDescription,
          selected: _selectedMode == 'normal',
          recommended: false,
          onTap: () => _selectMode('normal'),
        ),
        const SizedBox(height: 10),
        _ModeCard(
          title: l10n.modeStrict,
          icon: Icons.shield_rounded,
          description: l10n.modeStrictDescription,
          selected: _selectedMode == 'strict',
          recommended: true,
          onTap: () => _selectMode('strict'),
        ),
      ],
    );
  }

  void _selectMode(String mode) {
    if (_selectedMode == mode) return;
    setState(() => _selectedMode = mode);
    // Only persist the mode; cancel/bypass behavior is derived from it at
    // runtime so the Settings screen switches are not silently clobbered.
    ref.read(settingsRepositoryProvider).setEnforcementLevel(mode);
  }

  Widget _buildStartButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: _startSession,
        icon: const Icon(Icons.bolt, size: 22, color: AppTheme.onPrimaryColor),
        label: Text(l10n.presessionStartWithDuration(_selectedModeDuration)),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.onPrimaryColor,
          shape: const StadiumBorder(),
          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.25),
        ).copyWith(
          elevation: const WidgetStatePropertyAll(6),
        ),
      ),
    );
  }

  void _startSession() async {
    final task = _taskController.text.trim();
    if (task.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.presessionErrorEmptyTask)),
      );
      return;
    }

    if (_selectedMode == 'strict') {
      if (_enabledBlockedApps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.presessionErrorRequiresApps),
          ),
        );
        return;
      }
      if (!await _hasBlockingPermissions()) {
        context.push('/permissions');
        return;
      }
    }

    try {
      final controller = ref.read(focusSessionControllerProvider.notifier);
      controller.prepareSession(task, durationMinutes: _selectedDuration);
      context.push('/focus');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  /// A strict session must actually block apps; if the native permission is
  /// missing the user is redirected to the accessibility/usage grant screen
  /// instead of silently skipping the blocked-app gate.
  Future<bool> _hasBlockingPermissions() async {
    try {
      final result =
          await ref.read(nativeFocusServiceProvider).hasRequiredPermissions();
      return (result['accessibility'] ?? false) &&
          (result['usageStats'] ?? false);
    } catch (_) {
      // Non-Android environment (tests/desktop): do not block the flow.
      return true;
    }
  }

  Widget _buildFaceDownTip(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.screen_rotation_alt,
              size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.presessionFaceDownTip,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.selected,
    required this.recommended,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String description;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.surfaceContainerHighest
              : AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.4), width: 1)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: selected
                    ? const Icon(Icons.circle,
                        size: 8, color: AppTheme.onPrimaryColor)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (recommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            l10n.modeRecommended,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        )
                      else
                        Icon(icon, size: 18, color: AppTheme.onSurfaceVariant),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 13),
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

class _AppBlockChip extends StatelessWidget {
  const _AppBlockChip({required this.app});

  final BlockedApp app;

  @override
  Widget build(BuildContext context) {
    final monogram = app.appName.isNotEmpty
        ? app.appName.substring(0, 1).toUpperCase()
        : app.packageName.substring(0, 1).toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              monogram,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            app.appName,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
