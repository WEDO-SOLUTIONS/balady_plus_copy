import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_place_picker_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_send_confirm_sheet.dart';

/// S-17: place-pick step, then the send-confirm step. Shared by both entry
/// points (a friend's own card — one recipient, no picker; the friend list
/// — via `MeetupFriendPickerPage` first).
Future<void> startMeetupShareFlow(BuildContext context, List<Friend> recipients) async {
  final pick = await showMeetupPlacePickerSheet(context);
  if (pick == null || !context.mounted) {
    return;
  }
  showMeetupSendConfirmSheet(
    context,
    recipients: recipients,
    latitude: pick.latitude,
    longitude: pick.longitude,
    label: pick.label,
  );
}
