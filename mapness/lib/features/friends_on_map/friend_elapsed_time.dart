import 'package:mapness/l10n/generated/app_localizations.dart';

/// "Just now" / "N min ago" / "N hr ago" / "N days ago" — shared by the
/// friend card (R-53) and the map marker caption (R-49). Mirrors
/// `features/tifo/leaderboard_sheet.dart`'s private `_relativeTime` shape.
String friendElapsedTimeLabel(AppLocalizations l10n, DateTime at) {
  final diff = DateTime.now().difference(at);
  if (diff.inMinutes < 1) {
    return l10n.friendCardTimeJustNow;
  }
  if (diff.inHours < 1) {
    return l10n.friendCardTimeMinutesAgo(diff.inMinutes);
  }
  if (diff.inDays < 1) {
    return l10n.friendCardTimeHoursAgo(diff.inHours);
  }
  return l10n.friendCardTimeDaysAgo(diff.inDays);
}

/// R-50 (Appendix B): a friend's position is fresh for 15 minutes since it
/// was received, after which it's shown stale — but never removed.
bool friendPositionIsStale(DateTime at) => DateTime.now().difference(at) >= const Duration(minutes: 15);
