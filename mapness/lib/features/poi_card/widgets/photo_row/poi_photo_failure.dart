import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';

class PoiPhotoRowFailure extends ConsumerWidget {
  final int objectId;
  final BorderRadius borderRadius;

  const PoiPhotoRowFailure({
    required this.objectId,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
        onTap: () => ref.invalidate(poiPhotoProvider(objectId)),
        radius: 12,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: context.colorsV3.errorMuted,
          ),
          child: Center(
            child: GeneralIcons.reload.icon(
              color: context.colorsV3.errorOnError,
            ),
          ),
        ),
      );
}
