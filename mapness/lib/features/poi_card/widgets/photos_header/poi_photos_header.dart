import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';

class PoiPhotosHeader extends ConsumerWidget {
  final int objectId;

  const PoiPhotosHeader({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));
    final isPhotosEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;
    final isPhotosLoading = photos.isLoading;

    return HeaderComponent(
      photosEmpty: isPhotosEmpty,
      photosAreLoading: isPhotosLoading,
      objectId: objectId,
    );
  }
}
