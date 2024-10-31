import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';

part 'widgets/search_history_gallery.dart';

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

    return Material(
      color: context.colorsV2.backgroundSurface4,
      shape: smoothBorder(RadiusBorder.xl),
      child: SearchTapHandler(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photosUrls.isNotEmpty) _PhotosGallery(photosUrls: photosUrls, photoItems: photoItems),
            ContentRowV2(
              crossAxisAlignment: CrossAxisAlignment.start,
              text: ContentRowTextOptions(
                title: result.title,
                titleOptions: const ContentRowTextOption(isBold: true),
                subtitle: subtitle,
                subtitleExtra: result.makeAddress(),
                subtitleExtraOptions: const ContentRowTextOption(
                  maxLines: 3,
                ),
              ),
              trailing: ContentRowCustomTrailingOptions(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
                  child: FutureBuilder<double?>(
                    future: _calculateDistance(markerPoint: result.markerPosition, myLocationPoint: myLocation),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      final distanceKm = snapshot.data;
                      if (distanceKm == null || !context.mounted) {
                        return const SizedBox.shrink();
                      }
                      return ContentRowTrailingText(
                        options: ContentRowTextTrailingOptions(text: (distanceKm * 1000).formatDistance(context.l10n)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<double?> _calculateDistance({GeoPointWithElevationMessage? markerPoint, GeoPointMessage? myLocationPoint}) {
    if (markerPoint == null || myLocationPoint == null) {
      // Return null by default
      return Future.value();
    }

    return Future.delayed(
      Duration.zero,
      () => CommonFunctions.distance(
        result.markerPosition!.latitude,
        result.markerPosition!.longitude,
        myLocation!.latitude,
        myLocation!.longitude,
      ),
    );
  }
}

class _PhotosGallery extends StatelessWidget {
  static const heightOfGallery = 96;
  final List<String> photosUrls;
  final List<Item> photoItems;

  const _PhotosGallery({
    required this.photosUrls,
    required this.photoItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, top: Spacing.$3x),
        child: SizedBox(
          height: heightOfGallery.toDouble(),
          child: ScrollConfiguration(
            behavior: NoGlowingScrollBehavior(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photosUrls.length,
              itemBuilder: (context, i) {
                final photo = photoItems[i].previewUrls?.smallByWidth ?? photosUrls[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(
                    RadiusBorder.l,
                  ),
                  child: Image.network(
                    photo,
                    fit: BoxFit.cover,
                    height: heightOfGallery.toDouble(),
                    width: heightOfGallery.toDouble(),
                    cacheHeight: heightOfGallery,
                    cacheWidth: heightOfGallery,
                  ),
                );
              },
              separatorBuilder: (context, index) => Spacing.$1x.widthBox,
            ),
          ),
        ),
      );
}
