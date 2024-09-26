import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/photos_header/header_component.dart';

class PoiPhotosHeader extends ConsumerWidget {
  const PoiPhotosHeader({
    required this.objectId,
    required this.aspectRatio,
    super.key,
  });

  final int objectId;
  final ValueNotifier<double> aspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));
    final isPhotosNotEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;

    return HeaderComponent(
      isPhotosNotEmpty: isPhotosNotEmpty,
      objectId: objectId,
      aspectRatio: aspectRatio,
    );
  }
}
