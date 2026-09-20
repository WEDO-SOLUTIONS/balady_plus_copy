import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_config.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Swaps the launcher icon for the Saudi National Day window.
///
/// Driven by remote config: the activation window comes from
/// `saudiNationalDayDateRange` in `app_env_config`, so the icon can be moved
/// or switched off from the Firebase Console without an app release.
///
/// **Evaluated once per cold start**, after remote config has resolved (see
/// `_maybeApplyNationalDayIcon` in `entry_point.dart`). Every app open
/// therefore re-checks the date range and hands the correct icon to the
/// platform. The Android implementation toggles two `activity-alias`
/// entries; doing that mid-session would make the launcher entry change under
/// the user, so the decision is not re-evaluated while the app is running.
///
/// Platform notes:
///  * **iOS** — `ios/Runner/LauncherIconChannel.swift` persists the desired
///    icon and applies it with the documented `setAlternateIconName` API
///    once the app has been foreground-active for a short settle window, on
///    every `didBecomeActive`, retrying natively. The timing matters: a
///    request made while the app is not active gets its confirmation alert
///    cancelled, after which LaunchServices (`lsd`) keeps the alert token it
///    minted and answers every later request — from any process, across
///    reinstalls — with "Resource temporarily unavailable" until the device
///    reboots. iOS shows a system alert on every *actual* change; that alert
///    cannot be suppressed on a normal build, so nothing is applied when the
///    icon is already right. The simulator cannot render that alert, so it
///    allows exactly one icon change per boot.
///  * **Android** — goes through our own `LauncherIconChannel`
///    (android/app/src/main/kotlin/momra/balady/android/LauncherIconChannel.kt),
///    which flips the enabled `activity-alias` synchronously with
///    `DONT_KILL_APP`. `flutter_dynamic_icon_plus` is *not* used on either
///    platform any more: on Android it defers the swap to a Service that is
///    never declared in the manifest, so the icon never changed. Homescreen
///    shortcuts pinned to the alias being disabled are still dropped by the
///    launcher; that is inherent to the activity-alias approach.
class SaudiNationalDayAppIcon {
  const SaudiNationalDayAppIcon._();

  /// iOS `CFBundleAlternateIcons` key — see ios/Runner/Info.plist.
  static const String _iosIconName = 'NationalDay';

  /// Android `activity-alias` names — see AndroidManifest.xml. The channel
  /// accepts and reports these manifest-relative forms.
  static const String _androidNationalDayAlias = '.MainActivityNationalDay';
  static const String _androidDefaultAlias = '.MainActivityDefault';

  /// Must match `LauncherIconChannel.channelName` in LauncherIconChannel.swift.
  static const MethodChannel _iosChannel = MethodChannel('momra.balady/app_icon');

  /// Must match `LauncherIconChannel.CHANNEL_NAME` in LauncherIconChannel.kt.
  static const MethodChannel _androidChannel = MethodChannel('momra.balady/launcher_icon');

  /// Applies (or reverts) the National Day launcher icon.
  ///
  /// Pass [shouldUseNationalDay] to force a state; when omitted the decision
  /// comes from the config last resolved by
  /// `saudiNationalDayResolvedConfigProvider`, so this must be called after
  /// remote config has loaded (see the call site in `entry_point.dart`).
  ///
  /// Safe to call unconditionally — both platforms no-op when the icon is
  /// already in the desired state, so an ordinary cold start does not trigger
  /// the iOS alert.
  static Future<void> apply({bool? shouldUseNationalDay}) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      return;
    }

    try {
      final useNationalDay = shouldUseNationalDay ?? SaudiNationalDayRemoteConfig.isAppIconActiveNow();

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

  /// Hands the decision to the native applier.
  ///
  /// Always sent, even when the icon already matches: the native side
  /// persists the desired name so every later activation can enforce it
  /// without Dart's involvement. The actual `setAlternateIconName` call, its
  /// timing and its retries all live in `LauncherIconChannel.swift`.
  static Future<void> _applyIos({required bool shouldUseNationalDay}) async {
    final desired = shouldUseNationalDay ? _iosIconName : null;

    final supported = await _iosChannel.invokeMethod<bool>('supportsAlternateIcons') ?? false;
    if (!supported) {
      logger.log(
        'SaudiNationalDayAppIcon: iOS reports no alternate-icon support; skipping',
        logLevel: MapnessLogLevel.warning,
      );
      return;
    }

    final current = await _iosChannel.invokeMethod<String>('getCurrentIconName');

    await _iosChannel.invokeMethod<void>('setDesiredIconName', <String, String?>{'name': desired});

    final status = current == desired ? 'already applied' : 'native applier will swap';
    logger.log(
      'SaudiNationalDayAppIcon: iOS desired=${desired ?? 'default'} current=${current ?? 'default'} ($status)',
      logLevel: MapnessLogLevel.info,
    );
  }

  static Future<void> _applyAndroid({required bool shouldUseNationalDay}) async {
    final desired = shouldUseNationalDay ? _androidNationalDayAlias : _androidDefaultAlias;

    final current = await _androidChannel.invokeMethod<String>('getEnabledAlias');
    if (current == desired) {
      return;
    }

    // The channel enables the target before disabling the rest, so there is
    // never a moment with no launcher entry.
    await _androidChannel.invokeMethod<void>('setEnabledAlias', <String, String>{'alias': desired});

    logger.log(
      'SaudiNationalDayAppIcon: Android icon ${current ?? '<none>'} -> $desired',
      logLevel: MapnessLogLevel.info,
    );
  }
}
