import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';

/// Shown when the meetup pin dropped by `meetup_list_page.dart`'s
/// `_openOnMap` is tapped — the pin otherwise has no way to be
/// selected/inspected/removed. Reuses `EtaShareSheet`, same shell this
/// whole feature already builds every sheet on.
///
/// Called from a `Marker.onTap` closure that can fire long after
/// `MeetupListPage` itself is gone (it pops the whole overlay stack before
/// the pin is even shown) — [context] must be `rootNavigatorKey.currentContext!`,
/// never a context/ref captured from that page, same lesson this feature's
/// other marker `onTap`s (`friend_markers.dart`) and confirm sheets
/// (`friend_card_sheet.dart`) already learned.
void showMeetupMarkerInfoSheet(BuildContext context, Meetup meetup) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => EtaShareSheet(
      title: meetup.label ?? meetup.senderDisplayName,
      confirmBtnTitle: context.l10n.meetupMarkerRemoveCta,
      onConfirmTap: () {
        Navigator.of(context).pop();
        // Clears only the local map pin, not the underlying meetup share —
        // that's dismissed separately from `meetup_list_page.dart`'s own
        // list, a distinct action.
        ProviderScope.containerOf(
          rootNavigatorKey.currentContext!,
          listen: false,
        ).read(selectedMarkerProvider.notifier).clear();
      },
      contentBuilder: (context) => [
        if (meetup.label != null)
          Text(
            context.l10n.meetupMarkerSharedBy(meetup.senderDisplayName),
            style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
          ),
      ],
    ),
  );
}
