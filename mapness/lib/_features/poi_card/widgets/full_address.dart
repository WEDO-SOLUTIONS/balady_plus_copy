import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class FullAddress extends ConsumerWidget {
  const FullAddress({
    required this.onEntranceTap,
    required this.title,
    required this.subtitle,
    required this.exits,
    required this.data,
    super.key,
  });

  final DirectoryObjectMessage data;
  final String title;
  final String subtitle;
  final int? exits;
  final Function() onEntranceTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: RouteSearchPoint(
          coordinates: data.markerPosition?.toGeoPointMessage() ??
              GeoPointMessage(
                latitude: 0,
                longitude: 0,
              ),
          dgisObjectId: data.id!,
        ),
        navType: RouteSearchOptionsMessage.car,
      ),
    );
    return CardContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: context.textStyle.callout.copyWith(color: context.color.textAndIconsBasePrimary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                briefInfo?.first.getBriefRouteDistanceDescription(context.l10n) ?? '',
                style: context.textStyle.footNoteBold.copyWith(
                  color: context.color.textAndIconsBaseSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: context.textStyle.footNote.copyWith(color: context.color.textAndIconsBasePrimary),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          if (exits != null && exits != 0)
            Row(
              children: [
                const SizedBox(height: 8),
                Material(
                  color: context.staticColor.surfaceStatusContrastAccent,
                borderRadius: borderRadius,
                child: InkWell(
                  onTap: onEntranceTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: borderRadius,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.exits,
                          style: context.textStyle.footNoteBold.copyWith(
                            color: context.color.textAndIconsStatusAccent,
                          ),
                        ),
                        Text(
                          ' $exits',
                          style: context.textStyle.footNoteBold.copyWith(
                            color: context.color.textAndIconsBaseTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ],
            ),
        ],
      ),
    );
  }
}
