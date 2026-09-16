import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';

/// S-17's "pick a place" step — exactly 2 options. POI search
/// (`MapSearchSheet`) was investigated and dropped: it has no pop-a-result
/// contract (selecting a result hard-navigates to `PoiCardWidgetRoute`
/// itself), unlike `RoutingMapSelectPage`, which does. See
/// `friends_on_map/AGENTS.md` for the full reasoning.
typedef MeetupPlacePick = ({double latitude, double longitude, String? label});

enum _MeetupPlaceChoice { currentLocation, chooseOnMap }

/// Shows the choice sheet, then (outside the sheet, using [context] — which
/// must still be mounted after the sheet closes, e.g. a root-navigator
/// context) resolves the actual coordinates. Returns `null` if the user
/// backed out at any step.
Future<MeetupPlacePick?> showMeetupPlacePickerSheet(BuildContext context) async {
  final choice = await showModalBottomSheet<_MeetupPlaceChoice>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => const Consumer(builder: _buildSheetContent),
  );
  if (choice == null || !context.mounted) {
    return null;
  }

  switch (choice) {
    case _MeetupPlaceChoice.currentLocation:
      final position = ProviderScope.containerOf(context, listen: false).read(locationProvider);
      if (position == null) {
        return null;
      }
      return (latitude: position.latitude, longitude: position.longitude, label: null);
    case _MeetupPlaceChoice.chooseOnMap:
      final result = await context.router.push(const RoutingMapSelectRoute());
      if (result is! RoutePointCoordinates) {
        return null;
      }
      return (latitude: result.coords.latitude, longitude: result.coords.longitude, label: result.address);
  }
}

Widget _buildSheetContent(BuildContext context, WidgetRef ref, Widget? child) {
  final hasPosition = ref.watch(locationProvider) != null;

  return EtaShareSheet(
    title: context.l10n.meetupPlacePickerTitle,
    contentBuilder: (context) => [
      ContentRow(
        onTap: hasPosition ? () => Navigator.of(context).pop(_MeetupPlaceChoice.currentLocation) : null,
        leading: Icon(
          GeneralIcons.location,
          color: hasPosition ? context.colors.foregroundDefault : context.colors.foregroundMuted,
        ),
        text: ContentRowTextOptions(
          title: context.l10n.meetupPlacePickerCurrentLocationCta,
          titleOptions: hasPosition ? null : ContentRowTextOption(baseColor: context.colors.foregroundMuted),
        ),
      ),
      ContentRow(
        onTap: () => Navigator.of(context).pop(_MeetupPlaceChoice.chooseOnMap),
        leading: Icon(GeneralIcons.map, color: context.colors.foregroundDefault),
        text: ContentRowTextOptions(title: context.l10n.meetupPlacePickerChooseOnMapCta),
      ),
    ],
  );
}
