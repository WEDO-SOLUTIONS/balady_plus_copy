import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pilgrim_feature.g.dart';

/// Debug override for the pilgrim feature (Kaaba virtual tour).
///
/// When enabled, bypasses every gate and forces the feature on regardless of
/// theme, configuration, or dates.
@Riverpod(keepAlive: true)
class PilgrimFeatureDebug extends _$PilgrimFeatureDebug {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}

/// `true` when the active [SpecialThemeMode] is a Makkah-based theme
/// (`mekkahBase` or seasonal `ramadan`). Both share the Makkah dashboard
/// and visual identity, so they share the same banner gate.
bool isMakkahTheme(SpecialThemeMode mode) =>
    mode == SpecialThemeMode.mekkahBase || mode == SpecialThemeMode.ramadan;

bool _isPast(DateTime? date) {
  if (date == null) return true;
  return !DateTime.now().isBefore(date);
}

/// Decides whether the pilgrim banner should be visible for the given theme
/// flavour and feature configuration. Mirrors the rules below so the debug
/// panel can render the same answer without duplicating logic.
bool isPilgrimVisibleForTheme({
  required FeatureConfig feature,
  required bool isMakkahTheme,
}) {
  if (!feature.enabled) return false;
  if (isMakkahTheme) {
    return feature.themeMakkah && _isPast(feature.startDateMakkah);
  }
  return feature.themeDefault && _isPast(feature.startDateDefault);
}

/// Pilgrim ("Kaaba virtual journey") feature provider.
///
/// Visibility is decided per theme flavour:
///   - **Makkah themes** (`mekkahBase`, `ramadan`): banner shows when
///     `options.theme_makkah == true` AND `today >= options.start_date_makkah`
///     (or `start_date_makkah` is null).
///   - **Any other theme**: banner shows when `options.theme_default == true`
///     AND `today >= options.start_date_default` (or `start_date_default` is null).
///
/// Returns `null` when the feature is disabled or fails the gates above.
/// `options.start_date` is parsed for backward compatibility only and no longer
/// affects visibility.
@riverpod
FeatureConfig? showPilgrimFeature(Ref ref) {
  final config = ref.watch(placesActivationProvider);
  final debugOverride = ref.watch(pilgrimFeatureDebugProvider);

  final feature = config.maybeWhen(
    data: (data) => data.getFeature('show_pilgrim'),
    orElse: () => null,
  );

  // Debug override bypasses every gate and returns an enabled feature.
  if (debugOverride) {
    return FeatureConfig(
      code: feature?.code ?? 'show_pilgrim',
      enabled: true,
      url: feature?.url ?? 'https://pilgrim.thedatum.ai/kaaba',
      themeDefault: true,
      themeMakkah: true,
    );
  }

  if (feature == null) return null;

  final mode = ref.watch(specialThemeModeProvider);
  final visible = isPilgrimVisibleForTheme(
    feature: feature,
    isMakkahTheme: isMakkahTheme(mode),
  );
  return visible ? feature : null;
}
