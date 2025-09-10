import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/widgets/media_catalog_item.dart';

class MediaCatalogList extends StatelessWidget {
  const MediaCatalogList({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 136,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: RadiusBorder.l),
          children: [
            MediaCatalogItem(
              title: 'Hoda and Han',
              subTitle: 'Panorama FM',
              image: Assets.images.audioPlaceholders.hoda.provider(),
              radioImage: Assets.images.audioPlaceholders.panorama.provider(),
            ),
            MediaCatalogItem(
              title: 'Sweet talk',
              subTitle: 'MBC FM',
              image: Assets.images.audioPlaceholders.sweet.provider(),
              radioImage: Assets.images.audioPlaceholders.mbcFm.provider(),
            ),
            MediaCatalogItem(
              title: 'Non-Stop Hits',
              subTitle: 'MBC Loud',
              image: Assets.images.audioPlaceholders.non.provider(),
              radioImage: Assets.images.audioPlaceholders.mbcLoud.provider(),
            ),
            MediaCatalogItem(
              title: 'Noon Program',
              subTitle: 'AL Arabiya FM',
              image: Assets.images.audioPlaceholders.arabiya.provider(),
              radioImage: Assets.images.audioPlaceholders.arabiyaFm.provider(),
            ),
          ],
        ),
      );
}
