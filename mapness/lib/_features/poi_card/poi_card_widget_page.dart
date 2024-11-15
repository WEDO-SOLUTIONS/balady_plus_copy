import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_bottom_sheet_config.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/_features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/_features/poi_card/widgets/footer/poi_card_footer.dart';
import 'package:mapness/_features/poi_card/widgets/info_widget.dart';
import 'package:mapness/_features/poi_card/widgets/photos_header/poi_photos_header.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_header/header.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls_v2.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/_features/poi_card/widgets/poi_inbuilding_widget.dart';
import 'package:mapness/_features/poi_card/widgets/poi_loading_sheet.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photo_card.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';

GlobalKey key = GlobalKey<_ContentState>();

@RoutePage()
class PoiCardWidgetPage extends StatelessWidget {
  final DgisObjectIdMessage objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const PoiCardWidgetPage({
    required this.objectId,
    this.closestPoint,
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
          key: key,
        ),
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
  final _paddingHeightWhenPhotosShown = 100.0;

  late final _bottomSheetAspectRatio = ValueNotifier<double>(0.0);
  late final _bottomSheetHeight = ValueNotifier<double>(0.0);
  late final _hideControls = ValueNotifier<bool>(true);

  late final TabController _tabController;
  late final ValueNotifier<PoiTabsType> _tabType;

  late final _bottomSheetController = StatefulBottomSheetController(
    behavior: AspectRatioSnappingBehavior(
      aspectRatios: PoiBottomSheetConfig.aspectRatios,
    ),
    stateMapper: const PoiCardStateMapper(),
    initialState: PoiCardBottomSheetState.halfOpen,
  );

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
          switch (_tabController.index) {
            case 0:
              _tabType.value = PoiTabsType.info;
            case 1:
              _tabType.value = PoiTabsType.photos;
              _bottomSheetController.setState(PoiCardBottomSheetState.expanded);
            case 2:
              _tabType.value = PoiTabsType.inBuilding;
              _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen);
          }
        }
      },
    );

    _bottomSheetController.addListener(() {
      _bottomSheetHeight.value = _bottomSheetController.sheetHeight;
      _bottomSheetAspectRatio.value = _bottomSheetController.aspectRatio;
      _hideControls.value = _bottomSheetAspectRatio.value < .35;
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      ref.read(cameraPaddingProvider.notifier).resetPadding();
    });
  }

  @override
  void dispose() {
    _bottomSheetAspectRatio.dispose();
    _hideControls.dispose();
    _bottomSheetHeight.dispose();
    _bottomSheetController.dispose();
    _tabController.dispose();
    _tabType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: PoiLoadingSheet(),
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
              onRetry: () => context.router.maybePop(),
            )
          ],
        );
      }
      return Column(
        children: [
          const Spacer(flex: 3),
          ErrorSheet(onRetry: () {
            if (!state.isRefreshing) {
              ref.invalidate(viewModelProvider);
            }
          }),
        ],
      );
    }

    /// has value
    ref.listen(
      poiPhotoProvider(objectId),
      (previous, next) {
        if (next.hasValue == true && next.value?.items.isNotEmpty == true) {
          return;
        }
      },
    );

    final name = data.buildingInfo.buildingName;
    if (name != null) {
      data.title = name;
    }
    final poiActions = ref.read(poiCardActionsProvider.notifier);

    return Stack(
      children: [
        // TODO(Ayat) It seems that in general this is not necessary
        // Positioned.fill(
        //   child: PoiBackground(
        //     bottomSheetAspectRatio: _bottomSheetAspectRatio,
        //   ),
        // ),
        Positioned(
          ///Retrieve padding for map controls when photo is shown
          ///also map controls has own padding that calculates from bottomSheetHeight
          child: Consumer(
            builder: (context, ref, child) {
              final photos = ref.watch(poiPhotoProvider(objectId));
              final hasPhotos = photos.hasValue && photos.requireValue.items.isNotEmpty;
              var padding = hasPhotos ? _paddingHeightWhenPhotosShown : 0.0;
              return ValueListenableBuilder(
                  valueListenable: _bottomSheetAspectRatio,
                  builder: (_, aspectRatio, __) {
                    final roundedRatio = aspectRatio.roundDecimal(1);
                    if (roundedRatio < PoiBottomSheetConfig.lowerAspectRatio) {
                      padding = 0.0;
                    }
                    if (roundedRatio >= PoiBottomSheetConfig.lowerAspectRatio && hasPhotos) {
                      padding = _paddingHeightWhenPhotosShown;
                    }
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.only(
                        bottom: padding,
                        // bottom: 0.0,
                      ),
                      child: child,
                    );
                  });
            },
            child: PoiCardMapControlsV2(
              bottomSheetHeight: _bottomSheetHeight,
              hideControls: _hideControls,
            ),
          ),
        ),
        Directionality(
          textDirection: Directionality.of(context),
          child: SafeArea(
            bottom: false,
            child: StatefulBottomSheet(
              animateOpening: false,
              key: const Key('POI CARD SHEET KEY'),
              scrollController: _bottomSheetController,
              topHeader: PoiPhotosHeader(
                objectId: objectId,
                aspectRatio: _bottomSheetAspectRatio,
              ),
              footer: PoiCardFooter(
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
                  () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
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
              header: PoiHeader(
                poiCardState: poiCardState,
                tabController: _tabController,
                data: data,
                onTapClose: () {
                  Metrics.logEventAdvanced(
                    MetricsConstants.poiKeys.exitButton,
                    group: MetricsConstants.poiTag,
                    action: MetricAction.tap.toString(),
                  );

                  ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
                  ref.read(highlightProvider.notifier).removeHighlight(widget.objectId);
                  context.router.back();
                },
              ),
              content: [
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
                            () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
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
            ),
          ),
        ),
      ],
    );
  }

  void _openRoutingRoutes(
    BuildContext context,
    WidgetRef ref,
    DirectoryObjectMessage objectMessage,
    RouteSearchPoint finishPoint,
  ) {
    Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
        props: {
          'object_id': objectMessage.id?.objectId,
          'finish_point': '${finishPoint.coordinates.latitude},${finishPoint.coordinates.longitude}'
        });

    context.router.push(
      RoutingRoutesRoute(
        points: [
          RouteParamsPointWithLabel(
            value: null,
            label: context.l10n.myLocation,
          ),
          RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: objectMessage.markerPosition!.latitude,
              longitude: objectMessage.markerPosition!.longitude,
              objectId: objectMessage.id?.objectId,
              entranceId: objectMessage.id?.entranceId,
              levelId: objectMessage.levelId,
            ),
            label: objectMessage.title,
          ),
        ],
      ),
    );
  }

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
