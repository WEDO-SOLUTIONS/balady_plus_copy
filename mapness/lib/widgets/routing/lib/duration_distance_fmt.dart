import 'package:mapness/l10n/generated/app_localizations.dart';

/// @nodoc
extension FormattedDistance on num {
  /// @nodoc
  String formatDistance(AppLocalizations l10n) {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return '${kilometers.toStringAsFixed(1)} ${l10n.km}';
    } else {
      return '${toStringAsFixed(0)} ${l10n.meter}';
    }
  }

  /// @nodoc
  String formatDistanceShort(AppLocalizations l10n) {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return '${kilometers.toStringAsFixed(1)} ${l10n.kilometerShort}';
    } else {
      return '${toStringAsFixed(0)} ${l10n.meterShort}';
    }
  }
}

/// @nodoc
extension FormattedDuration on int {
  /// @nodoc
  String formatDuration(AppLocalizations l10n) {
    final minutes = (this / 60.0).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      var time = '$hours ${l10n.hrs}';
      if (remainingMinutes > 0) {
        time += ' $remainingMinutes ${l10n.min}';
      }

      return time;
    } else if (minutes <= 1) {
      return '1 ${l10n.min}';
    } else {
      return '$remainingMinutes ${l10n.min}';
    }
  }

  /// @nodoc
  String formatDurationShort(AppLocalizations l10n) {
    final minutes = (this / 60.0).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      var time = '$hours ${l10n.hoursShort}';
      if (remainingMinutes > 0) {
        time += ' $remainingMinutes ${l10n.minutesShort}';
      }

      return time;
    } else if (minutes <= 1) {
      return '1 ${l10n.minutesShort}';
    } else {
      return '$remainingMinutes ${l10n.minutesShort}';
    }
  }
}
