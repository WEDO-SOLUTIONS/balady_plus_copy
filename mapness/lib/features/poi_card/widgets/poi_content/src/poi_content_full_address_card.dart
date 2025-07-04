import 'package:balady_uikit/balady_uikit.dart' hide PoiContentFullAddress;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_address_action_button.dart';
import 'package:urbi_utils/urbi_utils.dart';

class PoiContentFullAddressCard extends StatelessWidget {
  final PoiContentFullAddressModel data;
  const PoiContentFullAddressCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final showButtonsRow = data.floors != null || (data.entrances != null && data.entrances!.count > 0);
    final type = data.types?.firstOrNull?.type;
    final hasMetro = type == ObjectTypeMessage.stationMetro ||
        type == ObjectTypeMessage.station ||
        type == ObjectTypeMessage.stationPlatform ||
        type == ObjectTypeMessage.stationEntrance;

    return ContentWrapper(
      color: context.color.surfaceBasePrimary,
      children: [
        ContentRowV2(
          text: ContentRowTextOptions(
            title: data.title,
            titleOptions: const ContentRowTextOption(isBold: true),
            subtitle: data.fullAddress,
            subtitleOptions: const ContentRowTextOption(
              maxLines: 99,
            ),
          ),
          trailing: data.networkLogoUrl != null
              ? ContentRowCustomTrailingOptions(
                  builder: (context) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: Spacing.$4x, top: Spacing.$4x),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.network(
                        data.networkLogoUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : null,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        if (showButtonsRow && !hasMetro)
          Padding(
            padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
            child: Row(
              children: <Widget>[
                if (data.floors != null)
                  ActionButton(
                    title: data.floors!.title,
                    count: data.floors!.floors,
                  ),
                if (data.entrances != null && data.entrances!.count > 0)
                  ActionButton(
                    title: data.entrances!.title,
                    count: data.entrances!.count,
                    onTap: data.entrances?.onTap,
                  ),
              ].insertBetween(Spacing.$2x.widthBox).toList(),
            ),
          ),
      ],
    );
  }
}