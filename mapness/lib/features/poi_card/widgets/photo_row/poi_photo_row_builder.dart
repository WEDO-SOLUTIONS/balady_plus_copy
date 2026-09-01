import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';
import 'package:mapness/features/poi_card/widgets/poi_photos_stories.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';

part 'poi_photo_few.dart';
part 'poi_photo_many.dart';
part 'poi_photo_one.dart';

class PoiPhotoRowBuilder extends ConsumerStatefulWidget {
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
  ConsumerState<PoiPhotoRowBuilder> createState() => _PoiPhotoRowBuilderState();
}

class _PoiPhotoRowBuilderState extends ConsumerState<PoiPhotoRowBuilder> {
  bool _prefetched = false;

  @override
  void initState() {
    super.initState();
    _prefetchImages();
  }

  @override
  void didUpdateWidget(covariant PoiPhotoRowBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.photosUrls, widget.photosUrls) ||
        !listEquals(oldWidget.previewUrls, widget.previewUrls)) {
      _prefetched = false;
      _prefetchImages();
    }
  }

  void _prefetchImages() {
    if (_prefetched) {
      return;
    }
    _prefetched = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final url in widget.previewUrls) {
        if (url.isEmpty || !_isNetworkUrl(url)) {
          continue;
        }
        CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
      }
    });
  }

  bool _isNetworkUrl(String url) => url.startsWith('http');

  @override
  Widget build(BuildContext context) {
    switch (widget.photosUrls.length) {
      case 1:
        return _PoiPhotoOne(
          borderRadius: widget.borderRadius,
          padding: widget.padding,
          itemBuilder: (context) => itemBuilder(context, 0),
          key: widget.key,
        );
      case <= 3:
        return _PoiPhotoFew(
          borderRadius: widget.borderRadius,
          padding: widget.padding,
          itemBuilder: itemBuilder,
          itemCount: widget.photosUrls.length,
          separatorWidth: widget.separatorWidth,
          state: widget.state,
          interpolation: widget.interpolation,
          key: widget.key,
        );
      case > 3:
        return _PoiPhotoMany(
          borderRadius: widget.borderRadius,
          padding: widget.padding,
          itemBuilder: itemBuilder,
          itemCount: widget.photosUrls.length,
          separatorWidth: widget.separatorWidth,
          state: widget.state,
          interpolation: widget.interpolation,
          key: widget.key,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    final previewUrl = widget.previewUrls[index];
    return LoadingShimmerImage(
      onImageTap: (name, {isAsset}) {
        context.router.push(
          PhotoViewerRoute(photoPaths: widget.photosUrls, previewUrls: widget.previewUrls, currentPhotoIndex: index),
        );
      },
      imageUrl: previewUrl,
      file: widget.photoFiles?[index],
      isAssetImg: previewUrl.startsWith('package'),
      fit: BoxFit.cover,
    );
  }
}
