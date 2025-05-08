import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';
import 'package:shimmer/shimmer.dart';

class PoiPhotosRow extends ConsumerWidget {
  const PoiPhotosRow({
    required this.objectId,
    super.key,
  });

  final int objectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingObject = objectId == parkingObjectId;
    final parkingPhotos = ref.read(parkingManageProvider).value?.imagesPaths;
    final photoFiles = parkingObject ? parkingPhotos?.map((e) => File(e)).toList() ?? [] : null;
    final photosState = ref.watch(poiPhotoProvider(objectId));

    /// show shimmer while loading
    if (photosState.isLoading && !parkingObject) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
        ),
      );
    }

    /// reload button on error
    if (photosState.hasError && !parkingObject) {
      return InkWell(
        onTap: () => ref.invalidate(poiPhotoProvider(objectId)),
        radius: 12,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.pink[50],
          ),
          child: const Center(
            child: Icon(Icons.refresh),
          ),
        ),
      );
    }

    /// extract photo urls
    final photos = parkingObject ? parkingPhotos ?? [] : photosState.requireValue.items.map((e) => e.url).toList();
    final previewUrls = parkingObject
        ? parkingPhotos ?? []
        : photosState.requireValue.items.map((e) => e.previewUrls?.mediumByWidth ?? e.url).toList();

    /// special form for small amount of photos
    if (photos.length <= 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: photos
              .mapIndexed(
                (index, photo) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 1,
                        key: ValueKey(photo),
                        child: LoadingShimmerImage(
                          onImageTap: (name, {isAsset}) {
                            Metrics.logEventAdvanced(MetricsConstants.poiKeys.photo,
                                group: MetricsConstants.poiTag,
                                action: MetricAction.tap.toString(),
                                props: {
                                  'poi_id': objectId,
                                  'photo_url': photo,
                                });

                            context.router.push(PhotoViewerRoute(photoPaths: photos, currentPhotoIndex: index));
                          },
                          imageUrl: previewUrls[index],
                          file: photoFiles?[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    /// scrollable list of photos
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        final loadingShimmerImage = LoadingShimmerImage(
          onImageTap: (name, {isAsset}) =>
              context.router.push(PhotoViewerRoute(photoPaths: photos, currentPhotoIndex: index)),
          imageUrl: previewUrls[index],
          file: photoFiles?[index],
          fit: BoxFit.cover,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              key: ValueKey(photos[index]),
              aspectRatio: 1,
              child: loadingShimmerImage,
            ),
          ),
        );
      },
      itemCount: min(photos.length, 10),
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 6),
    );
  }
}
