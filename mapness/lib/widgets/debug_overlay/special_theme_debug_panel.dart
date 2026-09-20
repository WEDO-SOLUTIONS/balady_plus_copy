import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/debug/recommendations_feature_flag.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_debug.dart';
import 'package:mapness/features/special_themes/core/theme_splash_config.dart';
import 'package:mapness/features/special_themes/core/theme_splash_state.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/mekkah_base_theme.dart';
import 'package:mapness/pages/theme_splash/theme_splash_page.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/location.dart';

// Design tokens
class _DebugColors {
  static const background = Color(0xFF0D0D0F);
  static const surface = Color(0xFF18181B);
  static const surfaceLight = Color(0xFF27272A);
  static const border = Color(0xFF3F3F46);

  static const textPrimary = Color(0xFFFAFAFA);
  static const textSecondary = Color(0xFFA1A1AA);
  static const textMuted = Color(0xFF71717A);

  static const accent = Color(0xFF8B5CF6);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  static const gradientPurple = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
  );
  static const gradientGreen = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF10B981)],
  );
  static const gradientAmber = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );
  static const gradientTeal = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
  );
  static const gradientBlue = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );
}

class SpecialThemeDebugPanel extends ConsumerWidget {
  const SpecialThemeDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    decoration: const BoxDecoration(
      color: _DebugColors.background,
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ActiveThemeCard(),
              const SizedBox(height: 12),
              _DebugTogglesCard(),
              const SizedBox(height: 12),
              const _MakkahDiagnosticsCard(),
              const SizedBox(height: 12),
              const _PilgrimDiagnosticsCard(),
              const SizedBox(height: 12),
              _SplashTestCard(),
              const SizedBox(height: 12),
              const _RemoteConfigCard(),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: _DebugColors.border),
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: _DebugColors.gradientPurple,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _DebugColors.accent.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.palette_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Manager',
              style: context.textStyles.bodyLargeSemiBold.copyWith(
                color: _DebugColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Debug & Configuration',
              style: context.textStyles.captionSmallRegular.copyWith(
                color: _DebugColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _DebugColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _DebugColors.border),
    ),
    child: Padding(
      padding: padding,
      child: child,
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    this.trailing,
    this.iconGradient,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final Gradient? iconGradient;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: iconGradient ?? _DebugColors.gradientPurple,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: context.textStyles.bodySmallSemiBold.copyWith(
          color: _DebugColors.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      if (trailing != null) ...[
        const Spacer(),
        trailing!,
      ],
    ],
  );
}

class _ActiveThemeCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(specialThemeModeProvider);
    final debugOverride = ref.watch(specialThemeModeDebugOverrideProvider);

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.auto_awesome_rounded,
            title: 'Active Theme',
            iconGradient: _DebugColors.gradientAmber,
            trailing: _ActiveBadge(mode: mode),
          ),
          const SizedBox(height: 14),
          _ThemeSelector(currentMode: mode),
          if (debugOverride != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _DebugColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _DebugColors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bug_report_rounded,
                    size: 14,
                    color: _DebugColors.warning,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Override: ${debugOverride.name}',
                    style: context.textStyles.captionSmallMedium.copyWith(
                      color: _DebugColors.warning,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.mode});

  final SpecialThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final isActive = mode != SpecialThemeMode.base;
    final color = isActive ? _DebugColors.success : _DebugColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? mode.name.toUpperCase() : 'INACTIVE',
            style: context.textStyles.captionSmallMedium.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.currentMode});

  final SpecialThemeMode currentMode;

  @override
  Widget build(BuildContext context) {
    final themes = [
      // Re-enabled for the 2026 release: the activation window is only a few
      // days long, so this is the only way to exercise the theme outside it.
      ('National', SpecialThemeMode.nationalDay, _DebugColors.gradientGreen),
      ('Foundation', SpecialThemeMode.foundationDay, _DebugColors.gradientPurple),
      ('Makkah', SpecialThemeMode.mekkahBase, _DebugColors.gradientAmber),
      // ('Ramadan', SpecialThemeMode.ramadan, _DebugColors.gradientTeal),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: themes.map((t) {
        final isActive = currentMode == t.$2;
        return _ThemeChip(
          label: t.$1,
          isActive: isActive,
          gradient: t.$3,
        );
      }).toList(),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.isActive,
    required this.gradient,
  });

  final String label;
  final bool isActive;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      gradient: isActive ? gradient : null,
      color: isActive ? null : _DebugColors.surfaceLight,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isActive ? Colors.transparent : _DebugColors.border,
      ),
      boxShadow: isActive
          ? [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    ),
    child: Text(
      label,
      style: context.textStyles.captionSmallMedium.copyWith(
        color: isActive ? Colors.white : _DebugColors.textSecondary,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
      ),
    ),
  );
}

