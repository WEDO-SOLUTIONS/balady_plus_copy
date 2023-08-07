import 'dart:async';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:collection/collection.dart';
import 'dart:math' show abs;

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../constants/constants.dart';
import 'package:flutter/widgets.dart';

import '../../data/data_sources/point_layers_data.dart';
import '../../data/enums/map_enums.dart';
import '../../data/model/building_compliance_certificate.dart';
import '../../data/model/divisional_chart_boundaries.dart';
import '../../data/model/excavations.dart';
import '../../data/model/investment_details_response.dart';
import '../../data/model/investment_sites.dart';
import '../../data/model/layers.dart';
import '../../data/model/rental_details_response.dart';
import '../../data/model/requests/map_requests_params.dart';
import '../../data/model/white_lands.dart';
import '../../data/repositories/layers_repositories.dart';

const int mil = 300;
TextEditingController searchController = TextEditingController();

class MapViewModel extends BaseViewModel {
  final GeoPointMessage kingdomTower =
      GeoPointMessage(latitude: 24.712301, longitude: 46.674175);
  final GeoPointMessage ithraa =
      GeoPointMessage(latitude: 26.336057, longitude: 50.120372);

  final LayersRepositories layersRepositories;

  MapViewModel({required this.layersRepositories});
  final selectedPointId = ValueNotifier<DgisObjectIdMessage?>(null);
  final selectedPoint = ValueNotifier<PointLayersData?>(null);

  ValueNotifier<SearchCategoryMessage?> selectedCategory = ValueNotifier(null);

  final layerSelected = ValueNotifier<Layers?>(null);
  GISMapLayers gisSelectedLayer = GISMapLayers.cityPlaces;
//////////////////////////////////////////////////////

  late DgisMapController controller;

  final viewHomeBottomSheet = ValueNotifier(true);
  final bottomSheetSize = ValueNotifier(0.5);
  final bottomSheetSizeFraction = ValueNotifier(0.5);

  final locationEnabledState = ValueNotifier(false);
  final generalControlsState = ValueNotifier(false);
  final initialized = ValueNotifier(false);

  NaviZoomController get zoomController => controller.naviZoomController;

  final _subscriptions = <StreamSubscription>[];

  StreamSubscription? _debounce;
  VisibleRectEvent? _lastHandledEvent;
  double? _cameraTopPadding;
  double oldZoom = 13;
  bool refreshMap = true;

  //final selectedPoint = ValueNotifier<DgisObjectIdMessage?>(null);

  final selectedDiggingPoint = ValueNotifier<Excavations?>(null);
  final selectedInvetmentPoint = ValueNotifier<InvestmentSites?>(null);
  final selectedImtethalPoint =
      ValueNotifier<BuildingComplianceCertificate?>(null);

  final selectedWhiteLands = ValueNotifier<WhiteLands?>(null);
  final showLegend = ValueNotifier<bool?>(null);

  final selectedLands = ValueNotifier<DivisionalChartBoundaries?>(null);

  final isSearchLoading = ValueNotifier(false);

  double zoomValue = 13;
  bool updateMap = true;

  Future<void> selectCategory({required SearchCategoryMessage category}) async {
    searchController.clear();
    if (category == selectedCategory.value) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    showLoading1();
    await controller.removeAllMarkers();

    if (selectedCategory.value != null)
      performSearch(
        queryText: selectedCategory.value!.displayName(),
      );
    hideLoading1();

    selectedPointId.value = null;
    selectedPointId.notifyListeners();

    if (viewHomeBottomSheet.value == false) {
      // bottomSheetSizeFraction.value = 0.05;

      viewHomeBottomSheet.value = true;
      viewHomeBottomSheet.notifyListeners();
      bottomSheetSize.notifyListeners();
      bottomSheetSizeFraction.notifyListeners();
    }
  }

//  late MapObjectManagerMessage mapObjectManager;

