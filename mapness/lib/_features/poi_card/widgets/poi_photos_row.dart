import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/image/loading_image/loading_shimmer_image.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/poi_photo_provider.dart';

class PoiPhotosRow extends ConsumerWidget {
  final int objectId;

  const PoiPhotosRow({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosState = ref.watch(poiPhotoProvider(objectId));

    /// show shimmer while loading
    if (photosState.isLoading) {
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
    if (photosState.hasError) {
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
    final photos = photosState.requireValue.items.map((e) => e.url).toList();

    /// special form for small amount of photos
    if (photos.length <= 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: photos
              .map(
                (photo) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LoadingShimmerImage(
                        imageUrl: photo,
                        fit: BoxFit.cover,
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
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: index == 0 ? 12 : 0,
          end: index == photos.length ? 12 : 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            key: ValueKey(photos[index]),
            aspectRatio: 1,
            child: LoadingShimmerImage(
              imageUrl: photos[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      itemCount: photos.length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 6),
    );
  }
}
