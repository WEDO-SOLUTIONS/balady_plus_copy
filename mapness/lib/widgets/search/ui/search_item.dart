import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photos_row.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/search/ui/directory_object_car_estimate.dart';
import 'package:mapness/widgets/search/ui/search_item_quick_actions.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_colors.dart';
import 'package:mapness/widgets/search/ui/working_hours_from_opening_hours_message.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';
import 'package:mapness/widgets/search/ui/working_hours_threshold_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

const prefixMapping = {
  'region': 'منطقة',
  'rovernorate': 'محافظة',
  'city': 'مدينة',
  'district area': 'محافظة',
  'district': 'حى',
  'street': 'شارع',
  'buildings': 'مبنى',
  'park': 'بارك',
  'hotel': 'الفندق',
  'coffee shop': 'كافيه',
  'paid': 'مدفوع',
  'place': 'مكان',
  'gym': 'صالة رياضية',
  'company': 'شركة',
};

class SearchItem extends ConsumerWidget {
  final Language language;
  final GeoPointMessage? myLocation;
  final DirectoryObjectMessage result;
  final Color? contentColor;
  final int index;
  final BssSearchResultList? searchResultList;

  final void Function() onTap;

  const SearchItem({
    required this.result,
    required this.onTap,
    required this.language,
    this.myLocation,
    this.contentColor,
    this.index = 0,
    this.searchResultList,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String subtitle = (result.id?.objectId == 70030077050725730
        ? (context.locale.languageCode == 'en' ? 'Settlement' : 'نطاق')
        : (['تسوية', 'مستوطنة'].contains(result.subtitle) ? 'نطاق' : result.subtitle));
    // String subtitle = result.subtitle;
    List<String> photosUrls = [];
    List<Item> photoItems = [];

    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
        context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    final objectId = result.id?.objectId ?? 0;
    final photos = ref.watch(poiPhotoProvider(objectId));

    if (photos.hasValue) {
      photoItems = photos.requireValue.items;
      photosUrls = photoItems.map((e) => e.url).toList();
    }

    if (prefixMapping.containsKey(subtitle.toLowerCase())) {
      subtitle = switch (language) {
        Language.english => subtitle,
        Language.arabic => prefixMapping[subtitle.toLowerCase()]!,
      };
    }

    final workingHours = result.openingHours?.toWorkingHours();
    final soonThreshold = ref
        .watch(workingHoursSoonThresholdProvider)
        .maybeWhen(
          data: (value) => value,
          orElse: () => kDefaultWorkingHoursSoonThreshold,
        );
    final now = saudiTimeNow();
    final closedStatus = workingHours?.closedStatus(now, context.l10n, soonThreshold: soonThreshold) ?? '';
    final closedStatusColors = workingHours?.colors(now, context.colors, soonThreshold: soonThreshold);
    final leapAddress = ref.read(leapProvider.notifier).getLeapPoi(objectId)?.address(context.l10n);
    final address = leapAddress ?? result.makeAddress();

    String? durationEstimate;
    final markerPosition = result.markerPosition;
    if (markerPosition != null) {
      final finishPoint = RouteSearchPoint(
        coordinates: markerPosition.toGeoPointMessage(),
        dgisObjectId: result.id!,
      );
      final briefRouteInfo = ref.watch(
        briefRouteInfoProvider(
          finishPoint: finishPoint,
          navType: RouteSearchOptionsMessage.car,
        ),
      );
      durationEstimate = briefRouteInfo?.firstOrNull?.getBriefRouteDescription(context.l10n);
    }

    final semanticsLabel = [
      result.title,
      if (subtitle.isNotEmpty) subtitle,
      if (closedStatus.isNotEmpty) closedStatus,
      if (address.isNotEmpty) address,
      if (durationEstimate != null && durationEstimate.isNotEmpty) durationEstimate,
    ].join(', ');

    return VisibilityDetector(
      key: Key('searchResult: ${result.id?.objectId}'),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 50) {
          BssService.instance.sendEvent(
            BssRequest(
              eventType: BSSEventType.view,
              uiElement: BssUIElement(
                name: BssUIElementNames.placeCardMini,
                ownerName: BssUIElementNames.searchResultList,
                position: index + 1,
              ),
              payload: BssPayload(placeItem: result.toBss(index), searchResultList: searchResultList),
            ),
          );
        }
      },
      child: Material(
        color: isDGA ? context.colors.accentSecondarySoft : contentColor ?? context.colors.backgroundSurface1,
        shape: smoothBorder(RadiusBorder.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTapHandler(
              onTap: onTap,
              child: Semantics(
                button: true,
                label: semanticsLabel,
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (photosUrls.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: Spacing.$3x),
                          child: SizedBox(height: 96, child: PoiPhotosRow(objectId: objectId)),
                        ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Spacing.$4x,
                        ).copyWith(top: Spacing.$4x),
                        child: DefaultTextStyle(
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.title,
                                style: context.textStyles.bodyLargeSemiBold.copyWith(
                                  color: context.colors.foregroundDefault,
                                ),
                              ),
                              Spacing.$1x.heightBox,
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textStyles.bodySmallRegular.copyWith(
                                        color: context.colors.foregroundDefault,
                                      ),
                                    ),
                                  ),
                                  if (closedStatus.isNotEmpty)
                                    Text(
                                      ' • ',
                                      style: context.textStyles.bodySmallRegular.copyWith(
                                        color: context.colors.foregroundSoft,
                                      ),
                                    ),
                                  if (closedStatus.isNotEmpty)
                                    Text(
                                      closedStatus,
                                      style: context.textStyles.bodySmallRegular.copyWith(
                                        color: context.colors.foregroundSoft,
                                      ),
                                    ),
                                ],
                              ),
                              Spacing.$1x.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address,
                                          maxLines: 1,
                                          style: context.textStyles.bodySmallRegular.copyWith(
                                            color: context.colors.foregroundSoft,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (markerPosition != null) DirectoryObjectCarEstimate(result),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SearchItemQuickActions(directoryObject: result),
          ],
        ),
      ),
    );
  }
}
