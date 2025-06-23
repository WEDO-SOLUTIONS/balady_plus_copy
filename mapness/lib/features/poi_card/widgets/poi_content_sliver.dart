import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/poi_content_ext.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_search_by_object.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_offer_card.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_entrances_metro.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_lines_metro.dart';
import 'package:mapness/features/saudi_pass/providers/poi_offers_provider.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:shimmer/shimmer.dart';

class PoiContentSliver extends ConsumerWidget {
  final PoiCardState? poiCardState;
  final void Function()? onEntrancesTap;

  const PoiContentSliver({
    this.poiCardState,
    this.onEntrancesTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = poiCardState?.gisObjectIdMessage;
    const itemPadding = EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x);

    final offers = ref.watch(poiOffersProvider);
    final hasOffers = offers.containsKey(poiCardState?.tradeLicense?.license.trim());

    final finishPoint = data != null
        ? RouteSearchPoint(
            coordinates: data.markerPosition?.toGeoPointMessage() ??
                GeoPointMessage(
                  latitude: 0,
                  longitude: 0,
                ),
            dgisObjectId: data.id!,
          )
        : null;
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final searchObjectFuture = ref.watch(poiSearchByObjectProvider(data));
    final poiSearchObjectFuture = searchObjectFuture.valueOrNull?.$1;
    final poiSearchByObjectEntrances = searchObjectFuture.valueOrNull?.$2 ?? [];
    const colorShimmer = Color(0xFFE3E3E3);

    final entrancesWidget = Padding(
      padding: itemPadding,
      child: PoiEntrancesMetro(entrancesDirectoryObject: poiSearchByObjectEntrances),
    );

    return SliverPadding(
      padding: const EdgeInsets.only(top: Spacing.$4x, bottom: Spacing.$4x),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(childCount: 1, (context, index) {
          if (data == null) {
            return const SizedBox.shrink();
          }
          final about = data.getAbout(context.l10n);
          final workTime = data.getOpeningHours(context.l10n);

          // Contacts
          final actionsProvider = ref.read(poiCardActionsProvider.notifier);
          final contacts = data.getContacts(
            actionsProvider.callPhone,
            actionsProvider.sendEmail,
            actionsProvider.launch,
            context.l10n,
          );

          // Parking
          final parking = data.getParking(context.l10n);

          // License
          final license = data.getLicense(context.l10n);

          // Accessibility info
          final accessibilityInfo = data.getAccessibility(context.l10n, poiCardState?.qrTradeLicense);

          // Platforms lines info
          final routeInfos = data.routeInfos;
          final transportDirectoryRouteInfo = data.routeInfos.firstOrNull;
          final currentRouteTransition = transportDirectoryRouteInfo?.directions.firstOrNull?.platforms
                  .firstWhereOrNull((e) => e.name == data.title)
                  ?.transitions ??
              [];

          // Favourite
          final favouritesState = ref.watch(favouriteCacheProvider);
          final void Function() onFavouritePressed = () {
            Metrics.logEventAdvanced(
              MetricsConstants.poiKeys.favorites,
              group: MetricsConstants.poiTag,
              action: MetricAction.tap.toString(),
            );

            context.router.push(const FavouritesRoute());
          };
          final favourites = data.getFavourites(favouritesState, context.l10n, onFavouritePressed);

          // Feedback
          final feedback = PoiContentDataIncorrectModel(
            onFeedbackTap: () {
              if (data.id == null) {
                return;
              }
              final objectIdInt = int.tryParse(data.id!.objectId.toString());
              if (objectIdInt == null) {
                return;
              }

              context.router.push(
                QuickFeedbackRoute(
                  type: QuickFeedbackType.editCompany,
                  params: FeedbackObjectIdParams(objectIdInt),
                ),
              );
            },
            title: context.l10n.dataIsIncorrect,
          );

          return Column(
            children: [
              const PoiContentFeedbackCard(
                data: PoiContentFeedbackType.cityExpert,
                padding: itemPadding,
              ),
              Padding(
                padding: itemPadding,
                child: PoiContentFullAddressCard(
                  data: data.getFullAddress(briefInfo, context.l10n, onEntrancesTap),
                ),
              ),
              if (about != null)
                Padding(
                  padding: itemPadding,
                  child: PoiContentAboutCard(data: about),
                ),
              if (workTime != null) //
                Padding(
                  padding: itemPadding,
                  child: PoiContentWorkingHoursCard(data: workTime),
                ),
              if (contacts != null) //
                Padding(
                  padding: itemPadding,
                  child: PoiContentContactsCard(data: contacts),
                ),
              if (favourites != null) //
                Padding(
                  padding: itemPadding,
                  child: PoiContentFavouritesCard(data: favourites),
                ),
              if (parking != null) //
                Padding(
                  padding: itemPadding,
                  child: PoiContentParkingCard(data: parking),
                ),
              if (hasOffers)
                PoiContentOffersCard(
                  offers: offers[poiCardState?.tradeLicense?.license.trim()] ?? [],
                  contentPadding: itemPadding,
                ),
              if (searchObjectFuture.isLoading && data.entrances.isNotEmpty)
                Shimmer.fromColors(
                  baseColor: colorShimmer,
                  highlightColor: Colors.white,
                  child: entrancesWidget,
                ),
              if (poiSearchByObjectEntrances.isNotEmpty) entrancesWidget,
              ...routeInfos
                  .map((e) => Padding(
                        padding: itemPadding,
                        child: PoiLinesMetro(
                          transportDirectoryRouteInfo: e,
                          address: data.title,
                        ),
                      ))
                  .toList(),
              if (searchObjectFuture.isLoading && currentRouteTransition.isNotEmpty)
                Shimmer.fromColors(
                  baseColor: colorShimmer,
                  highlightColor: Colors.white,
                  child: entrancesWidget,
                ),
              ...?poiSearchObjectFuture
                  ?.map(
                    (e) => Padding(
                      padding: itemPadding,
                      child: PoiLinesMetro(
                        transportDirectoryRouteInfo: e.routeInfos.first,
                        address: data.title,
                      ),
                    ),
                  )
                  .toList(),
              if (accessibilityInfo != null)
                Padding(
                  padding: itemPadding,
                  child: PoiContentAccessabilityCard(data: accessibilityInfo),
                ),
              Padding(
                padding: itemPadding,
                child: PoiContentDataIncorrectCard(data: feedback),
              ),
              if (license != null) //
                Padding(
                  padding: itemPadding,
                  child: PoiContentLicenseCard(license: license),
                ),
            ],
          );
        }),
      ),
    );
  }
}
