import 'package:dgis_map/library.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

String formatRouteDurationDescription(
  double durationSeconds,
  AppLocalizations l10n,
) {
  final duration = Duration(seconds: durationSeconds.toInt());
  final inMinutes = duration.inMinutes;
  if (inMinutes <= 1) {
    return '${l10n.number(1)} ${l10n.min}';
  }
  if (inMinutes < 60) {
    return '${l10n.number(inMinutes)} ${l10n.min}';
  } else {
    final inHours = duration.inHours;
    return '${l10n.number(inHours)} ${l10n.hrs}';
  }
}

extension BriefRouteInfoMessageExt on BriefRouteInfoMessage {
  String getBriefRouteDescription(
    AppLocalizations l10n,
  ) => formatRouteDurationDescription(duration, l10n);

  String getBriefRouteDistanceDescription(
    AppLocalizations l10n,
  ) {
    final meters = extraInfo.distance / 1000;
    if (meters < 1000) {
      return '${l10n.digits(meters.toStringAsFixed(0))} ${l10n.meter}';
    } else {
      return '${l10n.digits((meters / 1000).toStringAsFixed(0))} ${l10n.km}';
    }
  }
}
