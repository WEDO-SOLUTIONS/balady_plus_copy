import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/photo_viewer.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';
import 'package:mapness/widgets/messages/errror_message.dart';
import 'package:shimmer/shimmer.dart';

class PoiPhotoCard extends ConsumerWidget {
  const PoiPhotoCard({required this.model, super.key});
  final PoiModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectId = model.directoryObjectMessage?.id?.objectId ?? 0;

    final photos = ref.watch(poiPhotoProvider(objectId));

    if (photos.hasError) {
      return ErrorMessage(
        onRetry: () => ref.invalidate(poiPhotoProvider(objectId)),
      );
    }

    if (photos.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
        ),
      );
    }

    final photoItems = photos.requireValue.items;
    final photosUrls = photoItems.map((e) => e.url).toList();

    return GridView.custom(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.only(bottom: 64),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        pattern: const [
          QuiltedGridTile(3, 3),
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          //
          QuiltedGridTile(3, 3),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: photoItems.length,
        (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(RadiusBorder.xs),
          child: LoadingShimmerImage(
              imageUrl: photoItems[index].url,
              fit: BoxFit.cover,
              onImageTap: (name, {isAsset}) => PhotoViewerRoute.open(ref.read(goRouterProvider), index, photosUrls)),
        ),
      ),
    );
  }
}
