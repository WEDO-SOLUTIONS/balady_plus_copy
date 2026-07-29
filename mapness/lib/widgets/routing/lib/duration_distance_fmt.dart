import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

/// @nodoc
extension FormattedDistance on num {
  /// @nodoc
  String formatDistance(AppLocalizations l10n) {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return '${l10n.digits(kilometers.toStringAsFixed(1))} ${l10n.km}';
    } else {
      return '${l10n.digits(toStringAsFixed(0))} ${l10n.meter}';
    }
  }

  /// @nodoc
  String formatDistanceShort(AppLocalizations l10n) {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return '${l10n.digits(kilometers.toStringAsFixed(1))} ${l10n.kilometerShort}';
    } else {
      return '${l10n.digits(toStringAsFixed(0))} ${l10n.meterShort}';
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
      var time = '${l10n.number(hours)} ${l10n.hrs}';
      if (remainingMinutes > 0) {
        time += ' ${l10n.number(remainingMinutes)} ${l10n.min}';
      }

      return time;
    } else if (minutes <= 1) {
      return '${l10n.number(1)} ${l10n.min}';
    } else {
      return '${l10n.number(remainingMinutes)} ${l10n.min}';
    }
  }

  /// @nodoc
  String formatDurationShort(AppLocalizations l10n) {
    final minutes = (this / 60.0).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      var time = '${l10n.number(hours)} ${l10n.hoursShort}';
      if (remainingMinutes > 0) {
        time += ' ${l10n.number(remainingMinutes)} ${l10n.minutesShort}';
      }

      return time;
    } else if (minutes <= 1) {
      return '${l10n.number(1)} ${l10n.minutesShort}';
    } else {
      return '${l10n.number(remainingMinutes)} ${l10n.minutesShort}';
    }
  }
}
