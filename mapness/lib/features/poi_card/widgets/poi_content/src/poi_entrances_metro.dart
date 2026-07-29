import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/tmp/content_row_expandable.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

/// A widget that displays an expandable list of metro station entrances.
///
/// This widget is used to render a collapsible section showing multiple entrances
/// for a metro station, where the first entrance is shown as the main title,
/// and the rest are listed inside an expandable content area.
///
/// When the user taps on the title or an entrance item, it navigates
/// to a detailed POI (Point of Interest) card page for that entrance.
///
/// The first entrance is shown as "Exit 1", and the rest are numbered
/// incrementally ("Exit 2", "Exit 3", etc.).
///
/// The widget asserts that the [entrancesDirectoryObject] list is not empty,
/// as at least one entrance is required for proper rendering.
///
/// Example usage:
/// ```dart
/// PoiEntrancesMetro(
///   entrancesDirectoryObject: listOfEntrances,
/// );
/// ```
class PoiEntrancesMetro extends StatelessWidget {
  final List<DirectoryObjectMessage> entrancesDirectoryObject;

  const PoiEntrancesMetro({required this.entrancesDirectoryObject, super.key});

  @override
  Widget build(BuildContext context) {
    final toCompareRoutes = [
      ShareMyLocationRoute.page,
      PoiCardWidgetRoute.page,
      RoutingRoutesRoute.page,
      HajjPoiCardRoute.page,
    ];

    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      children: [
        ContentRowExpandableTmp(
          expandIconColor: context.colors.foregroundMuted,
          count: entrancesDirectoryObject.length,
          onTitleTap: () {
            context.router.replaceOrPush(
              route: PoiCardWidgetRoute(objectId: entrancesDirectoryObject.firstOrNull?.id),
              toCompareRoutes: toCompareRoutes,
            );
          },
          text: ContentRowTextOptions(
            title: '${context.l10n.exit} 1',
            subtitle: entrancesDirectoryObject.firstOrNull?.makeAddress(),
          ),
          leading: GeneralIcons.doorEntrance.icon(color: context.colors.accentDefault),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entrancesDirectoryObject
                .skip(1)
                .mapIndexed(
                  (index, data) => ContentRow(
                    onTap: () {
                      context.router.replaceOrPush(
                        route: PoiCardWidgetRoute(objectId: data.id),
                        toCompareRoutes: toCompareRoutes,
                      );
                    },
                    text: ContentRowTextOptions(
                      title: '${context.l10n.exit} ${context.l10n.number(index + 2)}',
                      subtitle: data.makeAddress(),
                    ),
                    leading: GeneralIcons.doorEntrance.icon(color: context.colors.accentDefault),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
