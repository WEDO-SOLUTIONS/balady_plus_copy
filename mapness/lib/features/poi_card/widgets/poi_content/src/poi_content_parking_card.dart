import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';

class PoiContentParkingCard extends StatelessWidget {
  final PoiContentParkingModel? data;
  const PoiContentParkingCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const SizedBox.shrink();
    }
    final icon = data!.isPaid ? PlacesIcons.parkingPaid : TransportIcons.parkingEnable;
    return ContentWrapper(
      color: context.color.surfaceBasePrimary,
      children: [
        ContentRow(
          leading: icon.icon(color: context.colors.accentDefault),
          text: ContentRowTextOptions(
            title: data!.title,
            subtitle: data!.subtitle,
            subtitleOptions: ContentRowTextOption(
              baseColor: context.colors.foregroundSoft,
            ),
          ),
        ),
      ],
    );
  }
}
