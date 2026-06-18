import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/nearby/model/nearby_model.dart';
import 'package:mapness/features/nearby/providers/nearby.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

@RoutePage()
class NearbyPage extends ConsumerWidget {
  const NearbyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyState = ref.watch(nearbyProvider);

    return Scaffold(
      backgroundColor: context.colors.backgroundSurface1,
      appBar: BaladyTopBar.iconAndText(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        leading: ActionModel(icon: SystemIcons.arrowCornerLeftLarge, onPressed: () => context.router.pop()),
        title: context.l10n.nearby,
      ),
      body: SafeArea(
        child: Center(
          child: switch (nearbyState) {
            AsyncLoading<List<NearbyItem>>() => CircularProgressIndicator(color: context.colors.accentDefault),
            AsyncData<List<NearbyItem>>(:final value) => ColoredBox(
              color: context.colors.neutralContainerSoft,
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: Spacing.$2x,
                crossAxisSpacing: Spacing.$2x,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final item = value[index];
                  return GestureDetector(
                    onTap: () {
                      context.router.replaceOrPush(
                        route: PoiCardWidgetRoute(objectId: item.object.id),
                        toCompareRoutes: [PoiCardWidgetRoute.page],
                      );
                    },
                    child: _Tile(item: item, index: index, isLarge: index % 4 == 0 || index % 4 == 2),
                  );
                },
              ),
            ),
            AsyncError<List<NearbyItem>>() => BaseErrorWidget(
              errorTitle: context.l10n.failedToLoadData,
              errorLabel: context.l10n.tryAgainLater,
              withRetryButton: false,
              onRetry: () {},
            ),
          },
        ),
      ),
    );
  }
}

class _Tile extends ConsumerWidget {
  final NearbyItem item;
  final int index;
  final bool isLarge;

  const _Tile({required this.item, required this.index, required this.isLarge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutedColor = context.colors.foregroundSoft;

    final reviewCount = item.object.reviews?.count;

    final objectId = item.object.id;
    final String? imageUrl = objectId == null
        ? null
        : ref.watch(poiPhotoProvider(objectId.objectId)).value?.items.firstOrNull?.url;

    final markerPosition = item.object.markerPosition;
    final finishPoint = markerPosition == null || objectId == null
        ? null
        : RouteSearchPoint(
            coordinates: markerPosition.toGeoPointMessage(),
            dgisObjectId: objectId,
          );
    final distanceInMillimeters = ref
        .watch(
          briefRouteInfoProvider(finishPoint: finishPoint, navType: RouteSearchOptionsMessage.pedestrian),
        )
        ?.firstOrNull
        ?.extraInfo
        .distance;

    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusBorder.l),
      child: AspectRatio(
        aspectRatio: isLarge ? 167 / 223 : 167 / 178,
        child: Container(
          decoration: BoxDecoration(color: context.colors.backgroundSurface1),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: imageUrl != null
                    ? Image.network(imageUrl, fit: BoxFit.cover)
                    : Assets.images.imgNearbyPlaceholder.image(fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.$2_5x, Spacing.$2x, Spacing.$2_5x, Spacing.$2_5x),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.object.title,
                            style: context.textStyles.buttonM.copyWith(color: context.colors.foregroundDefault),
                          ),
                        ),
                        if (reviewCount != null)
                          Text(
                            '☆ $reviewCount',
                            style: context.textStyles.captionMediumRegular.copyWith(color: mutedColor),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
                      child: Divider(color: mutedColor),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(color: mutedColor, shape: BoxShape.circle),
                              ),
                              const SizedBox(
                                width: Spacing.$1x,
                              ),
                              Text(
                                item.object.subtitle,
                                style: context.textStyles.captionMediumRegular.copyWith(color: mutedColor),
                              ),
                            ],
                          ),
                        ),
                        if (distanceInMillimeters != null)
                          Text(
                            (distanceInMillimeters / 1000).formatDistanceShort(context.l10n),
                            style: context.textStyles.captionMediumRegular.copyWith(color: mutedColor),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
