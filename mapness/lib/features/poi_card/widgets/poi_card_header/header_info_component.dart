import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class HeaderInfoComponent extends ConsumerWidget {
  final DirectoryObjectMessage data;
  const HeaderInfoComponent({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishPoint = RouteSearchPoint(
      coordinates: data.markerPosition?.toGeoPointMessage() ??
          GeoPointMessage(
            latitude: 0,
            longitude: 0,
          ),
      dgisObjectId: data.id!,
    );
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final worktime = data.getOpeningHours(context.l10n)?.title;

    final fullAddress = data.getFullAddress(briefInfo, context.l10n);
    return _HeaderInfoWidget(
      fullAddress: fullAddress,
      worktime: worktime,
    );
  }
}

class _HeaderInfoWidget extends BottomSheetStateComponent<PoiCardBottomSheetState> {
  final PoiContentFullAddress fullAddress;
  final String? worktime;
  const _HeaderInfoWidget({
    required this.fullAddress,
    required this.worktime,
  }) : super(
          defaultState: PoiCardBottomSheetState.halfOpen,
        );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    if (state.index > PoiCardBottomSheetState.halfOpen.index) {
      return const SizedBox.shrink();
    }

    var scale = interpolation;

    if (state == PoiCardBottomSheetState.halfOpen) {
      scale = 1 - interpolation;
    }

    return ContentTransition(
      interpolation: scale,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Spacing.$3x,
          bottom: Spacing.$3x,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentRow(
              options: ContentRowOptions(
                subtitle: fullAddress.address,
                subtitleStyle: context.textStyleV3.bodyLargeRegular,
                padding: const EdgeInsets.only(bottom: Spacing.$0_5x),
                subtitleMaxlines: 1,
                actionWidget: ContentRowActionOptions(
                  actionText: fullAddress.distance,
                ),
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            if (worktime != null)
              Text(
                worktime!,
                style: context.textStyle.footNoteBold.copyWith(
                  color: context.colorsV3.accentDefault,
                ),
              )
            else
              Spacing.$5x.heightBox,
          ],
        ),
      ),
    );
  }
}
