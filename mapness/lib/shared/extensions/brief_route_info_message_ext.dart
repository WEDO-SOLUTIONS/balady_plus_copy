import 'package:dgis_map/library.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension BriefRouteInfoMessageExt on BriefRouteInfoMessage {
  String getBriefRouteDescription(
    AppLocalizations l10n,
  ) {
    final duration = Duration(seconds: this.duration.toInt());
    final inMinutes = duration.inMinutes;
    // if less than 1 min return 1 min
    if (inMinutes <= 1) {
      return '1 ${l10n.min}';
    }
    if (inMinutes < 60) {
      return '$inMinutes ${l10n.min}';
    } else {
      final inHours = duration.inHours;
      return '$inHours ${l10n.hrs}';
    }
  }

  String getBriefRouteDistanceDescription(
    AppLocalizations l10n,
  ) {
    final meters = extraInfo.distance / 1000;
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} ${l10n.meter}';
    } else {
      return '${(meters / 1000).toStringAsFixed(0)} ${l10n.km}';
    }
  }
}
