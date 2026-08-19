import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_section.dart';
import 'package:mapness/features/bus_departures/providers/provider.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/jeddah_bus/repo.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/poi_content_ext.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_search_by_object.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_entrances_metro.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_lines_container.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_lines_jeddah_bus.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_lines_metro.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/pages/poi_card/scroll_paper_about_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/widgets/landing/kaaba_virtual_journey_card.dart';
import 'package:mapness/widgets/search/ui/working_hours_from_opening_hours_message.dart';

class PoiContentSliver extends ConsumerWidget {
  final PoiCardState? poiCardState;
  final void Function()? onEntrancesTap;

  const PoiContentSliver({super.key, this.poiCardState, this.onEntrancesTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = poiCardState?.gisObjectIdMessage;

    if (data == null) {
      return const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: Spacing.$4x),
        sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
      );
    }
    const itemPadding = EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x);

    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final pilgrimFeature = ref.watch(showPilgrimFeatureProvider);
    const kaabaLat = 21.422421;
    const kaabaLon = 39.826168;
    const eps = 1e-6;
    final markerPosition = data.markerPosition;
    final isKaaba =
        markerPosition != null &&
        (markerPosition.latitude - kaabaLat).abs() < eps &&
        (markerPosition.longitude - kaabaLon).abs() < eps;

    // Check if pilgrim feature is enabled and active based on dates
    final isPilgrimFeatureActive =
        pilgrimFeature != null &&
        pilgrimFeature.enabled &&
        (pilgrimFeature.startDate == null || !DateTime.now().isBefore(pilgrimFeature.startDate!));

    final shouldShowMakkahPreview =
        (specialThemeMode == SpecialThemeMode.mekkahBase || specialThemeMode == SpecialThemeMode.ramadan) &&
        isKaaba &&
        isPilgrimFeatureActive;

    // final offers = ref.watch(poiOffersProvider);
    // final hasOffers = offers.containsKey(poiCardState?.gisObjectIdMessage?.tradeLicense?.license.trim());

    final finishPoint = RouteSearchPoint(
      coordinates: data.markerPosition?.toGeoPointMessage() ?? GeoPointMessage(latitude: 0, longitude: 0),
      dgisObjectId: data.id!,
    );

    // Get user's current location to use as startPoint for route calculation
    final userLocation = ref.watch(locationProvider);
    RouteSearchPoint? startPoint;
    if (userLocation != null) {
      startPoint = RouteSearchPoint(
        coordinates: GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude),
        dgisObjectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
      );
    }

    final briefInfo = ref.watch(
      briefRouteInfoProvider(finishPoint: finishPoint, navType: RouteSearchOptionsMessage.car, startPoint: startPoint),
    );

    final searchObjectFuture = ref.watch(poiSearchByObjectProvider(data));
    final poiSearchObjectFuture = searchObjectFuture.value?.$1;
    final poiSearchByObjectEntrances = searchObjectFuture.value?.$2 ?? [];

    final mainLines = data.routeInfos.map((e) => e.name).toList();
    poiSearchObjectFuture?.removeWhere((element) => mainLines.contains(element.title));

    final entrancesWidget = Padding(
      padding: itemPadding,
      child: PoiEntrancesMetro(entrancesDirectoryObject: poiSearchByObjectEntrances),
    );

    final busDepartures = ref.watch(busDeparturesProvider(data.id!.objectId.toString()));
    final makkahDeparturesModel = busDepartures.value?.data.transitSystems.firstWhereOrNull(
      (element) => element.id == 'makkah_bus',
    );
    final haramDeparturesModel = busDepartures.value?.data.transitSystems.firstWhereOrNull(
      (element) => element.id == 'haram_shuttle',
    );
    final workingHours = data.openingHours?.toWorkingHours();

    Future<void> bssOnContactTap(BssContactType type, String value) async {
      await BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: const BssUIElement(name: BssUIElementNames.contact, ownerName: BssUIElementNames.cardInformation),
          payload: BssPayload(
            placeItem: data.toBss(),
            contact: BssContact(type: type, value: value),
          ),
        ),
      );
    }

    // Contacts
    final actionsProvider = ref.read(poiCardActionsProvider.notifier);
    final contacts = data.getContacts(
      (value) {
        bssOnContactTap(BssContactType.phone, value);
        actionsProvider.callPhone(value);
      },
      (value) {
        bssOnContactTap(BssContactType.email, value);
        actionsProvider.sendEmail(value);
      },
      (value) {
        bssOnContactTap(BssContactType.website, value);
        actionsProvider.launch(value);
      },
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

    // Favourite
    final favouritesState = ref.watch(favouriteCacheProvider);
    final void Function() onFavouritePressed = () {
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
          QuickFeedbackRoute(type: QuickFeedbackType.editCompany, params: FeedbackObjectIdParams(objectIdInt)),
        );
      },
      title: context.l10n.dataIsIncorrect,
    );
    final activeCityEvent = ref.watch(activeCityEventProvider);
    final isFoundationDay = activeCityEvent?.isFoundingDay ?? false;
    final isFoundationObject = ref.read(foundingDayUrbiProvider.notifier).isFoundationObject(data.id!.objectId);
    final localAboutText = ref.read(foundingDayUrbiProvider.notifier).getAboutByDgisId(data.id!.objectId);
    final forceShow = ref.read(foundingDayUrbiProvider.notifier).shouldForceShow(data.id!.objectId);
    final about = data.getAbout(context.l10n, customAbout: forceShow ? localAboutText : null);
    final effectiveAbout = localAboutText.isNotEmpty ? localAboutText : about?.text;
    final canUseCustomData = isFoundationDay && isFoundationObject;
    final isLeapObject = ref.read(leapProvider.notifier).isLeapObjectId(data.id!.objectId);

    final fullAddress = data.getFullAddress(
      briefInfo,
      context.l10n,
      onEntrancesTap,
      canUseCustomData ? activeCityEvent?.addressLogoAsset : null,
    );
    final hasAddressContent =
        fullAddress.fullAddress.trim().isNotEmpty ||
        fullAddress.floors != null ||
        (fullAddress.entrances?.count ?? 0) > 0 ||
        (fullAddress.types?.isNotEmpty ?? false);

    final jeddahBusData = ref.watch(jeddahBusLayerRepoProvider).value;
    final jeddahBusStation = jeddahBusData?.getStationByDirectoryObject(data);
    final jeddahBusStationLines = jeddahBusStation?.lineIds.map((e) => jeddahBusData?.lines[e]).nonNulls.toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            if (data.isDroppedPin)
              Padding(
                padding: itemPadding,
                child: PoiContentFeedbackCard(
                  padding: EdgeInsetsGeometry.zero,
                  data: PoiContentFeedbackType.addPlace,
                  onTap: () => context.router.push(QuickFeedbackRoute()),
                  activeCityEvent: activeCityEvent,
                ),
              )
            else
              Padding(
                padding: itemPadding,
                child: PoiContentFeedbackCard(
                  onTap: () {
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
                  data: PoiContentFeedbackType.cityExpert,
                  padding: EdgeInsets.zero,
                  activeCityEvent: activeCityEvent,
                ),
              ),
            if (!isLeapObject || hasAddressContent)
              Padding(
                padding: itemPadding,
                child: PoiContentFullAddressCard(data: fullAddress),
              ),
            AiSummarySection(
              poiId: data.id!.objectId.toString(),
              objectTypes: data.types.map((t) => t.type).toList(growable: false),
            ),
            if (shouldShowMakkahPreview)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.$3x),
                child: KaabaVirtualJourneyCard(
                  onTap: () {
                    context.router.push(const GaussianSplattingRoute());
                  },
                ),
              ),
            if (effectiveAbout != null)
              if (canUseCustomData)
                ScrollPaper(
                  roughness: 1.2,
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  padding: EdgeInsets.only(bottom: itemPadding.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.about, style: context.textStyles.bodyLargeSemiBold),
                      const SizedBox(height: Spacing.$2x),
                      Text(
                        effectiveAbout,
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: context.colors.foregroundSoft,
                        ),
                      ),
                    ],
                  ),
                )
              else if (about != null)
                Padding(
                  padding: itemPadding,
                  child: PoiContentAboutCard(data: about),
                ),
            if (workingHours != null) //
              Padding(
                padding: itemPadding,
                child: PoiContentWorkingHoursCard(workingHours: workingHours, workStatusMessage: data.workStatus),
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
            // if (hasOffers)
            //   PoiContentOffersCard(
            //     offers: offers[poiCardState?.gisObjectIdMessage?.tradeLicense?.license.trim()] ?? [],
            //     contentPadding: itemPadding,
            //   ),
            if (poiSearchByObjectEntrances.isNotEmpty) entrancesWidget,
            if (jeddahBusStation != null)
              PoiLinesJeddahBus(
                station: jeddahBusStation,
                lines: jeddahBusStationLines,
              )
            else
              ...routeInfos
                  .map(
                    (e) => Padding(
                      padding: itemPadding,
                      child: PoiLinesMetro(transportDirectoryRouteInfo: e, address: data.title),
                    ),
                  )
                  .toList(),
            PoiLinesContainer(
              model: makkahDeparturesModel,
            ),
            PoiLinesContainer(
              model: haramDeparturesModel,
              isShuttle: true,
            ),
            ...?poiSearchObjectFuture
                ?.map(
                  (e) => Padding(
                    padding: itemPadding,
                    child: PoiLinesMetro(transportDirectoryRouteInfo: e.routeInfos.first, address: data.title),
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
            if (license != null)
              Padding(
                padding: itemPadding,
                child: PoiContentLicenseCard(license: license),
              ),
          ],
        ),
      ),
    );
  }
}