class _DebugTogglesCard extends ConsumerWidget {
  void _trackDebugToggle(String feature, bool enabled) {
    Metrics.logEventAdvanced(
      enabled ? MetricsConstants.themesKeys.debugOverrideEnabled : MetricsConstants.themesKeys.debugOverrideDisabled,
      group: MetricsConstants.themesTag,
      props: {'feature': feature, 'enabled': enabled},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nationalDay = ref.watch(saudiNationalDayDebugProvider);
    final foundationDay = ref.watch(foundationDayDebugProvider);
    final mekkahBase = ref.watch(mekkahBaseThemeDebugProvider);
    final ramadan = ref.watch(ramadanSeasonDebugProvider);
    final hajj = ref.watch(hajjSeasonDebugProvider);
    final pilgrimFeature = ref.watch(pilgrimFeatureDebugProvider);
    final recommendationsFeature = ref.watch(recommendationsFeatureFlagProvider);
    final leap = ref.watch(leapDebugProvider);

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bug_report_rounded,
            title: 'Debug Overrides',
            iconGradient: _DebugColors.gradientBlue,
          ),
          const SizedBox(height: 14),
          _ToggleRow(
            label: 'Saudi National Day',
            value: nationalDay,
            onChanged: (v) {
              final notifier = ref.read(saudiNationalDayDebugProvider.notifier);
              if (v) {
                notifier.enable();
              } else {
                notifier.disable();
              }
            },
            gradient: _DebugColors.gradientGreen,
          ),
          _ToggleRow(
            label: 'Foundation Day',
            value: foundationDay,
            onChanged: (v) {
              _trackDebugToggle('foundationDay', v);
              ref.read(foundationDayDebugProvider.notifier).set(v);
            },
            gradient: _DebugColors.gradientPurple,
          ),
          _ToggleRow(
            label: 'Makkah Base',
            value: mekkahBase,
            onChanged: (v) {
              _trackDebugToggle('mekkahBase', v);
              ref.read(mekkahBaseThemeDebugProvider.notifier).set(v);
            },
            gradient: _DebugColors.gradientAmber,
          ),
          // _ToggleRow(
          //   label: 'Ramadan Season',
          //   value: ramadan,
          //   onChanged: (v) {
          //     _trackDebugToggle('ramadan', v);
          //     ref.read(ramadanSeasonDebugProvider.notifier).set(v);
          //   },
          //   gradient: _DebugColors.gradientTeal,
          // ),
          // _ToggleRow(
          //   label: 'Hajj Season',
          //   value: hajj,
          //   onChanged: (v) {
          //     _trackDebugToggle('hajj', v);
          //     ref.read(hajjSeasonDebugProvider.notifier).set(v);
          //   },
          //   gradient: _DebugColors.gradientBlue,
          // ),
          _ToggleRow(
            label: 'Pilgrim Feature',
            value: pilgrimFeature,
            onChanged: (v) {
              _trackDebugToggle('pilgrim', v);
              ref.read(pilgrimFeatureDebugProvider.notifier).set(v);
            },
            gradient: _DebugColors.gradientGreen,
          ),
          _ToggleRow(
            label: 'Recommendations Feature',
            value: recommendationsFeature,
            onChanged: (v) {
              ref.read(recommendationsFeatureFlagProvider.notifier).set(v);
            },
            gradient: _DebugColors.gradientGreen,
          ),
          _ToggleRow(
            label: 'LEAP Event',
            value: leap,
            onChanged: (v) {
              ref.read(leapDebugProvider.notifier).enabled = v;
            },
            gradient: _DebugColors.gradientTeal,
          ),
          const SizedBox(height: 14),
          _LocationRefreshRow(),
        ],
      ),
    );
  }
}

