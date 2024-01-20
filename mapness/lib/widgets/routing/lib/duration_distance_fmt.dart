import 'package:mapness/l10n/generated/app_localizations.dart';

/// @nodoc
extension FormattedDistance on double {
  /// @nodoc
  String formatDistance(AppLocalizations l10n) {
    if (this >= 1000) {
      final kilometers = this / 1000.0;
      return '${kilometers.toStringAsFixed(1)} ${l10n.km}';
    } else {
      return '$this ${l10n.meter}';
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
      String time = '$hours ${l10n.hrs}';
      if (remainingMinutes > 0) {
        time += ' $remainingMinutes ${l10n.min}';
      }

      return time;
    } else {
      return '$remainingMinutes ${l10n.min}';
    }
  }
}
