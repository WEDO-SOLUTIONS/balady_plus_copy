// ignore_for_file: deprecated_member_use

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/poi_content_ext.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:sheetify/sheetify.dart';

class HeaderInfoComponent extends ConsumerWidget {
  final DirectoryObjectMessage data;

  const HeaderInfoComponent({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishPoint = RouteSearchPoint(
      coordinates: data.markerPosition?.toGeoPointMessage() ?? GeoPointMessage(latitude: 0, longitude: 0),
      dgisObjectId: data.id!,
    );

    // Get user's current location to use as startPoint for route calculation
    final userLocation = ref.watch(locationProvider);
    RouteSearchPoint? startPoint;
    if (userLocation != null) {
      startPoint = RouteSearchPoint(
        coordinates: GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude),
        dgisObjectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
      );
    }

    final briefInfo = ref.watch(
      briefRouteInfoProvider(finishPoint: finishPoint, navType: RouteSearchOptionsMessage.car, startPoint: startPoint),
    );

    final workTime = data.getOpeningHoursHeader(context);

    final objectId = data.id?.objectId;
    final leapAddress = objectId != null
        ? ref.read(leapProvider.notifier).getLeapPoi(objectId)?.address(context.l10n)
        : null;

    final fullAddress = data.getFullAddress(briefInfo, context.l10n, addressOverride: leapAddress);
    return _HeaderInfoWidget(fullAddress: fullAddress, workTime: workTime);
  }
}

class _HeaderInfoWidget extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final PoiContentFullAddressModel fullAddress;
  final ContentWorkTimeModel? workTime;

  const _HeaderInfoWidget({required this.fullAddress, required this.workTime})
    : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    if (state.index > PoiCardBottomSheetState.halfOpen.index) {
      return const SizedBox.shrink();
    }

    var scale = interpolation;

    if (state == PoiCardBottomSheetState.halfOpen) {
      scale = 1 - interpolation;
    }

    ///TODO: (ve) do not remove
    // final showBadges = worktime?.poiContentWorkTime != null || hasOffers;

    return ContentTransition(
      interpolation: scale,
      child: Padding(
        padding: const EdgeInsets.only(top: Spacing.$3x, bottom: Spacing.$3x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentRow(
              options: ContentRowOptions(
                subtitle: fullAddress.fullAddress,
                subtitleStyle: context.textStyles.bodyLargeRegular,
                padding: const EdgeInsets.only(bottom: Spacing.$0_5x),
                subtitleMaxlines: 1,
                // This file will be deleted in the nearest future
                // actionWidget: ContentRowActionOptions(
                //   actionText: fullAddress.distance,
                // ),
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            if (workTime?.poiContentWorkTime != null)
              Text(
                workTime!.poiContentWorkTime.workHours,
                style: context.textStyle.footNoteBold.copyWith(
                  // This file will be deleted in the nearest future
                  // color: worktime!.color,
                ),
              ),

            ///TODO: (ve) do not remove
            // if (showBadges)
            //   Padding(
            //     padding: const EdgeInsets.only(top: Spacing.$0_5x),
            //     child: Row(
            //       children: <Widget>[
            //         if (hasOffers) const OffersBadge()
            //       ].insertBetween(Spacing.$1x.widthBox).toList(),
            //     ),
            // else
            //   Spacing.$5x.heightBox,
          ],
        ),
      ),
    );
  }
}