  Future<void> performSearch(
      {required String queryText,
      SearchCategoryMessage? category,
      bool showLoader = false}) async {
    try {
      if (showLoader) {
        await controller.removeAllMarkers();
        await controller.removeAll();

        showLoading1();
        selectedCategory.notifyListeners();
      }
      searchController.text = selectedCategory.value != null
          ? selectedCategory.value!.displayName()
          : queryText;

      SearchResultMessage data = selectedCategory.value != null
          ? await controller.searchByCategory(
              selectedCategory.value!,
              sortingType: SortingTypeMessage.byRelevance,
              isOpenNow: false,
              searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
            )
          : await controller.search(
              queryText,
              sortingType: SortingTypeMessage.byRelevance,
              isOpenNow: false,
              searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
            );

      if (showLoader) hideLoading1();

      if (data.itemMarkerInfos != null) {
        List<Marker> markers = [];

        final iconPath = selectedCategory.value != null
            ? selectedCategory.value!.markerIconName()
            : "assets/maps/icons/ic_marker.svg";

        //  await controller.removeAllMarkers(fromManager: mapObjectManager);

        for (final markerInfo in data.itemMarkerInfos!) {
          markers.add(Marker(
            id: markerInfo?.objectId?.objectId.toString() ?? const Uuid().v4(),
            options: MarkerOptionsMessage(
              position: markerInfo!.geoPoint,
              icon: MarkerIconMessage(
                path: iconPath,
                width: 24,
              ),
            ),
            onTap: () async {
              refreshMap = false;
              await controller.moveCamera(
                  CameraPositionMessage(
                      point: GeoPointMessage(
                          latitude: markerInfo.geoPoint.latitude,
                          longitude: markerInfo.geoPoint.longitude),
                      zoom: 17,
                      tilt: 0,
                      bearing: 0),
                  1,
                  CameraAnimationTypeMessage.linear);

              selectedPointId.value = markerInfo.objectId;
              print("on Tap");
              print(markerInfo.objectId);
              selectedDiggingPoint.value = null;
              selectedInvetmentPoint.value = null;
              selectedImtethalPoint.value = null;
              selectedWhiteLands.value = null;
              selectedLands.value = null;
              selectedImtethalPoint.notifyListeners();
              selectedDiggingPoint.notifyListeners();
              selectedWhiteLands.notifyListeners();
              selectedLands.notifyListeners();
              selectedPointId.notifyListeners();
              viewHomeBottomSheet.value = false;
              viewHomeBottomSheet.notifyListeners();
              // bottomSheetSizeFraction.value = 0.05;
              bottomSheetSize.notifyListeners();
              bottomSheetSizeFraction.notifyListeners();

              Future.delayed(
                const Duration(milliseconds: 300),
              );
              refreshMap = true;
            },
          ));
        }

        await controller.addMarkers(markers);
      }
      if (data.firstPage?.items != null) {
        final responseDistance = await controller.getDistanceTo(
          _mapToDistanceRequest(
            data.firstPage!.items
                .map((e) => e as DirectoryObjectMessage)
                .toList(),
          ),
        );
        print(responseDistance);
      }
      if (data.firstPage != null) {
        print("Releasing page");
        await controller.releasePage(data.firstPage!);
      }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  List<DistanceRequestMessage> _mapToDistanceRequest(
          List<DirectoryObjectMessage> values) =>
      values
          .where((element) => element.id != null)
          .where((element) => element.markerPosition != null)
          .map((e) => DistanceRequestMessage(
                geoPoint: GeoPointMessage(
                  latitude: e.markerPosition!.latitude,
                  longitude: e.markerPosition!.longitude,
                ),
                dgisObjectId: e.id!,
              ))
          .toList();

  Future<bool> initialize(DgisMapController controllerMap) async {
    controller = controllerMap;
    final result = await controller.initialize();
    print("wasInitialized ${result.wasInitialized}");
    if (!result.wasInitialized) {
      initialized.value = false;

      return false;
    }
    controller.setCameraPosition(CameraPositionMessage(
        point: kingdomTower, zoom: 17, tilt: 45, bearing: 9));

    _setupListeners();

    await controller.changeFollowState();

    // setLocale(const Locale("ar", "US"), TextDirection.ltr);
    await controller.loadStyles(Constants.mapStyle);
    await controller.overrideLocales(["ar-SA"]);
    // await controller.overrideLocales([localeState.value.locale]);
    initialized.value = true;
    generalControlsState.value = true;
    // goToLocation();
    await controller.setMarkerOptions(
      MarkerOptionsMessageOld(
        svgAsset: "assets/maps/ic_marker.svg",
        width: 30.0,
        height: 46.0,
        iconWidth: 24,
      ),
    );

/*
    mapObjectManager = await controller.createMapObjectManagerWithClustering(
      ClusteringMapObjectManager(
        options: ClusteringMapObjectManagerOptionsMessage(
          logicalPixel: 40,
          maxZoom: 16,
        ),
        renderCluster: (objectCount) {
          return SimpleClusterOptionsMessage(
            icon: MarkerIconMessage(
              path: "assets/maps/icons/ic_marker.svg",
              width: 24,
            ),
            text: "$objectCount",
            textStyle: MarkerTextStyleMessage(fontSize: 16),
          );
        },
        onTap: (clusterObject) async {
          clusterObject.setIcon("assets/maps/icons/ic_marker_red.svg");

          final clusterPosition = await controller.calcPositionForMarkers(
            clusterObject.markers,
            CalcPositionOptionsMessage(
              screenArea: CameraSetPaddingMessage(
                bottomPadding: 40,
                leftPadding: 40,
                topPadding: 40,
                rightPadding: 40,
              ),
            ),
          );
          await controller.moveCamera(
            clusterPosition,
            1.5,
            CameraAnimationTypeMessage.default_,
          );
        },
      ),
    );


*/
    return true;
  }

  void onLocationTap() => unawaited(controller.changeFollowState());

  void onLevelTap(IndoorLevel level) =>
      unawaited(controller.selectIndoorLevel(level));

  void setCameraTopPadding(double? topPadding) {
    _cameraTopPadding = topPadding;
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    _subscriptions.clear();

    locationEnabledState.dispose();

    unawaited(controller.dispose());
  }

  void showDialog() {
    clearAllCards();
    viewHomeBottomSheet.value = true;
    viewHomeBottomSheet.notifyListeners();

    //bottomSheetSizeFraction.value = 0.05;
    bottomSheetSize.notifyListeners();
    bottomSheetSizeFraction.notifyListeners();
  }

  void clearAllCards() {
    selectedDiggingPoint.value = null;
    selectedImtethalPoint.value = null;
    selectedInvetmentPoint.value = null;
    selectedPointId.value = null;
    selectedWhiteLands.value = null;
    selectedLands.value = null;
    selectedDiggingPoint.notifyListeners();
    selectedImtethalPoint.notifyListeners();
    selectedInvetmentPoint.notifyListeners();
    selectedPointId.notifyListeners();
    selectedLands.notifyListeners();

    selectedWhiteLands.notifyListeners();
  }

  void _setupListeners() {
    // add move carme map Listener
    _subscriptions.add(
      controller.visibleRectEvents.listen(
        _visibleRectChangeListener,
      ),
    );

    _subscriptions.add(
      controller.objectTapEvents.listen(
        _objectTapListener,
      ),
    );
    _subscriptions.add(
      controller.markerWithPhotoTapEvents.listen(
        _onPanoramaTap,
      ),
    );
  }

  // When move camera map any change zoom in, zoom out ...
  void _visibleRectChangeListener(VisibleRectEvent event) {
    _lastHandledEvent = event;
    // start Timer when stop move camera  call search funcation
    print(event.visibleRect.zoom);

    _startRequestTimer(event.visibleRect.zoom);
  }

  // When click on ayn object
  Future<void> _objectTapListener(TapEvent event) async {
    // when Click on Map hide ViewHomeBottomSheet if he is not hide
    if (viewHomeBottomSheet.value != false) {
      viewHomeBottomSheet.value = false;
      viewHomeBottomSheet.notifyListeners();
    }

    // //
    // switch (controller.activeLayerState.value.layer) {
    //   case BusinessLayers.tourism:
    //     if (event is ObjectTapEvent) {
    //       selectedPointId.value = DgisObjectIdMessage(
    //         objectId: event.dgisObjectId.objectId,
    //         entranceId: event.dgisObjectId.entranceId,
    //       );
    //     }
    //     return;
    //   case BusinessLayers.idle:
    //     // if (event is IdleTapEvent) unawaited(_handleIdleEvent(event));
    //     return;
    //   case BusinessLayers.io:
    //     // if (event is IoTapEvent) unawaited(_handleIoEvent(event));
    //     return;
    //   case BusinessLayers.panoramas:
    //     // handles by [_onPanoramaTap]
    //     return;
    // }
  }

  void _startRequestTimer(double oldZoom) {
    if (_debounce != null) {
      unawaited(_debounce!.cancel());
      _clearDebounce();
    }
    _debounce = Stream.fromFuture(
      Future.delayed(
        const Duration(milliseconds: 1000),
      ),
    ).listen((_) async {
      this.oldZoom = oldZoom;
      print("updateMap ${this.oldZoom.toInt()} ${zoomValue.toInt()}");
      if (this.oldZoom.toInt() != zoomValue.toInt()) {
        zoomValue = oldZoom;

        callSearch();
      }
    });
    _subscriptions.add(_debounce!);
  }

  void _clearDebounce() {
    _subscriptions.remove(_debounce);
    _debounce = null;
  }

  void _onPanoramaTap(MarkerWithPhotoTapEvent event) {
    try {
      final data = event.photoData;
      print(data);
      // panoramaState.value = PanoramaState(
      //   photoUrl: data.photoUrl,
      //   azimuth: data.azimuth,
      // );

      // if (!mapCardCollapsedState.value) {
      //   _setCameraPaddings();
      // }

      // mapCardCollapsedState.value = true;
      // topSheetVisibleState.value = false;
      unawaited(controller.moveCameraToSelectedPanorama());
    } catch (e) {
      print(e);
    }
  }

  void getLocationAndMoveCamera() async {
    var latlng = await Helpers.getMapLocation();

    if (latlng != null)
      await controller.setCameraPosition(
        CameraPositionMessage(
          zoom: 20,
          tilt: 0,
          bearing: 0,
          point: GeoPointMessage(
            latitude: 24.708194,
            longitude: 46.673345,
          ),
        ),
      );
  }

  callSearch() async {
    print("search");
    await controller.removeAllMarkers();

    await controller.removeAll();

    String? query = selectedCategory.value != null
        ? selectedCategory.value!.displayName()
        : searchController.text;
    if (query != null && query.isNotEmpty) {
      showLoading1();

      await performSearch(
        queryText: query,
      );
      hideLoading1();
    }

    print("layerSelected $layerSelected");

    if (layerSelected.value == null) return;
    print("HEREE");
    GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
        (element) => element.layerId == layerSelected.value!.id);
    showLoading1();
    bottomSheetSize.notifyListeners();

    if (gisLayer != null) {
      List? pointList = await layersRepositories.getPointsInLayers(
          params: MapRequestParams(
        layer: gisLayer,
        northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
        northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
        southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
        southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
      ));
      print("ccccccccvvvv ${layerSelected.value!.geometryType}");
      print("ccccccccvvvv ${pointList?.length}");

      switch (layerSelected.value!.geometryType) {
        case 'esriGeometryPoint':
          addMarkersWithPoint(pointList, layerSelected.value!.id);
          break;
        case 'esriGeometryPolyline':
          addPolylineWithPoint(pointList, layerSelected.value!.id);
          break;
        case 'esriGeometryPolygon':
          addPolygonWithPoint(pointList, layerSelected.value!.id);
          break;
      }
    }
    print("Doneeee");
    _clearDebounce();
    hideLoading1();
  }

  getPointDetails(int objectId) async {
    showLoading1();

    List? pointList = await layersRepositories.getPointDetailsInLayers(
        params: MapRequestParams(
      layer: gisSelectedLayer!,
      objectId: objectId,
      northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
      northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
      southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
      southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
    ));

    hideLoading1();

    Navigator.pushNamed(NavigationService.navigatorKey.currentContext!,
        RouteName.DiggingMapDetailsPage,
        arguments: pointList?.first);
  }

  Future<InvestmentDetailsResponse?> getInvestmentDetails(
      String id, String type) async {
    showLoading1();

    InvestmentDetailsResponse? data =
        await layersRepositories.getInvetmentDetails(id, type);

    hideLoading1();

    Navigator.pushNamed(NavigationService.navigatorKey.currentContext!,
        RouteName.investmentPage,
        arguments: data);

    return data;
  }

  Future<RentalDetailsResponse?> getTempRentalDetails(
      String id, String type) async {
    showLoading1();

    RentalDetailsResponse? data =
        await layersRepositories.getTempRentalDetails(id, type);

    hideLoading1();
    Navigator.pushNamed(NavigationService.navigatorKey.currentContext!,
        RouteName.tempRentalPage,
        arguments: data);

    return data;
  }

  void addMarkersWithPoint(List? pointList, int layerId) async {
    if (pointList != null && pointList.isNotEmpty) {
      String iconPath = Constants.icMarkerRestaurant;
      switch (layerId) {
        case 0:
          iconPath = Constants.icMarkerMosques;
          break;
        case 1:
          iconPath = Constants.icMarkerRestaurant;
          break;
        case 2:
          iconPath = Constants.icMarkerInvestmentSites;
          break;
        case 3:
          iconPath = Constants.icMarkerCemeteries;
          break;
        case 4:
          iconPath = Constants.icMarkerGardensParks;
          break;
        case 6:
          iconPath = Constants.icMarkerGasStations;
          break;
      }
      final markers = pointList.map(
        (element) {
          return Marker(
            id: element.id.toString(),
            options: MarkerOptionsMessage(
              position: element.latLng,
              icon: MarkerIconMessage(
                path: iconPath,
                width: 30,
              ),
            ),
            onTap: () async {
              refreshMap = false;
              /*  await controller.moveCamera(
                  CameraPositionMessage(
                      point: element.latLng, zoom: 17, tilt: 0, bearing: 0),
                  1,
                  CameraAnimationTypeMessage.linear);*/

              selectedPointId.notifyListeners();
              selectedPoint.value = null;
              selectedInvetmentPoint.value = null;
              selectedDiggingPoint.value = null;
              selectedImtethalPoint.value = null;
              selectedWhiteLands.value = null;
              selectedLands.value = null;

              selectedPointId.value = null;
              showLegend.value = false;
              showLegend.value = false;
              switch (gisSelectedLayer) {
                case GISMapLayers.Opportunities:
                  selectedPoint.value = element;
                  selectedInvetmentPoint.value = element;

                  break;
                default:
                  break;
              }

              selectedInvetmentPoint.notifyListeners();
              selectedImtethalPoint.notifyListeners();
              selectedDiggingPoint.notifyListeners();
              selectedWhiteLands.notifyListeners();
              selectedLands.notifyListeners();

              selectedPointId.notifyListeners();
              selectedPoint.notifyListeners();

              showLegend.notifyListeners();

              viewHomeBottomSheet.value = false;
              viewHomeBottomSheet.notifyListeners();
              // bottomSheetSizeFraction.value = 0.05;
              bottomSheetSize.notifyListeners();
              bottomSheetSizeFraction.notifyListeners();

              Future.delayed(
                const Duration(milliseconds: 300),
              );
              refreshMap = true;
            },
          );
        },
      ).toList();
      //await controller.removeAllMarkers();
      controller.addMarkers(markers);
    }
  }

  void addPolylineWithPoint(List? pointList, int layerId) async {
    print(pointList);
    if (pointList != null && pointList.isNotEmpty) {
      final List<Polyline> polylines = [];
      for (var element in pointList) {
        int id = int.parse(element.id);
        polylines.add(
          Polyline(
            id: id.toString(),
            options: PolylineOptionsMessage(
                points: element.paths, width: 4, color: 0xff358281),
            onTap: () {
              selectedDiggingPoint.value = null;
              selectedInvetmentPoint.value = null;
              selectedImtethalPoint.value = null;
              selectedWhiteLands.value = null;
              selectedLands.value = null;
              showLegend.value = false;
              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedDiggingPoint.value = element;

                  break;

                case GISMapLayers.BSAimtithalBuildingsCertificateL:
                  selectedImtethalPoint.value = element;

                case GISMapLayers.BSWhiteParcelS:
                  selectedWhiteLands.value = element;

                default:
                  break;
              }
              selectedPointId.value = null;
              selectedImtethalPoint.notifyListeners();
              selectedDiggingPoint.notifyListeners();
              selectedWhiteLands.notifyListeners();
              selectedLands.notifyListeners();
              selectedPointId.notifyListeners();
              bottomSheetSize.notifyListeners();
              showLegend.notifyListeners();

              viewHomeBottomSheet.value = false;
              viewHomeBottomSheet.notifyListeners();
              // bottomSheetSizeFraction.value = 0.05;
              bottomSheetSize.notifyListeners();
              bottomSheetSizeFraction.notifyListeners();
              /*  controller.setCameraPosition(
                CameraPositionMessage(
                  zoomValue: 17,
                  geoPoint: GeoPointMessage(
                    latitude: element.paths.first.latitude,
                    longitude: element.paths.first.longitude,
                  ),
                ),
              );*/
            },
          ),
        );
      }
      //  await controller.removeAllMarkers();
      unawaited(controller.addPolylines(polylines));
    }
  }

