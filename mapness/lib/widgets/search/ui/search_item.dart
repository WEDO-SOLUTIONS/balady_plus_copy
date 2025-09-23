import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/photo_row/poi_photos_row.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/search/ui/directory_object_car_estimate.dart';
import 'package:mapness/widgets/search/ui/search_item_quick_actions.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';
import 'package:mapness/widgets/search/ui/working_hours_from_opening_hours_message.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';
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
    String subtitle = result.subtitle;
    List<String> photosUrls = [];
    List<Item> photoItems = [];

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

    final closedStatus = result.openingHours?.toWorkingHours().closedStatus(DateTime.now(), context.l10n) ?? '';

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
                  payload: BssPayload(
                    placeItem: result.toBss(index),
                    searchResultList: searchResultList,
                  ),
                ),
              );
        }
      },
      child: Material(
        color: contentColor ?? context.colors.backgroundSurface1,
        shape: smoothBorder(RadiusBorder.xl),
        child: SearchTapHandler(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (photosUrls.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x),
                  child: SizedBox(height: 96, child: PoiPhotosRow(objectId: objectId)),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.$4x).copyWith(top: Spacing.$4x),
                child: DefaultTextStyle(
                  style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                      ),
                      Spacing.$1x.heightBox,
                      Text.rich(
                        TextSpan(
                          text: subtitle,
                          children: [
                            if (closedStatus.isNotEmpty)
                              TextSpan(
                                text: ' • ',
                                style:
                                    context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                              ),
                            if (closedStatus.isNotEmpty)
                              TextSpan(
                                text: closedStatus,
                                style: context.textStyles.bodySmallRegular
                                    .copyWith(color: context.colors.errorOnContainer),
                              ),
                          ],
                        ),
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
                      ),
                      Spacing.$1x.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              result.makeAddress(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DirectoryObjectCarEstimate(result),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SearchItemQuickActions(directoryObject: result),
            ],
          ),
        ),
      ),
    );
  }
}
