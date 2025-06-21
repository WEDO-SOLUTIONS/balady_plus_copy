import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:balady_uikit/balady_uikit.dart' hide PoiContentWorkTime, PoiContentWorkTimeDay;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/tmp/content_row_expandable.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiEntrancesMetro extends StatelessWidget {
  final List<DirectoryObjectMessage> entrancesDirectoryObject;

  const PoiEntrancesMetro({
    required this.entrancesDirectoryObject,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ContentWrapper(
        color: context.color.surfaceBasePrimary,
        children: [
          ContentRowExpandableTmp(
            expandIconColor: context.colorsV3.foregroundMuted,
            count: entrancesDirectoryObject.length,
            onTitleTap: () {
              context.router.replaceOrPush(
                route: PoiCardWidgetRoute(objectId: entrancesDirectoryObject.first.id),
                toCompareRoutes: [
                  ShareMyLocationRoute.page,
                  PoiCardWidgetRoute.page,
                  RoutingRoutesRoute.page,
                  HajjPoiCardRoute.page
                ],
              );
            },
            text: ContentRowTextOptions(
              title: '${context.l10n.exit} 1',
              subtitle: entrancesDirectoryObject.firstOrNull?.makeAddress(),
            ),
            leading: GeneralIcons.doorEntrance.icon(color: context.colorsV3.accentDefault),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entrancesDirectoryObject
                  .skip(1)
                  .mapIndexed(
                    (index, data) => ContentRowV2(
                      onTap: () {
                        context.router.replaceOrPush(
                          route: PoiCardWidgetRoute(objectId: data.id),
                          toCompareRoutes: [
                            ShareMyLocationRoute.page,
                            PoiCardWidgetRoute.page,
                            RoutingRoutesRoute.page,
                            HajjPoiCardRoute.page
                          ],
                        );
                      },
                      text: ContentRowTextOptions(
                        title: '${context.l10n.exit} ${index + 2}',
                        subtitle: data.makeAddress(),
                      ),
                      leading: GeneralIcons.doorEntrance.icon(color: context.colorsV3.accentDefault),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
}