class _LocationRefreshRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final locationText = location != null
        ? '(${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)})'
        : 'null';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: _DebugColors.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Location: $locationText',
                style: context.textStyles.captionSmallRegular.copyWith(
                  color: _DebugColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Track location refresh
                Metrics.logEventAdvanced(
                  MetricsConstants.themesKeys.debugLocationRefreshed,
                  group: MetricsConstants.themesTag,
                );
                ref.read(locationProvider.notifier).refreshLocation();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: _DebugColors.gradientGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Refresh',
                  style: context.textStyles.captionSmallMedium.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.gradient,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            gradient: value ? gradient : null,
            color: value ? null : _DebugColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: context.textStyles.bodySmallRegular.copyWith(
              color: value ? _DebugColors.textPrimary : _DebugColors.textSecondary,
            ),
          ),
        ),
        _CustomSwitch(
          value: value,
          onChanged: onChanged,
          gradient: gradient,
        ),
      ],
    ),
  );
}

class _CustomSwitch extends StatelessWidget {
  const _CustomSwitch({
    required this.value,
    required this.onChanged,
    required this.gradient,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        gradient: value ? gradient : null,
        color: value ? null : _DebugColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? Colors.transparent : _DebugColors.border,
        ),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SplashTestCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(specialThemeModeProvider);
    final hasSplash = currentMode.splashConfig.enabled;

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.play_circle_rounded,
            title: 'Test Splash',
            iconGradient: _DebugColors.gradientGreen,
          ),
          const SizedBox(height: 14),
          if (!hasSplash)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _DebugColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: _DebugColors.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No splash for "${currentMode.name}" theme',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: _DebugColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            _GradientButton(
              label: 'Show ${currentMode.name} Splash',
              icon: Icons.play_arrow_rounded,
              gradient: _DebugColors.gradientGreen,
              onTap: () => _showSplash(ref, currentMode),
            ),
        ],
      ),
    );
  }

  void _showSplash(WidgetRef ref, SpecialThemeMode mode) {
    // Track debug splash triggered
    Metrics.logEventAdvanced(
      MetricsConstants.themesKeys.debugSplashTriggered,
      group: MetricsConstants.themesTag,
      props: {'theme': mode.name},
    );

    final splashState = ref.read(themeSplashStateProvider.notifier);
    splashState.resetSplashFor(mode);

    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => ThemeSplashPage(
          theme: mode,
          onClose: () {
            splashState.markSplashShown(mode);
            // Navigation handled by StoriesPage via useNavigatorPop
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.textStyles.bodySmallSemiBold.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RemoteConfigCard extends ConsumerWidget {
  const _RemoteConfigCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(placesActivationProvider);

    return _GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: _SectionTitle(
              icon: Icons.cloud_rounded,
              title: 'Remote Config',
              iconGradient: _DebugColors.gradientTeal,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  configAsync.when(
                    data: (_) => const _StatusDot(color: _DebugColors.success),
                    loading: () => const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _DebugColors.accent,
                      ),
                    ),
                    error: (_, __) => const _StatusDot(color: _DebugColors.error),
                  ),
                  const SizedBox(width: 10),
                  _RefreshButton(
                    onTap: () {
                      // Track config refresh
                      Metrics.logEventAdvanced(
                        MetricsConstants.themesKeys.debugConfigRefreshed,
                        group: MetricsConstants.themesTag,
                      );
                      ref.read(placesActivationProvider.notifier).refresh();
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: _DebugColors.border,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: configAsync.when(
              data: (config) => _ConfigDetails(config: config),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: _DebugColors.accent),
                ),
              ),
              error: (e, _) => _ErrorBox(message: e.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 4,
        ),
      ],
    ),
  );
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _DebugColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _DebugColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.refresh_rounded,
            size: 12,
            color: _DebugColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            'Refresh',
            style: context.textStyles.captionSmallMedium.copyWith(
              color: _DebugColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _DebugColors.error.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _DebugColors.error.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, size: 16, color: _DebugColors.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: context.textStyles.captionSmallRegular.copyWith(
              color: _DebugColors.error,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ConfigDetails extends StatelessWidget {
  const _ConfigDetails({required this.config});

  final PlacesActivationConfig config;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ConfigMeta(config: config),
      const SizedBox(height: 14),
      const _SubsectionLabel(label: 'THEMES'),
      const SizedBox(height: 8),
      if (config.presentThemes.contains('mekkah'))
        _ThemeConfigItem(
          name: 'Mekkah',
          config: config.mekkah,
          gradient: _DebugColors.gradientAmber,
        ),
      if (config.presentThemes.contains('foundation_day'))
        _ThemeConfigItem(
          name: 'Foundation Day',
          config: config.foundationDay,
          gradient: _DebugColors.gradientPurple,
        ),
      if (config.presentThemes.contains('ramadan'))
        _ThemeConfigItem(
          name: 'Ramadan',
          config: config.ramadan,
          gradient: _DebugColors.gradientTeal,
        ),
      if (config.presentThemes.contains('hajj'))
        _ThemeConfigItem(
          name: 'Hajj',
          config: config.hajj,
          gradient: _DebugColors.gradientBlue,
        ),
      if (config.presentThemes.isEmpty)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _DebugColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: _DebugColors.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                'No themes defined in config',
                style: context.textStyles.captionSmallRegular.copyWith(
                  color: _DebugColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      if (config.features.isNotEmpty) ...[
        const SizedBox(height: 14),
        const _SubsectionLabel(label: 'FEATURES'),
        const SizedBox(height: 8),
        ...config.features.map((f) => _FeatureItem(feature: f)),
      ],
    ],
  );
}

class _ConfigMeta extends StatelessWidget {
  const _ConfigMeta({required this.config});

  final PlacesActivationConfig config;

  @override
  Widget build(BuildContext context) {
    final forceEnabled = _getForceEnabled(config);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _DebugColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _MetaBadge(
            label: 'v${config.version}',
            color: _DebugColors.info,
          ),
          const SizedBox(width: 8),
          _MetaBadge(
            label: forceEnabled.isNotEmpty ? 'Force: $forceEnabled' : 'No Force',
            color: forceEnabled.isNotEmpty ? _DebugColors.warning : _DebugColors.textMuted,
          ),
        ],
      ),
    );
  }

  String _getForceEnabled(PlacesActivationConfig config) {
    if (config.mekkah.forceEnabled) return 'mekkah';
    if (config.ramadan.forceEnabled) return 'ramadan';
    if (config.hajj.forceEnabled) return 'hajj';
    if (config.foundationDay.forceEnabled) return 'foundation_day';
    return '';
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: context.textStyles.captionSmallMedium.copyWith(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _SubsectionLabel extends StatelessWidget {
  const _SubsectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: context.textStyles.captionSmallMedium.copyWith(
      color: _DebugColors.textMuted,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    ),
  );
}

class _ThemeConfigItem extends StatelessWidget {
  const _ThemeConfigItem({
    required this.name,
    required this.config,
    required this.gradient,
  });

  final String name;
  final ThemeConfig config;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final primaryColor = gradient.colors.first;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: config.enabled ? primaryColor.withOpacity(0.08) : _DebugColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: config.enabled ? primaryColor.withOpacity(0.2) : _DebugColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: config.enabled ? gradient : null,
                  color: config.enabled ? null : _DebugColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: context.textStyles.captionSmallSemiBold.copyWith(
                  color: config.enabled ? _DebugColors.textPrimary : _DebugColors.textMuted,
                ),
              ),
              const Spacer(),
              if (config.forceEnabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _DebugColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'FORCED',
                    style: context.textStyles.captionSmallMedium.copyWith(
                      color: _DebugColors.warning,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          if (config.startDate != null || config.endDate != null || config.area != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: [
                if (config.startDate != null)
                  _InfoChip(
                    icon: Icons.event_rounded,
                    label: _formatDate(config.startDate!),
                  ),
                if (config.endDate != null)
                  _InfoChip(
                    icon: Icons.event_busy_rounded,
                    label: _formatDate(config.endDate!),
                  ),
                if (config.area != null)
                  _InfoChip(
                    icon: Icons.location_on_rounded,
                    label: '${config.area!.radiusKm}km',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _FeatureItem extends ConsumerWidget {
  const _FeatureItem({required this.feature});

  final FeatureConfig feature;

  /// Mirrors [showPilgrimFeatureProvider]: when `show_pilgrim` has a `start_date`,
  /// it's also gated on being inside the Makkah area.
  bool _pilgrimNeedsMakkahArea() => feature.code == 'show_pilgrim' && feature.startDate != null;

  /// Returns true if the feature is effectively active (enabled AND past start_date,
  /// plus the Makkah-area gate for scoped pilgrim).
  bool _isEffectivelyActive(WidgetRef ref, bool debugOverride) {
    if (debugOverride) return true;
    if (!feature.enabled) return false;
    if (feature.startDate != null && DateTime.now().isBefore(feature.startDate!)) {
      return false;
    }
    if (_pilgrimNeedsMakkahArea()) {
      return ref.watch(mekkahBaseThemeProvider);
    }
    return true;
  }

  /// Returns the reason why feature is not active
  String? _getInactiveReason(WidgetRef ref, bool debugOverride) {
    if (debugOverride) return null;
    if (!feature.enabled) return null;
    if (feature.startDate != null && DateTime.now().isBefore(feature.startDate!)) {
      return 'Starts ${_formatDate(feature.startDate!)}';
    }
    if (_pilgrimNeedsMakkahArea() && !ref.watch(mekkahBaseThemeProvider)) {
      return 'Outside Makkah area';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if this feature has a debug override
    final isPilgrimFeature = feature.code == 'show_pilgrim';
    final debugOverride = isPilgrimFeature && ref.watch(pilgrimFeatureDebugProvider);

    final isActive = _isEffectivelyActive(ref, debugOverride);
    final inactiveReason = _getInactiveReason(ref, debugOverride);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive ? _DebugColors.info.withOpacity(0.08) : _DebugColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: debugOverride
              ? _DebugColors.warning.withOpacity(0.5)
              : isActive
              ? _DebugColors.info.withOpacity(0.2)
              : _DebugColors.border,
          width: debugOverride ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                size: 18,
                color: isActive ? _DebugColors.info : _DebugColors.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature.code,
                  style: context.textStyles.captionSmallSemiBold.copyWith(
                    color: isActive ? _DebugColors.textPrimary : _DebugColors.textMuted,
                  ),
                ),
              ),
              if (debugOverride)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: _DebugColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'DEBUG',
                    style: context.textStyles.captionSmallMedium.copyWith(
                      color: _DebugColors.warning,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              _StatusPill(
                label: isActive ? 'ACTIVE' : 'INACTIVE',
                isActive: isActive,
              ),
            ],
          ),
          if (feature.url != null || feature.startDate != null || inactiveReason != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 4,
              children: [
                if (inactiveReason != null)
                  _InfoChip(
                    icon: Icons.schedule_rounded,
                    label: inactiveReason,
                  ),
                if (feature.startDate != null && inactiveReason == null)
                  _InfoChip(
                    icon: Icons.event_rounded,
                    label: _formatDate(feature.startDate!),
                  ),
                if (feature.url != null)
                  _InfoChip(
                    icon: Icons.link_rounded,
                    label: Uri.tryParse(feature.url!)?.host ?? feature.url!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _DebugColors.success : _DebugColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: context.textStyles.captionSmallMedium.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: _DebugColors.textMuted),
      const SizedBox(width: 4),
      Text(
        label,
        style: context.textStyles.captionSmallRegular.copyWith(
          color: _DebugColors.textSecondary,
          fontSize: 10,
        ),
      ),
    ],
  );
}

class _MakkahDiagnosticsCard extends ConsumerWidget {
  const _MakkahDiagnosticsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final mekkahConfig = ref.watch(placesActivationMekkahProvider);
    final isInMakkahArea = ref.watch(mekkahBaseThemeProvider);
    final area = mekkahConfig.area ?? MakkahAreaConfig.defaultConfig;

    // Calculate distance
    double? distanceKm;
    if (location != null) {
      distanceKm = CommonFunctions.distance(
        location.latitude,
        location.longitude,
        area.latitude,
        area.longitude,
      );
    }

    // Check date range
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isAfterStart = mekkahConfig.startDate == null || !today.isBefore(mekkahConfig.startDate!);
    final isBeforeEnd = mekkahConfig.endDate == null || !today.isAfter(mekkahConfig.endDate!);
    final isInDateRange = isAfterStart && isBeforeEnd;

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.troubleshoot_rounded,
            title: 'Makkah Diagnostics',
            iconGradient: _DebugColors.gradientAmber,
          ),
          const SizedBox(height: 14),
          _DiagRow(
            label: 'Config enabled',
            value: mekkahConfig.enabled,
          ),
          _DiagRow(
            label: 'Force enabled',
            value: mekkahConfig.forceEnabled,
          ),
          _DiagRow(
            label: 'In date range',
            value: isInDateRange,
            detail: mekkahConfig.startDate != null
                ? '${_formatDate(mekkahConfig.startDate!)} - ${mekkahConfig.endDate != null ? _formatDate(mekkahConfig.endDate!) : '∞'}'
                : 'no dates',
          ),
          _DiagRow(
            label: 'In Makkah area',
            value: isInMakkahArea,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _DebugColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOCATION CHECK',
                  style: context.textStyles.captionSmallMedium.copyWith(
                    color: _DebugColors.textMuted,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                _LocationRow(
                  label: 'Your location',
                  lat: location?.latitude,
                  lon: location?.longitude,
                ),
                const SizedBox(height: 4),
                _LocationRow(
                  label: 'Config center',
                  lat: area.latitude,
                  lon: area.longitude,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.straighten_rounded,
                      size: 12,
                      color: _DebugColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Distance: ',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: _DebugColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      distanceKm != null ? '${distanceKm.toStringAsFixed(3)} km' : 'N/A',
                      style: context.textStyles.captionSmallMedium.copyWith(
                        color: distanceKm != null && distanceKm <= area.radiusKm
                            ? _DebugColors.success
                            : _DebugColors.error,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      ' / ${area.radiusKm} km radius',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: _DebugColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}';
}

/// Diagnostics card for the `show_pilgrim` feature. Mirrors [_MakkahDiagnosticsCard]
/// in shape and surfaces the gates that [showPilgrimFeatureProvider] applies:
///
///   - debug override
///   - config enabled
///   - past start date
///   - scope (Global if `start_date` is absent, Makkah-only if present)
///   - in-Makkah-area gate (only relevant when scoped to Makkah)
class _PilgrimDiagnosticsCard extends ConsumerWidget {
  const _PilgrimDiagnosticsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(placesActivationProvider);
    final feature = config.maybeWhen(
      data: (data) => data.getFeature('show_pilgrim'),
      orElse: () => null,
    );
    final debugOverride = ref.watch(pilgrimFeatureDebugProvider);
    final isInMakkahArea = ref.watch(mekkahBaseThemeProvider);

    final hasStartDate = feature?.startDate != null;
    final isPastStartDate = !hasStartDate || !DateTime.now().isBefore(feature!.startDate!);
    final scopeLabel = hasStartDate ? 'Makkah-only' : 'Global';
    final scopeIcon = hasStartDate ? Icons.location_on_rounded : Icons.public_rounded;
    final scopeDescription = hasStartDate
        ? 'start_date present → shown only to users in Makkah area, from that date'
        : 'start_date absent → shown globally to every user, immediately';

    // Mirrors [showPilgrimFeatureProvider]: debug override wins; otherwise feature
    // must be enabled, past start date, and — when scoped — inside Makkah area.
    final isEffective =
        debugOverride || (feature != null && feature.enabled && isPastStartDate && (!hasStartDate || isInMakkahArea));

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.troubleshoot_rounded,
            title: 'Pilgrim Diagnostics',
            iconGradient: _DebugColors.gradientGreen,
          ),
          const SizedBox(height: 14),
          _DiagRow(
            label: 'Debug override',
            value: debugOverride,
          ),
          _DiagRow(
            label: 'Config enabled',
            value: feature?.enabled ?? false,
            detail: feature == null ? 'no feature in config' : null,
          ),
          _DiagRow(
            label: 'Past start date',
            value: isPastStartDate,
            detail: hasStartDate ? _formatDate(feature!.startDate!) : 'no start date',
          ),
          _DiagRow(
            label: 'In Makkah area',
            value: isInMakkahArea,
            detail: hasStartDate ? null : 'not required (global)',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _DebugColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SCOPE',
                  style: context.textStyles.captionSmallMedium.copyWith(
                    color: _DebugColors.textMuted,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      scopeIcon,
                      size: 14,
                      color: _DebugColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      scopeLabel,
                      style: context.textStyles.captionSmallSemiBold.copyWith(
                        color: _DebugColors.textPrimary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  scopeDescription,
                  style: context.textStyles.captionSmallRegular.copyWith(
                    color: _DebugColors.textMuted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Effective: ',
                      style: context.textStyles.captionSmallRegular.copyWith(
                        color: _DebugColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    _StatusPill(
                      label: isEffective ? 'ACTIVE' : 'INACTIVE',
                      isActive: isEffective,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}';
}

class _DiagRow extends StatelessWidget {
  const _DiagRow({
    required this.label,
    required this.value,
    this.detail,
  });

  final String label;
  final bool value;
  final String? detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(
          value ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 14,
          color: value ? _DebugColors.success : _DebugColors.error,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: context.textStyles.captionSmallRegular.copyWith(
            color: _DebugColors.textSecondary,
            fontSize: 11,
          ),
        ),
        if (detail != null) ...[
          const SizedBox(width: 6),
          Text(
            '($detail)',
            style: context.textStyles.captionSmallRegular.copyWith(
              color: _DebugColors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ],
    ),
  );
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.label,
    required this.lat,
    required this.lon,
  });

  final String label;
  final double? lat;
  final double? lon;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 80,
        child: Text(
          label,
          style: context.textStyles.captionSmallRegular.copyWith(
            color: _DebugColors.textMuted,
            fontSize: 10,
          ),
        ),
      ),
      Expanded(
        child: Text(
          lat != null && lon != null ? '${lat!.toStringAsFixed(5)}, ${lon!.toStringAsFixed(5)}' : 'null',
          style: context.textStyles.captionSmallMedium.copyWith(
            color: lat != null ? _DebugColors.textSecondary : _DebugColors.error,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
      ),
    ],
  );
}
