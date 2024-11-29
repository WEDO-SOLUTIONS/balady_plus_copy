import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/interesting_places.dart';
import 'package:mapness/_features/landing/widgets/places_horizontal_list.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';

class ShoppingMallsCardsList extends ConsumerWidget {
  const ShoppingMallsCardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(interestingPlacesProvider)
      .when(
        data: (items) {
          final places = items
              .where(
                (e) => e.tags.contains(
                  proto.InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_FLOORS,
                ),
              )
              .toList();

          return PlacesList(
            title: context.l10n.placesToShop,
            places: places,
            onItemTap: (index) {
              final objectId = int.tryParse(places[index].entity.id) ?? 0;
              Metrics.logEventAdvanced(
                  MetricsConstants.exploreKeys.placesToShopBanner,
                  action: MetricAction.tap.name,
                  group: MetricsConstants.exploreTag,
                  props: {
                    'id': objectId,
                    'title': places[index].titleOrFallback(
                      locale: AppLocalizationsEn(),
                    ),
                  });

              context.router.push(
                PoiCardWidgetRoute(
                  objectId: DgisObjectIdMessage(
                    objectId: objectId,
                    entranceId: 0,
                  ),
                  cameraConfig: const PoiCameraConfig(zoom: 17),
                ),
              );
            },
          );
        },
        error: (error, trace) => ErrorSheet(
          onRetry: () => ref.invalidate(interestingPlacesProvider),
        ),
        loading: () => const LoadingSheet(),
      );
}
