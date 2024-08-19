import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/photo_viewer.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';
import 'package:mapness/widgets/messages/errror_message.dart';
import 'package:shimmer/shimmer.dart';

class PoiPhotoCard extends ConsumerWidget {
  const PoiPhotoCard({required this.objectId, super.key});
  final int objectId;

  List<QuiltedGridTile> get _pattern2 => const [
        QuiltedGridTile(6, 6),
        QuiltedGridTile(6, 6),
      ];
  List<QuiltedGridTile> get _pattern3 => const [
        QuiltedGridTile(6, 6),
        QuiltedGridTile(3, 3),
        QuiltedGridTile(3, 3),
      ];

  List<QuiltedGridTile> get _pattern5 => const [
        QuiltedGridTile(6, 6),
        QuiltedGridTile(4, 4),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(6, 6),
      ];
  List<QuiltedGridTile> get _pattern6 => const [
        QuiltedGridTile(6, 6),
        QuiltedGridTile(3, 3),
        QuiltedGridTile(3, 3),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
      ];

  List<QuiltedGridTile> get _pattern7 => const [
        QuiltedGridTile(6, 6),
        QuiltedGridTile(4, 4),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
        QuiltedGridTile(2, 2),
      ];

  List<QuiltedGridTile> get _pattern14 => [
        ..._pattern7,
        const QuiltedGridTile(6, 6),
        const QuiltedGridTile(2, 2),
        const QuiltedGridTile(4, 4),
        const QuiltedGridTile(2, 2),
        const QuiltedGridTile(2, 2),
        const QuiltedGridTile(2, 2),
        const QuiltedGridTile(2, 2),
      ];

  List<QuiltedGridTile> _calcPattern(int picturesAmount) => switch (picturesAmount) {
        1 || 2 => _pattern2,
        3 => _pattern3,
        4 || 5 => _pattern5,
        6 => _pattern6,
        7 => _pattern7,
        8 || 9 => [
            ..._pattern7,
            ..._pattern2,
          ],
        10 => [
            ..._pattern7,
            ..._pattern3,
          ],
        11 => [
            ..._pattern7,
            const QuiltedGridTile(6, 6),
            const QuiltedGridTile(4, 4),
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(2, 2),
          ],
        12 => [
            ..._pattern7,
            ..._pattern5,
          ],
        13 => [
            ..._pattern7,
            ..._pattern6,
          ],
        14 => _pattern14,
        15 => [
            ..._pattern14,
            const QuiltedGridTile(6, 6),
          ],
        // 16 and more
        _ => [
            ..._pattern14,
            const QuiltedGridTile(3, 3),
            const QuiltedGridTile(3, 3),
          ],
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        crossAxisCount: 6,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        pattern: _calcPattern(photoItems.length),
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: photoItems.length,
        (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(RadiusBorder.xs),
          child: LoadingShimmerImage(
            imageUrl: photoItems[index].url,
            fit: BoxFit.cover,
            onImageTap: (name, {isAsset}) => PhotoViewerRoute.open(ref.read(goRouterProvider), index, photosUrls),
          ),
        ),
      ),
    );
  }
}
