import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';

const prefixMapping = {
  'Region': 'منطقة',
  'Governorate': 'محافظة',
  'City': 'مدينة',
  'District area': 'محافظة',
  'District': 'حى',
  'Street': 'شارع',
  'Buildings': 'مبنى',
  'Park': 'بارك',
  'Coffee shop': 'كافيه',
};

class SearchItem extends ConsumerWidget {
  final Language language;
  final GeoPointMessage? myLocation;
  final DirectoryObjectMessage result;

  final void Function() onTap;
  const SearchItem({
    required this.result,
    required this.onTap,
    required this.language,
    this.myLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String subtitle = result.subtitle;
    double? distanceKm;
    List<String> photosUrls = [];

    final objectId = result.id?.objectId ?? 0;
    final photos = ref.watch(poiPhotoProvider(objectId));

    if (photos.hasValue) {
      final photoItems = photos.requireValue.items;
      photosUrls = photoItems.map((e) => e.url).toList();
    }

    if (prefixMapping.containsKey(subtitle)) {
      subtitle = switch (language) {
        Language.english => subtitle,
        Language.arabic => prefixMapping[subtitle]!,
      };
    }

    if (result.markerPosition != null && myLocation != null) {
      distanceKm = CommonFunctions.distance(
        result.markerPosition!.latitude,
        result.markerPosition!.longitude,
        myLocation!.latitude,
        myLocation!.longitude,
      );
    }

    return Material(
      color: context.color.surfaceBaseSecondary,
      shape: smoothBorder(CornerRadius.baseContainer),
      child: SearchTapHandler(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // this part of the code will be included in the uikit component, so it is not included as a separate widget
              if (photosUrls.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    height: 96,
                    child: ScrollConfiguration(
                      behavior: NoGlowingScrollBehavior(),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: photosUrls.length,
                        itemBuilder: (context, i) {
                          final photo = photosUrls[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(
                              CornerRadius.smallContainer,
                            ),
                            child: CustomCachedNetworkImage(
                              photo,
                              imageWidth: 96,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Spacing.horizontalGapBetweenChipContent.widthBox,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.title,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.callout,
                    ),
                  ),
                  if (distanceKm != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Text(
                        (distanceKm * 1000).formatDistance(context.l10n),
                        style: context.textStyle.footNoteBold.copyWith(
                          color: context.color.textAndIconsBaseSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.footNote,
              ),
              const SizedBox(height: 4),
              Text(
                result.makeAddress(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.footNote.copyWith(color: context.color.textAndIconsBaseSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
