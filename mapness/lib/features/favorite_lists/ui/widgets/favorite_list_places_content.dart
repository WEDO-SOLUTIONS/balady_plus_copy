import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_place_poi.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_progress_indicator.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:urbi_utils/urbi_utils.dart';

class FavoriteListPlacesContent extends ConsumerWidget {
  const FavoriteListPlacesContent({required this.listId, super.key});

  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listDetailAsync = ref.watch(favoriteListDetailProvider(listId: listId));

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$2x),
      child: listDetailAsync.when(
        data: (listDetail) {
          final places = listDetail.list.places ?? [];
          if (places.isEmpty) {
            // TODO(claude): localize string
            return Text(
              'No places in this list yet',
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.$3x,
            children: places
                .map<Widget>((place) => _FavoriteListPlaceTile(list: listDetail.list, place: place))
                .insertBetween(
                  Divider(
                    color: context.colors.borderSoft,
                    height: 0.5,
                    thickness: 0.5,
                    indent: Spacing.$6x.toDouble(),
                  ),
                )
                .toList(),
          );
        },
        loading: () => const FavoriteProgressIndicator(),
        error: (error, stackTrace) => Text(
          error is FavoriteListsApiException
              ? error.localizedMessage(ref.read(appLanguageProvider))
              : context.l10n.somethingWentWrongPleaseTryAgainLater,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
        ),
      ),
    );
  }
}

class _FavoriteListPlaceTile extends ConsumerWidget {
  final FavoriteListDto list;
  final FavoriteListPlaceDto place;

  const _FavoriteListPlaceTile({required this.list, required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectId = int.tryParse(place.placeId);
    if (objectId == null) {
      return _FallbackPlaceText(place: place);
    }

    final poiAsync = ref.watch(favoriteListPlacePoiProvider(objectId));

    final menuIcon = IconButton(
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: const Icon(SystemIcons.ellipsis, size: 24),
      color: context.colors.foregroundSoft,
      onPressed: () => context.router.push(FavoriteItemMenuRoute(listId: list.id, place: place)),
    );

    return poiAsync.when(
      data: (poi) {
        if (poi == null) {
          return _FallbackPlaceText(place: place);
        }

        final userLocation = ref.watch(locationProvider);
        final finishPoint = RouteSearchPoint(
          coordinates: poi.markerPosition?.toGeoPointMessage() ?? GeoPointMessage(latitude: 0, longitude: 0),
          dgisObjectId: poi.id ?? DgisObjectIdMessage(objectId: 0, entranceId: 0),
        );
        final startPoint = userLocation == null
            ? null
            : RouteSearchPoint(
                coordinates: GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude),
                dgisObjectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
              );
        final briefInfo = ref.watch(
          briefRouteInfoProvider(
            finishPoint: finishPoint,
            navType: RouteSearchOptionsMessage.car,
            startPoint: startPoint,
          ),
        );
        final eta = briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Spacing.$1x,
                    children: [
                      Text(
                        place.customName ?? poi.title,
                        style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                      ),
                      Text(
                        poi.subtitle,
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
                      ),
                    ],
                  ),
                ),
                menuIcon,
              ],
            ),
            const SizedBox(height: Spacing.$1x),
            Row(
              spacing: Spacing.$1x,
              children: [
                Expanded(
                  child: Text(
                    poi.makeAddress(),
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ),
                if (eta != null) ...[
                  Icon(TransportIcons.car, color: context.colors.foregroundSoft, size: 16),
                  Text(
                    eta,
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ],
              ],
            ),
            const SizedBox(height: Spacing.$3x),
            BaladyAppButton(
              primaryLabel: context.l10n.poiCardDirections,
              buttonColorScheme: ButtonColorScheme.accent,
              primaryIcon: TransportIcons.locationDirectionNavigator,
              iconSize: 14,
              innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2_5x, horizontal: Spacing.$3x),
              onTap: () async {
                // TODO(claude): open build route page
              },
            ),
          ],
        );
      },
      loading: () => const FavoriteProgressIndicator(),
      error: (error, stackTrace) => Row(
        children: [
          Expanded(child: _FallbackPlaceText(place: place)),
          menuIcon,
        ],
      ),
    );
  }
}

class _FallbackPlaceText extends StatelessWidget {
  const _FallbackPlaceText({required this.place});

  final FavoriteListPlaceDto place;

  @override
  Widget build(BuildContext context) => Text(
    place.customName ?? place.placeId,
    style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
  );
}
