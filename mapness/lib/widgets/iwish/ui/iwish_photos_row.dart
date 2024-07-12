import 'package:flutter/material.dart';
import 'package:mapness/_features/common/image/loading_image/loading_shimmer_image.dart';
import 'package:mapness/app/routes/photo_viewer.dart';

class IwishPhotosRow extends StatelessWidget {
  const IwishPhotosRow({required this.photos, super.key});
  final List<String> photos;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 96,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final isLtr = Directionality.of(context) == TextDirection.ltr;
            final double leftPadding;
            final double righPadding;

            if (index == 0) {
              leftPadding = isLtr ? 12 : 0;
              righPadding = isLtr ? 0 : 12;
            } else if (index == photos.length - 1) {
              leftPadding = isLtr ? 0 : 12;
              righPadding = isLtr ? 12 : 0;
            } else {
              leftPadding = 0;
              righPadding = 0;
            }

            return Padding(
              padding: EdgeInsets.only(
                left: leftPadding,
                right: righPadding,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  key: ValueKey(photos[index]),
                  aspectRatio: 1,
                  child: LoadingShimmerImage(
                    onImageTap: (name, {isAsset}) => PhotoViewerRoute(currentPhotoIndex: index, photoPaths: photos).push(context),
                    imageUrl: photos[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: photos.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 6),
        ),
      );
}