  void addPolygonWithPoint(List? pointList, int layerId) async {
    if (pointList != null && pointList.isNotEmpty) {
      final List<Polygon> polygons = [];
      for (var element in pointList) {
        polygons.add(
          Polygon(
            id: element.id.toString(),
            options: PolygonOptionsMessage(
              strokeWidth: 2,
              strokeColor: element.strokeColor != null
                  ? element.strokeColor
                  : 0x26000000,
              color: element.color != null ? element.color : 0xFF000000,
              contours: [element.paths],
            ),
            onTap: () {
              selectedPoint.value = element;
              selectedInvetmentPoint.value = null;
              selectedImtethalPoint.value = null;
              selectedWhiteLands.value = null;
              selectedDiggingPoint.value = null;
              showLegend.value = false;
              switch (gisSelectedLayer) {
                case GISMapLayers.BSAimtithalBuildingsCertificateL:
                  selectedImtethalPoint.value = element;

                case GISMapLayers.BSWhiteParcelS:
                  selectedWhiteLands.value = element;

                case GISMapLayers.CadastralParcelsLand:
                  selectedLands.value = element;
                default:
                  break;
              }
              selectedPointId.value = null;
              selectedImtethalPoint.notifyListeners();
              selectedDiggingPoint.notifyListeners();
              selectedWhiteLands.notifyListeners();
              selectedPointId.notifyListeners();
              bottomSheetSize.notifyListeners();
              selectedLands.notifyListeners();
              showLegend.notifyListeners();

              viewHomeBottomSheet.value = false;
              viewHomeBottomSheet.notifyListeners();
              //  bottomSheetSizeFraction.value = 0.05;
              bottomSheetSizeFraction.notifyListeners();
              bottomSheetSize.notifyListeners();

              print("ontap ${gisSelectedLayer}");
            },
          ),
        );
      }
      //await controller.removeAllMarkers();
      unawaited(controller.addPolygons(polygons));
    }
  }

