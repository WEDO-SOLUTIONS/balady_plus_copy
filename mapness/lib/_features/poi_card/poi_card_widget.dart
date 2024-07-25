import 'dart:async';

import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_sheet_sizes.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/footer/poi_card_footer.dart';
import 'package:mapness/_features/poi_card/widgets/header.dart';
import 'package:mapness/_features/poi_card/widgets/info_widget.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/_features/poi_card/widgets/poi_inbuilding_widget.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photo_card.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_header.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/directory_object_from_dgis_id.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet_scrollable_content.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';

class PoiCardWidget extends StatelessWidget {
  final DgisObjectIdMessage objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const PoiCardWidget({
    required this.objectId,
    required this.closestPoint,
    this.cameraConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _Content(
            objectId: objectId,
            cameraConfig: cameraConfig,
            biggestHeight: constraints.biggest.height,
            biggestWidth: constraints.biggest.width,
            closestPoint: closestPoint,
            key: ValueKey(objectId)),
      );
}

class _Content extends ConsumerStatefulWidget {
  const _Content({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.objectId,
    required this.closestPoint,
    this.cameraConfig,
    super.key,
  });

  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;

  final double biggestHeight;
  final double biggestWidth;
  final LatLng? closestPoint;

  @override
  ConsumerState<_Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_Content> with SingleTickerProviderStateMixin {
  final _expansion = ValueNotifier(Expansion.middle);

  late final TabController _tabController;
  late final ValueNotifier<PoiTabsType> _tabType;

  late final DgisBottomSheetController _bottomSheetController;

  ScrollController? _scrollController;

  @override
  void didUpdateWidget(covariant _Content oldWidget) {
    super.didUpdateWidget(oldWidget);

    _tabController.animateTo(0);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabType = ValueNotifier(PoiTabsType.info);
    _tabController.addListener(
      () {
        if (_tabController.indexIsChanging) {
          if (_scrollController?.hasClients == true) {
            _scrollController?.jumpTo(0);
          }

          switch (_tabController.index) {
            case 0:
              _tabType.value = PoiTabsType.info;
            case 1:
              _tabType.value = PoiTabsType.photos;
              _expansion.value = Expansion.fullHidePhoto;
            case 2:
              _tabType.value = PoiTabsType.inBuilding;
              _expansion.value = Expansion.fullHidePhoto;
          }
        }
      },
    );

    _bottomSheetController = DgisBottomSheetController();
    Future.delayed(const Duration(milliseconds: 250), () {
      ref.read(cameraPaddingProvider.notifier).resetPadding();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabType.dispose();
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOfScreen = MediaQuery.of(context).size;
    final sheetSizes = PoiSheetSizes.poiCard(sizeOfScreen: sizeOfScreen);

    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final state = ref.watch(viewModelProvider);

    final poiCardState = state.valueOrNull;
    final data = poiCardState?.gisObjectIdMessage;
    final objectId = data?.id?.objectId;

    if (widget.closestPoint != null) {
      final closestPoint = widget.closestPoint!;
      data?.markerPosition = GeoPointWithElevationMessage(
          latitude: closestPoint.latitude, longitude: closestPoint.longitude, elevation: 0);
    }

    /// loading progress indicator
    if (state.isLoading) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: LoadingSheet(),
      );
    }

    /// error handling or invalid data
    if (state.hasError || objectId == null || data == null) {
      if (state.error is PlatformException &&

          /// sometimes error code is in message and sometimes in code, idk, probably changed in releases
          ((state.error! as PlatformException).code == 'NotFoundException' ||
              (state.error! as PlatformException).message == 'NotFoundException')) {
        return Column(
          children: [
            const Spacer(flex: 3),
            ErrorSheetV2(
              errorTitle: context.l10n.poiObjectNotFoundTitle,
              errorContent: context.l10n.poiObjectNotFoundContent,
              buttonLabel: context.l10n.poiObjectNotFoundButtonLabel,
              assetImage: 'assets/images_svg/happy_face.svg',
              package: PackageConfig.packageName,
              onRetry: () => context.pop(),
            )
          ],
        );
      }
      return Column(
        children: [
          const Spacer(flex: 3),
          ErrorSheet(
            onRetry: () => ref.invalidate(
              directoryObjectFromDgisIdProvider(widget.objectId),
            ),
          ),
        ],
      );
    }

    /// has value
    final name = data.buildingInfo.buildingName;
    if (name != null) {
      data.title = name;
    }

    final language = ref.watch(appLanguageProvider);
    final photos = ref.watch(poiPhotoProvider(objectId));
    final poiActions = ref.read(poiCardActionsProvider.notifier);
    final address = data.address;

    return BackdropFilter(
      filter: switch (_expansion.value) {
        Expansion.expanded || Expansion.fullHidePhoto => ColorFilter.mode(Colors.black.withAlpha(90), BlendMode.screen),
        _ => const ColorFilter.mode(Colors.transparent, BlendMode.screen),
      },
      child: Directionality(
        textDirection: switch (language) {
          Language.arabic => TextDirection.rtl,
          Language.english => TextDirection.ltr,
        },
        child: DgisBottomSheet(
          key: const Key('POI CARD SHEET KEY'),
          showBarrier: false,
          availableExpansions: const {
            Expansion.collapsed,
            Expansion.expanded,
            Expansion.hidden,
          },
          initialExpansion: Expansion.collapsed,
          collapsedHeight:
              sheetSizes.collapsedHeight + (address != null ? 20 : 0) + (photos.hasValue == true ? 100.0 : .0),
          hiddenHeight: sheetSizes.hiddenHeight,
          controller: _bottomSheetController,
          mapControlsBuilder: (context, bottomSheetSize, biggestHeight, smallestHeight) => PoiCardMapControls(
            bottomSheetSize: bottomSheetSize,
            biggestHeight: biggestHeight,
          ),
          onExpansionChanged: (expansion, {byUser = false}) => setState(() {
            _expansion.value = expansion;
          }),
          scrollHeader: PoiPhotosHeader(
            objectId: objectId,
            expansion: _expansion,
          ),
          actions: ValueListenableBuilder(
            valueListenable: _expansion,
            builder: (_, expansion, child) => expansion != Expansion.hidden ? child! : const SizedBox.shrink(),
            child: PoiCardFooter(
              data: data,
              share: () {
                Metrics.logEventAdvanced(MetricsConstants.poiKeys.share,
                    group: MetricsConstants.poiTag,
                    action: MetricAction.tap.toString(),
                    props: {
                      'object_id': data.id?.objectId,
                      'closest_point': '${widget.closestPoint?.latitude},${widget.closestPoint?.longitude}'
                    });

                poiActions.share(
                  objectId: objectId,
                  markerCoords: widget.closestPoint,
                );
              },
              callPhone: () {
                Metrics.logEventAdvanced(MetricsConstants.poiKeys.call,
                    group: MetricsConstants.poiTag,
                    action: MetricAction.tap.toString(),
                    props: {
                      'objectId': objectId,
                    });

                final phoneNumber = data.getContactsInfoModels().firstWhereOrNull(
                      (element) => element.type == ContactsInfoType.phone,
                    );
                if (phoneNumber?.value != null) {
                  poiActions.callPhone(phoneNumber!.value!);
                }
              },
              onEntranceTap: () => poiActions.toggleEntrances(
                data,
                () => _bottomSheetController.animateTo(Expansion.collapsed),
                widget.closestPoint,
              ),
              onTapCar: () {
                final mapSetting = MapObjectManagerSettings.search();
                ref
                    .read(
                      mapObjectManagerProvider(
                        named: mapSetting.name,
                        layerId: mapSetting.layerId,
                      ).notifier,
                    )
                    .setMapObjectManagerIsVisible(isVisible: false);

                _openRoutingRoutes(
                  context,
                  ref,
                  data,
                  RouteSearchPoint(
                    coordinates: data.markerPosition!.toGeoPointMessage(),
                    dgisObjectId: data.id!,
                  ),
                );
              },
              onTapFavorite: (item) => _onFavoriteTap(context: context, ref: ref, data: data, favouriteItem: item),
            ),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl)),
          scrollableBody: (context, controller) {
            _scrollController = controller;
            return DgisBottomSheetScrollableContent(
              controller: _scrollController,
              header: PoiHeader(
                poiCardState: poiCardState,
                tabController: _tabController,
                expansionState: _expansion,
                data: data,
                onTapClose: () {
                  Metrics.logEventAdvanced(
                    MetricsConstants.poiKeys.exitButton,
                    group: MetricsConstants.poiTag,
                    action: MetricAction.tap.toString(),
                  );

                  ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
                  ref.read(highlightProvider.notifier).removeHighlight(widget.objectId);
                  context.pop();
                },
              ),
              bodyPadding: const EdgeInsets.all(Spacing.$4x),
              body: [
                ValueListenableBuilder(
                  valueListenable: _tabType,
                  builder: (context, tabType, _) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: switch (tabType) {
                      PoiTabsType.info => InfoWidget(
                          objectInfo: poiCardState?.gisObjectIdMessage,
                          qrTradeLicense: poiCardState?.qrTradeLicense,
                          onEntrancesTap: () => poiActions.toggleEntrances(
                            data,
                            () => _bottomSheetController.animateTo(Expansion.collapsed),
                            widget.closestPoint,
                          ),
                        ),
                      PoiTabsType.photos => PoiPhotoCard(objectId: data.id?.objectId ?? 0),
                      PoiTabsType.inBuilding => PoiInBuildingWidget(
                          state: poiCardState,
                          objectId: widget.objectId,
                          bottomTabsHeight: PoiCardFooter.height + 2 * PoiCardFooter.padding,
                        ),
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openRoutingRoutes(
      BuildContext context, WidgetRef ref, DirectoryObjectMessage data, RouteSearchPoint finishPoint) {
    final objectMessage = data;
    Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
        props: {
          'object_id': objectMessage.id?.objectId,
          'finish_point': '${finishPoint.coordinates.latitude},${finishPoint.coordinates.longitude}'
        });

    final goRouter = ref.read(goRouterProvider);
    final matches = goRouter.routerDelegate.currentConfiguration.matches;
    final hasRoutingRoutes = matches.any((element) => element.matchedLocation == RoutingRoutesRoute.path);

    if (hasRoutingRoutes) {
      context.popRouteUntilFirst();
      final dgisObjectId = objectMessage.id?.objectId;
      if (dgisObjectId != null) {
        PoiMapRoute.open(goRouter, dgisObjectId);
      }
    }

    final route = _createRoutingRoute(objectMessage, context.l10n.myLocation);
    unawaited(route.push(context));
  }

  RoutingRoutesRoute _createRoutingRoute(
    DirectoryObjectMessage objectMessage,
    String startLabel,
  ) =>
      RoutingRoutesRoute(
        finishLabel: objectMessage.title,
        finishLatitude: objectMessage.markerPosition!.latitude,
        finishLongitude: objectMessage.markerPosition!.longitude,
        finishObjectId: objectMessage.id?.objectId,
        finishEntranceId: objectMessage.id?.entranceId,
        finishLevelId: objectMessage.levelId,
        startLabel: startLabel,
        startLatitude: null,
        startLongitude: null,
        startObjectId: null,
        startEntranceId: null,
        startLevelId: null,
      );

  Future<void> _onFavoriteTap({
    required BuildContext context,
    required WidgetRef ref,
    required DirectoryObjectMessage data,
    FavouriteItem? favouriteItem,
  }) async {
    await CommonFunctions.authOrOpen(
      context,
      callback: () {
        Metrics.logEventAdvanced(
          MetricsConstants.poiKeys.addToFavorite,
          group: MetricsConstants.poiTag,
          action: MetricAction.tap.toString(),
          props: {
            'objectId': data.id?.objectId,
          },
        );

        final favState = ref.read(favouriteCacheProvider).valueOrNull;
        final favRepo = ref.read(favouriteCacheProvider.notifier);

        /// if already in favourites - remove
        if (favouriteItem != null) {
          favRepo.deleteItem(favouriteItem);
          return;
        }

        FavouriteItem? favItem = favouriteItem;
        if (favItem == null && data.markerPosition != null && data.id != null) {
          favItem = FavouriteItem(
            coordinates: Coordinates(
              latitude: data.markerPosition!.latitude,
              longitude: data.markerPosition!.longitude,
            ),
            id: 'overriden',
            subtitle: data.subtitle,
            title: data.title,
            entity: FavouriteItemEntity(
              sourceType: EntitySourceType.urbi,
              id: data.id!.objectId.toString(),
            ),
          );
        }

        if (favItem == null) {
          return;
        }

        /// do not show dialog if home and work are set
        if (favState?.home != null && favState?.work != null) {
          favRepo.addItem(data.mapToFavourite());
        } else {
          /// show dialog to choose home, work or regular
          _showDialog(context, favItem);
        }
      },
    );
  }

  Future<void> _showDialog(
    BuildContext context,
    FavouriteItem newFavourite,
  ) async {
    await showDialog(
      context: context,
      builder: (contextDialog) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: Theme(
          data: Theme.of(context),
          child: MediaQuery(
            data: MediaQuery.of(context),
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Localizations.override(
                context: context,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PoiFavoriteDialog(
                    favItem: newFavourite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
