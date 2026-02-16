import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';
import 'package:mapness/features/poi_card/widgets/poi_photos_stories.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';

part 'poi_photo_many.dart';
part 'poi_photo_few.dart';
part 'poi_photo_one.dart';

class PoiPhotoRowBuilder extends ConsumerWidget {
  final int objectId;
  final BorderRadius borderRadius;
  final List<String> photosUrls;
  final List<String> previewUrls;
  final List<File>? photoFiles;
  final double padding;
  final double separatorWidth;
  final PoiCardBottomSheetState? state;
  final double? interpolation;

  const PoiPhotoRowBuilder({
    required this.objectId,
    required this.borderRadius,
    required this.photosUrls,
    required this.previewUrls,
    required this.photoFiles,
    required this.padding,
    required this.separatorWidth,
    required this.state,
    required this.interpolation,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (photosUrls.length) {
      case 1:
        return _PoiPhotoOne(
          borderRadius: borderRadius,
          padding: padding,
          itemBuilder: (context) => itemBuilder(context, 0),
          key: key,
        );
      case <= 3:
        return _PoiPhotoFew(
          borderRadius: borderRadius,
          padding: padding,
          itemBuilder: itemBuilder,
          itemCount: photosUrls.length,
          separatorWidth: separatorWidth,
          state: state,
          interpolation: interpolation,
          key: key,
        );
      case > 3:
        return _PoiPhotoMany(
          borderRadius: borderRadius,
          padding: padding,
          itemBuilder: itemBuilder,
          itemCount: photosUrls.length,
          separatorWidth: separatorWidth,
          state: state,
          interpolation: interpolation,
          key: key,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    final url = previewUrls[index];
    return LoadingShimmerImage(
      onImageTap: (name, {isAsset}) {
        Metrics.logEventAdvanced(MetricsConstants.poiKeys.photo,
            group: MetricsConstants.poiTag,
            action: MetricAction.tap.toString(),
            props: {
              'poi_id': objectId,
              'photo_url': photosUrls[index],
            });

        context.router.push(PhotoViewerRoute(photoPaths: photosUrls, currentPhotoIndex: index));
      },
      imageUrl: url,
      file: photoFiles?[index],
      isAssetImg: url.startsWith('package'),
      fit: BoxFit.cover,
    );
  }
}
