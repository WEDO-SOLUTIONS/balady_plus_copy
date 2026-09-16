import 'package:mapness/l10n/generated/app_localizations.dart';

/// "in N min" / "in N hr" — the forward-looking counterpart to
/// `friend_elapsed_time.dart`'s "ago" labels, used for S-10's rolling-window
/// limit copy (AC-03: "told when further requests are permitted"). Same
/// minute/hour bucketing, just inverted.
String friendsOnMapRetryAfterLabel(AppLocalizations l10n, Duration retryAfter) {
  final minutes = (retryAfter.inSeconds / 60).ceil();
  if (minutes < 60) {
    return l10n.friendsOnMapRetryAfterMinutes(minutes < 1 ? 1 : minutes);
  }
  return l10n.friendsOnMapRetryAfterHours((minutes / 60).ceil());
}
