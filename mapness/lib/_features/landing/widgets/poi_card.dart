import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/poi_map.dart';

class PoiCard extends ConsumerWidget {
  const PoiCard({
    super.key,
    required this.objectId,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final DgisObjectIdMessage objectId;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Ink.image(
          image: NetworkImage(
            image,
          ),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {
              PoiMapRoute.open(context, objectId.objectId);
            },
            child: SizedBox(
              width: 163,
              height: 200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      title,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .accentM
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(color: Colors.white.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
