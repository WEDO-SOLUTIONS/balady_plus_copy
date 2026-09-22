import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_config.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_national_day_resolved_config.g.dart';

/// The effective Saudi National Day config.
///
/// The activation window comes from `saudiNationalDayDateRange` in the
/// `app_env_config` Firebase Remote Config parameter — the same place every
/// other city event (cityscape, founding day, LEAP, WRC) keeps its dates.
/// Firebase re-fetches on every app open, so moving the window is a Console
/// edit and takes effect on the next launch.
///
/// Remote Config JSON (per environment, inside `app_env_config`):
/// ```json
/// "saudiNationalDayDateRange": { "from": "22-09-26", "to": "24-09-26", "enabled": true }
/// ```
/// Dates are `dd-MM-yy`, matching the other event ranges. `to` is inclusive
/// (see [CityEventDateRange.isDateInRange], which adds a day internally).
/// The optional `enabled` flag kills the theme without moving the dates.
///
/// The presentation-only bits that `CityEventDateRange` has no room for —
/// the banner anniversary number and the launcher-icon gate — keep their
/// defaults from [SaudiNationalDayRemoteConfig.bundledDefault].
@Riverpod(keepAlive: true)
SaudiNationalDayRemoteConfig saudiNationalDayResolvedConfig(Ref ref) {
  final resolved = _resolve(ref);
  // Mirror onto the static bridge so the synchronous `SaudiNationalDay.isNow()`
  // call sites scattered through the widget tree see the same config.
  SaudiNationalDayRemoteConfig.publishResolved(resolved);
  return resolved;
}

SaudiNationalDayRemoteConfig _resolve(Ref ref) {
  final fallback = SaudiNationalDayRemoteConfig.bundledDefault;

  final env = ref.watch(dgisEnvironmentProvider).value;
  if (env == null) {
    // Config not loaded yet (first frames of a cold start). The bundled
    // default already carries this year's window, so the theme still behaves
    // correctly rather than flickering off.
    return fallback;
  }

  final range = env.saudiNationalDayDateRange;

  // TEMP DIAGNOSTIC — remove before merging.
  // ignore: avoid_print
  print(
    '[SND] remote from=${range.from} to=${range.to} enabled=${range.enabled} '
    'now=${DateTime.now()} '
    'active=${!DateTime.now().isBefore(DateTime(range.from.year, range.from.month, range.from.day)) && !DateTime.now().isAfter(DateTime(range.to.year, range.to.month, range.to.day, 23, 59, 59))}',
  );

  return SaudiNationalDayRemoteConfig(
    // `enabled` is optional in the JSON; absent means "just use the dates".
    enabled: range.enabled ?? true,
    startDate: DateTime(range.from.year, range.from.month, range.from.day),
    // `to` is an inclusive date-only bound, so extend it to the last instant
    // of that day — otherwise the theme would switch off at 00:00 and lose
    // the final day of the window.
    endDate: DateTime(range.to.year, range.to.month, range.to.day, 23, 59, 59),
    anniversary: fallback.anniversary,
    appIconEnabled: fallback.appIconEnabled,
  );
}