  void selectLayers(Layers value) async {
    print("LAyer selected");
    await controller.removeAll();
    layerSelected.value = value;
    searchController.text = "";
    viewHomeBottomSheet.value = true;
    viewHomeBottomSheet.notifyListeners();

    bottomSheetSize.notifyListeners();
    bottomSheetSizeFraction.notifyListeners();
    gisSelectedLayer = GISMapLayers.values
            .firstWhereOrNull((element) => element.layerId == value.id) ??
        GISMapLayers.cityPlaces;

    if (gisSelectedLayer != GISMapLayers.cityPlaces) {
      selectedCategory.value = null;
    }
    selectedCategory.notifyListeners();

    notifyListeners();
    callSearch();
  }

  dynamic getMapCardData() {}
  void getGISData() {}

  void showLoading1() {
    isSearchLoading.value = true;
    isSearchLoading.notifyListeners();
  }

  void hideLoading1() {
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();
  }

  void goToLocation() async {
    Duration duration = CommonProperties.userLocationGIS == null
        ? Duration(seconds: 3)
        : Duration.zero;
    Timer(duration, () async {
      if (CommonProperties.userLocation == null) {
        controller.setCameraPosition(CameraPositionMessage(
            point: kingdomTower, zoom: 17, tilt: 45, bearing: 0));
      } else {
        GISResponse? gis = CommonProperties.userLocationGIS;
        GISParams? userLocation = CommonProperties.userLocation;
        if (gis == null) {
          showLoading1();
          var location = await sl<EntryPointCubit>().getUserLocationData();
          hideLoading1();
          gis = location?.$2;
          userLocation = location?.$1;
        }

        if (userLocation == null || gis == null) {
          controller.setCameraPosition(CameraPositionMessage(
              point: kingdomTower, zoom: 17, tilt: 45, bearing: 0));
        } else {
          if (gis.adminMunicipalityId == "004") {
            //    controller.setCameraPosition(CameraPositionMessage(
            //       point: kingdomTower, zoom: 17, tilt: 45, bearing: 0));
          } else if (gis.adminMunicipalityId == "006") {
            // controller.setCameraPosition(CameraPositionMessage(
            //     point: ithraa, zoom: 18, tilt: 45, bearing: 0));
          } else {
            controller.setCameraPosition(CameraPositionMessage(
                point: GeoPointMessage(
                    latitude: userLocation.y, longitude: userLocation.x),
                zoom: 18,
                tilt: 45,
                bearing: 0));
          }
        }
      }
    });
  }
}
