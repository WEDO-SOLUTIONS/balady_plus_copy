import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class DirectoryObjectCarEstimate extends ConsumerWidget {
  final DirectoryObjectMessage directoryObjectMessage;

  const DirectoryObjectCarEstimate(this.directoryObjectMessage, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishPoint = RouteSearchPoint(
      coordinates: directoryObjectMessage.markerPosition!.toGeoPointMessage(),
      dgisObjectId: directoryObjectMessage.id!,
    );

    final briefRouteInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final durationEstimate = briefRouteInfo?.firstOrNull?.getBriefRouteDescription(context.l10n) ?? '';

    return Text.rich(
      TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(color: context.colors.neutralDefault),
        children: [
          WidgetSpan(
            child: ExcludeSemantics(
              child: Icon(General16Icons.car, size: 16, color: context.colors.foregroundSoft),
            ),
            baseline: TextBaseline.ideographic,
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(text: ' $durationEstimate'),
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.start,
    );
  }
}
