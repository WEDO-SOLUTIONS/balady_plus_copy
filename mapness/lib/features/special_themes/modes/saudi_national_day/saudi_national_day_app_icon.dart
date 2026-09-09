import 'dart:io';

import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_config.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Swaps the launcher icon for the Saudi National Day window.
///
/// Driven by remote config: the activation window comes from
/// `saudiNationalDayDateRange` in `app_env_config`, so the icon can be moved
/// or switched off from the Firebase Console without an app release.
///
/// **Called once at startup only.** The Android implementation toggles two
/// `activity-alias` entries; doing that mid-session would make the launcher
/// entry change under the user, so the swap is applied on cold start and not
/// re-evaluated while the app is running.
///
/// Platform notes:
///  * **iOS** — uses the documented `setAlternateIconName` API. iOS shows a
///    system alert on every *actual* icon change; that alert cannot be
///    suppressed on a normal (non-jailbroken) build, so the code below only
///    calls the API when the icon genuinely needs to change.
///  * **Android** — the plugin flips the enabled `activity-alias` with
///    `DONT_KILL_APP`, so the running task survives. Homescreen shortcuts
///    pinned to the alias being disabled are still dropped by the launcher;
///    that is inherent to the activity-alias approach.
class SaudiNationalDayAppIcon {
  const SaudiNationalDayAppIcon._();

  /// iOS `CFBundleAlternateIcons` key — see ios/Runner/Info.plist.
  static const String _iosIconName = 'NationalDay';

  /// Android `activity-alias` names — see AndroidManifest.xml.
  ///
  /// The plugin reports the *fully qualified* class name of the enabled
  /// alias, so comparisons below use the package-qualified form while the
  /// value passed back to the plugin is the manifest-relative one.
  static const String _androidPackage = 'momra.balady.android';
  static const String _androidNationalDayAlias = '.MainActivityNationalDay';
  static const String _androidDefaultAlias = '.MainActivityDefault';

  /// Applies (or reverts) the National Day launcher icon.
  ///
  /// Pass [shouldUseNationalDay] to force a state; when omitted the decision
  /// comes from the config last resolved by
  /// `saudiNationalDayResolvedConfigProvider`, so this must be called after
  /// remote config has loaded (see the call site in `entry_point.dart`).
  ///
  /// Safe to call unconditionally — it no-ops when the icon is already in the
  /// desired state, so an ordinary cold start does not trigger the iOS alert.
  static Future<void> apply({bool? shouldUseNationalDay}) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      return;
    }

    try {
      final useNationalDay = shouldUseNationalDay ?? SaudiNationalDayRemoteConfig.isAppIconActiveNow();

      if (!await FlutterDynamicIconPlus.supportsAlternateIcons) {
        return;
      }

      if (Platform.isIOS) {
        await _applyIos(shouldUseNationalDay: useNationalDay);
      } else {
        await _applyAndroid(shouldUseNationalDay: useNationalDay);
      }
    } catch (e, stackTrace) {
      // A launcher-icon failure must never block startup.
      logger.log(
        'SaudiNationalDayAppIcon: failed to apply icon: $e\n$stackTrace',
        logLevel: MapnessLogLevel.warning,
      );
    }
  }

  static Future<void> _applyIos({required bool shouldUseNationalDay}) async {
    final current = await FlutterDynamicIconPlus.alternateIconName;
    final desired = shouldUseNationalDay ? _iosIconName : null;

    // Comparing first is what keeps the iOS system alert from firing on every
    // launch — only a real change triggers it.
    if (current == desired) {
      return;
    }

    await FlutterDynamicIconPlus.setAlternateIconName(iconName: desired);

    logger.log(
      'SaudiNationalDayAppIcon: iOS icon -> ${desired ?? 'default'}',
      logLevel: MapnessLogLevel.info,
    );
  }

  static Future<void> _applyAndroid({required bool shouldUseNationalDay}) async {
    final desired = shouldUseNationalDay ? _androidNationalDayAlias : _androidDefaultAlias;

    // `alternateIconName` returns the fully qualified class name of whichever
    // alias is currently enabled (e.g. `momra.balady.android.MainActivityDefault`),
    // so normalise before comparing against the manifest-relative constant.
    final current = await FlutterDynamicIconPlus.alternateIconName;
    if (current != null && current == '$_androidPackage$desired') {
      return;
    }

    // The plugin disables the previously enabled alias itself, so only the
    // target needs naming here.
    await FlutterDynamicIconPlus.setAlternateIconName(iconName: '$_androidPackage$desired');

    logger.log(
      'SaudiNationalDayAppIcon: Android icon -> $desired',
      logLevel: MapnessLogLevel.info,
    );
  }
}
