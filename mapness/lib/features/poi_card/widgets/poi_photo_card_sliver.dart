import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_feedback.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_feedback_banner.dart';
import 'package:mapness/features/poi_card/widgets/poi_photo_button.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';
import 'package:mapness/widgets/messages/errror_message.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PoiPhotoCardSliver extends ConsumerWidget {
  const PoiPhotoCardSliver({required this.objectId, super.key});
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
      return SliverToBoxAdapter(
        child: ErrorMessage(
          onRetry: () => ref.invalidate(poiPhotoProvider(objectId)),
        ),
      );
    }

    late final Widget sliverContent;

    if (photos.isLoading) {
      sliverContent = SliverToBoxAdapter(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
          ),
        ),
      );
    } else {
      final photoItems = photos.requireValue.items;
      final photosUrls = photoItems.map((e) => e.url).toList();

      sliverContent = SliverPadding(
        padding: const EdgeInsets.only(bottom: 64),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: photoItems.length,
            (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xs),
              child: LoadingShimmerImage(
                imageUrl: photoItems[index].previewUrls?.mediumByWidth ?? photosUrls[index],
                fit: BoxFit.cover,
                onImageTap: (name, {isAsset}) =>
                    context.router.push(PhotoViewerRoute(photoPaths: photosUrls, currentPhotoIndex: index)),
              ),
            ),
          ),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 6,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            pattern: _calcPattern(photoItems.length),
          ),
        ),
      );
    }

    return SliverAlignBox(
      alignment: AlignmentDirectional.bottomEnd,
      padding: const EdgeInsetsDirectional.only(bottom: Spacing.$4x, end: Spacing.$2x),
      sliver: MultiSliver(
        children: [
          if (photos.hasValue && photos.requireValue.items.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.$4x),
                child: PoiContentFeedbackCard(
                  data: PoiContentFeedbackType.addPhoto,
                  onTap: () => context.router.push(
                    QuickFeedbackPhotoRoute(
                      params: FeedbackObjectIdParams(objectId),
                    ),
                  ),
                ),
              ),
            ),
          sliverContent,
        ],
      ),
      child: PoiPhotoButton(objectId: objectId, photosItems: photos.requireValue.items),
    );
  }
}
