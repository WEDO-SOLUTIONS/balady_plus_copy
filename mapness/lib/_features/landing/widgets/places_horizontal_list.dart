import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:mapness/_features/landing/providers/interesting_places.dart';
import 'package:mapness/_features/landing/widgets/poi_card.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PlacesHorizontalList extends StatelessWidget {
  const PlacesHorizontalList({
    super.key,
    required this.title,
    required this.places,
  });

  final String title;
  final List<proto.InterestingPlace> places;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: places.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Text(
              title,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .accentL
                  .copyWith(
                    color: const Color(0xFF1E2A36),
                  ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: places.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final place = places[index];

                return PoiCard(
                  objectId: DgisObjectIdMessage(
                    objectId: int.tryParse(place.entity.id) ?? 0,
                    entranceId: 0,
                  ),
                  title: place.titleOrFallback(locale: context.l10n),
                  subtitle: '',
                  image: place.preview.image.url,
                );
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
