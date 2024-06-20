import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:mapness/_features/landing/providers/interesting_places.dart';
import 'package:mapness/_features/landing/widgets/ui_kit_template/place_card.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    required this.onItemTap,
    required this.title,
    required this.places,
    super.key,
  });

  final String title;
  final Function(int) onItemTap;
  final List<proto.InterestingPlace> places;

  @override
  Widget build(BuildContext context) => Visibility(
        visible: places.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 16,
                left: 16,
              ),
              child: Text(
                title,
                style: context.textStyle.heading2.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
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

                  return PlaceCard(
                    onTap: () => onItemTap(index),
                    title: place.titleOrFallback(locale: context.l10n),
                    subtitle: '',
                    image: place.preview.image.url,
                  );
                },
              ),
            ),
          ],
        ),
      );
}
