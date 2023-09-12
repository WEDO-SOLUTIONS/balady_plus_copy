import 'dart:async';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:collection/collection.dart';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../../data/model/states.dart';
import '../../data/model/white_lands.dart';
import '../../data/repositories/layers_repositories.dart';

const int mil = 300;
TextEditingController searchController = TextEditingController();

class MapViewModel extends BaseViewModel {
  final GeoPointMessage kingdomTower = GeoPointMessage(
    latitude: 24.712301,
    longitude: 46.674175,
  );
  final GeoPointMessage ithraa = GeoPointMessage(
    latitude: 26.336057,
    longitude: 50.120372,
  );
  Layers cityPlaces = Layers(
    id: 0,
    type: "",
    geometryType: "",
    name: "وصول أسهل",
    defaultVisibility: true,
  );
  LatLng? currentTappedLocation;
  static GeoRectMessage saRect = GeoRectMessage(
    northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
    southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
  );

  final LayersRepositories layersRepositories;

  MapViewModel({required this.layersRepositories}) {
    getMinLayers();

    layerSelected.value = cityPlaces;
  }

  final selectedPointId = ValueNotifier<DgisObjectIdMessage?>(null);
  final selectedPoint = ValueNotifier<PointLayersData?>(null);
  ValueNotifier<IndoorState> indoorState =
      ValueNotifier(IndoorState.disabled());

  ValueNotifier<SearchCategoryMessage?> selectedCategory = ValueNotifier(null);

  final layers = ValueNotifier<List<Layers>?>(null);

  final layerSelected = ValueNotifier<Layers?>(null);
  GISMapLayers gisSelectedLayer = GISMapLayers.cityPlaces;

  CameraPositionMessage? _lastCameraPosition;
  CameraPositionMessage? _lastRectPosition;
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

  // double? _cameraTopPadding;
  double oldZoom = 13;
  bool refreshMap = true;

  //final selectedPoint = ValueNotifier<DgisObjectIdMessage?>(null);

  final selectedDiggingPoint = ValueNotifier<Excavations?>(null);
  final selectedInvetmentPoint = ValueNotifier<InvestmentSites?>(null);
  final selectedImtethalPoint =
      ValueNotifier<BuildingComplianceCertificate?>(null);

  final selectedWhiteLands = ValueNotifier<WhiteLands?>(null);
  final showLegend = ValueNotifier<bool?>(null);
  final showComplianceLegend = ValueNotifier<bool?>(null);

  final selectedLands = ValueNotifier<DivisionalChartBoundaries?>(null);

  final isSearchLoading = ValueNotifier(false);

  double zoomValue = 13;
  bool updateMap = true;

  CameraPositionMessage? currentCameraPosition;

  Future<void> selectCategory({required SearchCategoryMessage category}) async {
    searchController.clear();
    if (category == selectedCategory.value) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    showLoading1();
    await clearAll();

    if (selectedCategory.value != null) {
      performSearch(
        queryText: selectedCategory.value!.displayName(),
      );
    }
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

  Future<void> performSearch({
    required String queryText,
    SearchCategoryMessage? category,
    bool showLoader = false,
  }) async {
    try {
      if (showLoader) {
        await clearAll();

        selectedCategory.value = null;
        showLoading1();
        selectedCategory.notifyListeners();

        (double, double)? center = calculatePositionCenter(
          _lastHandledEvent?.visibleRect.northEastLat,
          _lastHandledEvent?.visibleRect.northEastLon,
          _lastHandledEvent?.visibleRect.southWestLat,
          _lastHandledEvent?.visibleRect.southWestLon,
        );
        if (center != null) {
          await controller.moveCamera(
            CameraPositionMessage(
              point: GeoPointMessage(
                latitude: center.$1,
                longitude: center.$2,
              ),
              zoom: 13,
              tilt: 0,
              bearing: 0,
            ),
            1,
            CameraAnimationTypeMessage.linear,
          );
        }
      }
      // searchController.text = selectedCategory.value != null
      //     ? selectedCategory.value!.displayName()
      //     : queryText;

      SearchResultMessage data = selectedCategory.value != null
          ? await controller.searchByCategory(
              selectedCategory.value!,
              sortingType: SortingTypeMessage.byRelevance,
              isOpenNow: false,
              searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
            )
          : await controller.search(
              queryText,
              categories: [
                SearchCategoryMessage.gasStations,
                SearchCategoryMessage.mousques
              ],
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
          markers.add(
            Marker(
              id: markerInfo?.objectId?.objectId.toString() ??
                  const Uuid().v4(),
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
                  CameraAnimationTypeMessage.linear,
                );

                refreshView();
                selectedPointId.value = markerInfo.objectId;
                selectedPointId.notifyListeners();
                Future.delayed(const Duration(milliseconds: 300));
                refreshMap = true;
              },
            ),
          );
        }
        await clearAll();
        await controller.addMarkers(markers);
      } else {
        showError('no_data'.tr());
      }
      if (data.firstPage != null) {
        await controller.releasePage(data.firstPage!);
      }
      //print(data);
    } catch (e) {
      //print(e);
    }
  }

  Future<void> restorePosition() async {
    if (_lastRectPosition != null) {
      await controller.setCameraPosition(_lastRectPosition!);
    }
  }

  Future<bool> initialize(DgisMapController controllerMap) async {
    controller = controllerMap;
    final result = await controller.initialize();
    if (!result.wasInitialized) {
      initialized.value = false;
      return false;
    }
    _setupListeners();

    await controller.loadStyles(Constants.mapStyle);
    await controller.overrideLocales(["ar-SA"]);
    await controller.setMarkerOptions(
      MarkerOptionsMessageOld(
        svgAsset: "assets/maps/icons/ic_marker.svg",
        width: 30.0,
        height: 46.0,
        iconWidth: 24,
      ),
    );
    await controller.setZoomRestrictions(min: 5.5);

    try {
      final permission = await Permission.location.request();
      //print("grfrsdcvdv $permission");
      if (permission.isGranted) {
        //print("grfrsdcvdv granted");
        await controller.onLocationPremissionGranted();
        //print("grfrsdcvdv granted 111");

        await controller.changeFollowState();

        await controller.setCameraPosition(
          CameraPositionMessage(
            point: CommonProperties.userLocation != null
                ? GeoPointMessage(
                    latitude: CommonProperties.userLocation?.lat ?? 0,
                    longitude: CommonProperties.userLocation?.lon ?? 0,
                  )
                : kingdomTower,
            zoom: CommonProperties.userLocation != null ? 13 : 17,
            tilt: CommonProperties.userLocation != null ? 0 : 45,
            bearing: 0,
          ),
        );
      } else {
        await controller.changeFollowState();
        await controller.setCameraPosition(
          CameraPositionMessage(
            point: CommonProperties.userLocation != null
                ? GeoPointMessage(
                    latitude: CommonProperties.userLocation?.lat ?? 0,
                    longitude: CommonProperties.userLocation?.lon ?? 0,
                  )
                : kingdomTower,
            zoom: 17,
            tilt: CommonProperties.userLocation != null ? 0 : 45,
            bearing: 0,
          ),
        );
      }
    } catch (ex) {
      await controller.changeFollowState();
      await controller.setCameraPosition(
        CameraPositionMessage(
          point: CommonProperties.userLocation != null
              ? GeoPointMessage(
                  latitude: CommonProperties.userLocation?.lat ?? 0,
                  longitude: CommonProperties.userLocation?.lon ?? 0)
              : kingdomTower,
          zoom: 17,
          tilt: CommonProperties.userLocation != null ? 0 : 45,
          bearing: 0,
        ),
      );
    }

    initialized.value = true;
    generalControlsState.value = true;

    retreiveMapState();

    return true;
  }

  void onLocationTap() async {
    unawaited(controller.changeFollowState());
  }

  void onLevelTap(IndoorLevel level) =>
      unawaited(controller.selectIndoorLevel(level));

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    _subscriptions.clear();

    locationEnabledState.dispose();

    unawaited(controller.dispose());
    super.dispose();
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
    showLegend.value = null;
    showComplianceLegend.value = null;
    selectedDiggingPoint.notifyListeners();
    selectedImtethalPoint.notifyListeners();
    selectedInvetmentPoint.notifyListeners();
    selectedPointId.notifyListeners();
    selectedLands.notifyListeners();
    showLegend.notifyListeners();
    showComplianceLegend.notifyListeners();
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

    _subscriptions.add(
      controller.cameraPositionEvents.listen(
        _cameraPositionChangeListener,
      ),
    );

    _subscriptions.add(
      controller.indoorLevelNames.listen(
        _indoorLevelsListener,
      ),
    );
    _subscriptions.add(
      controller.indoorActiveIndex.listen(
        _indoorActiveLevelListener,
      ),
    );

    /* searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus || searchFocusNode.hasPrimaryFocus) {
        viewHomeBottomSheet.value = false;
        viewHomeBottomSheet.notifyListeners();

        bottomSheetSizeFraction.value = bottomSheetSizeFraction.value >= 0.7
            ? bottomSheetSizeFraction.value
            : 0.7;
        bottomSheetSizeFraction.notifyListeners();

        Timer(const Duration(milliseconds: 10), () async {
          viewHomeBottomSheet.value = true;
          viewHomeBottomSheet.notifyListeners();
          searchFocusNode.requestFocus();
        });
      }
    });*/
  }

  void _indoorLevelsListener(IndoorLevelsEvent event) {
    indoorState.value = event.levelNames.isEmpty
        ? IndoorState.disabled()
        : indoorState.value.copyWith(
            hasLevels: true,
            levelNames: event.levelNames,
          );
  }

  void _indoorActiveLevelListener(IndoorActiveLevelEvent event) {
    indoorState.value = indoorState.value.copyWith(
      activeLevel: event.index,
    );
  }

  void _cameraPositionChangeListener(CameraPositionMessage event) async {
    _lastCameraPosition = event;
  }

  // When move camera map any change zoom in, zoom out ...
  void _visibleRectChangeListener(VisibleRectEvent event) async {
    if ((!await controller.containsRect(
        saRect, event.visibleRect.geoRectMessage()))) {
      if (_lastRectPosition != null) {
        await controller.setCameraPosition(_lastRectPosition!);
      }
    } else {
      _lastRectPosition = _lastCameraPosition;
    }
    _lastHandledEvent = event;
    // start Timer when stop move camera  call search funcation
    _startRequestTimer(event.visibleRect.zoom);
  }

  // When click on ayn object
  Future<void> _objectTapListener(TapEvent event) async {
    // when Click on Map hide ViewHomeBottomSheet if he is not hide
    print("tapped ddd ${event}");

    if (event is ObjectTapEvent) {
      if (event.levelId != null) {
        refreshView();
        selectedPointId.value = event.dgisObjectId.toMessage();
        selectedPointId.notifyListeners();
      }
      print("tapped ${event.latLng}");
      currentTappedLocation = event.latLng;
    }
  }

  void _startRequestTimer(double oldZoom) {
    if (refreshMap == false) return;
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
      // final data = event.photoData;
      //   //print(data);
      unawaited(controller.moveCameraToSelectedPanorama());
    } catch (e) {
      //print(e);
    }
  }

  void getLocationAndMoveCamera() async {
    var latlng = await Helpers.getMapLocation();

    if (latlng != null) {
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
  }

  callSearch() async {
    //print("search");
    await clearAll();

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

    if (layerSelected.value == null) return;
    //print("HEREE");
    GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
      (element) => element.layerId == layerSelected.value!.id,
    );
    if (gisLayer == GISMapLayers.cityPlaces) return;
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
        ),
      );
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
    _clearDebounce();
    hideLoading1();
  }

  getPointDetails(int objectId) async {
    showLoading1();

    List? pointList = await layersRepositories.getPointDetailsInLayers(
      params: MapRequestParams(
        layer: gisSelectedLayer,
        objectId: objectId,
        northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
        northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
        southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
        southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
      ),
    );

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
    if (data != null) {
      Navigator.pushNamed(
        NavigationService.navigatorKey.currentContext!,
        RouteName.investmentPage,
        arguments: data,
      );
    }
    return data;
  }

  Future<RentalDetailsResponse?> getTempRentalDetails(
      String id, String type) async {
    showLoading1();

    RentalDetailsResponse? data =
        await layersRepositories.getTempRentalDetails(id, type);

    hideLoading1();
    if (data != null) {
      Navigator.pushNamed(
        NavigationService.navigatorKey.currentContext!,
        RouteName.tempRentalPage,
        arguments: data,
      );
    }

    return data;
  }

  void addOneMarkerWithMoveCamera(GeoPointWithElevationMessage markerPosition,
      DgisObjectIdMessage id) async {
    selectedCategory.value = null;
    selectedCategory.notifyListeners();
    refreshMap = false;
    await clearAll();
    await controller.moveCamera(
      CameraPositionMessage(
        point: GeoPointMessage(
          latitude: markerPosition.latitude,
          longitude: markerPosition.longitude,
        ),
        zoom: 17,
        tilt: 0,
        bearing: 0,
      ),
      1,
      CameraAnimationTypeMessage.linear,
    );
    controller.addMarkers([
      Marker(
        id: id.toString(),
        options: MarkerOptionsMessage(
          position: markerPosition,
          icon: MarkerIconMessage(
            path: Constants.icMarker,
            width: 40,
          ),
        ),
        onTap: () async {
          refreshView();
          selectedPointId.value = id;
          selectedPointId.notifyListeners();
        },
      )
    ]);

    selectedPointId.value = id;
    viewHomeBottomSheet.value = false;
    selectedPointId.notifyListeners();
    viewHomeBottomSheet.notifyListeners();
    // await Future.delayed(const Duration(milliseconds: 300));
    //  refreshMap = true;
  }

  void addOneMarkerToPosisiotnWithMoveCamera(
      GeoPointWithElevationMessage markerPosition) async {
    await clearAll();
    await controller.moveCamera(
      CameraPositionMessage(
        point: GeoPointMessage(
          latitude: markerPosition.latitude,
          longitude: markerPosition.longitude,
        ),
        zoom: 17,
        tilt: 0,
        bearing: 0,
      ),
      1,
      CameraAnimationTypeMessage.linear,
    );
    controller.addMarkers([
      Marker(
        id: "ComplianceRoad",
        options: MarkerOptionsMessage(
          position: markerPosition,
          icon: MarkerIconMessage(
            path: Constants.icMarker,
            width: 40,
          ),
        ),
        onTap: () async {},
      )
    ]);

    viewHomeBottomSheet.value = false;
    selectedPointId.notifyListeners();
    viewHomeBottomSheet.notifyListeners();
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

              refreshView();
              switch (gisSelectedLayer) {
                case GISMapLayers.Opportunities:
                  selectedPoint.value = element;
                  selectedInvetmentPoint.value = element;
                  break;
                default:
                  break;
              }

              await Future.delayed(
                const Duration(milliseconds: 300),
              );
              refreshMap = true;
            },
          );
        },
      ).toList();
      //await controller.removeAllMarkers();
      await clearAll();

      controller.addMarkers(markers);
    }
  }

  void addPolylineWithPoint(List? pointList, int layerId) async {
    if (pointList != null && pointList.isNotEmpty) {
      final List<Polyline> polylines = [];
      for (var element in pointList) {
        for (List<GeoPointMessage> i in element.pathsGoogle) {
          int id = int.parse(element.id);
          String idPolyline = "${id.toString()}+$i";
          polylines.add(
            Polyline(
              id: idPolyline,
              options: PolylineOptionsMessage(
                points: i,
                width: 2,
                color: 0xff358281,
              ),
              onTap: () {
                refreshView();
                switch (gisSelectedLayer) {
                  case GISMapLayers.Digging:
                    selectedDiggingPoint.value = element;

                    break;

                  case GISMapLayers.BSAimtithalBuildingsCertificateL:
                    selectedImtethalPoint.value = element;
                  /* if (currentTappedLocation != null)
                      addOneMarkerToPosisiotnWithMoveCamera(
                          GeoPointWithElevationMessage(
                              latitude: currentTappedLocation!.latitude,
                              longitude: currentTappedLocation!.longitude,
                              elevation: 0));*/

                  case GISMapLayers.BSWhiteParcelS:
                    selectedWhiteLands.value = element;

                  default:
                    break;
                }
              },
            ),
          );
        }
      }
      //  await controller.removeAllMarkers();
      await clearAll();

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
              strokeColor: element.strokeColor ?? 0x26000000,
              color: element.color ?? 0xFF000000,
              contours: [element.paths],
            ),
            onTap: () {
              refreshView();
              selectedPoint.value = element;

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
            },
          ),
        );
      }
      //await controller.removeAllMarkers();
      await clearAll();

      unawaited(controller.addPolygons(polygons));
    }
  }

  void selectLayers(Layers value) async {
    await clearAll();

    clearAllCards();
    layerSelected.value = value;
    layerSelected.notifyListeners();

    showLegend.value = null;
    showComplianceLegend.value = null;
    layerSelected.value = value;
    searchController.text = "";
    viewHomeBottomSheet.value = true;
    viewHomeBottomSheet.notifyListeners();

    bottomSheetSize.notifyListeners();
    showLegend.notifyListeners();
    showComplianceLegend.notifyListeners();
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
        ? const Duration(seconds: 3)
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
                    latitude: 24.753021922291822, longitude: 46.72691177371778),
                zoom: 18,
                tilt: 45,
                bearing: 0));
          }
        }
      }
    });
  }

  (double, double)? calculatePositionCenter(
      double? x1, double? y1, double? x2, double? y2) {
    if (x1 == null || x2 == null || y1 == null || y2 == null) return null;
    double centerX = (x1 + x2) / 2;
    double centerY = (y1 + y2) / 2;
    return (centerX, centerY);
  }

  void navigateToImtethal() async {
    CommonFunctions.sendEventToAnalytics(
        AppEvents.navigateToBuildingComplianceFromHome);

    if (layers.value?.isEmpty ?? true) await getMinLayers();
    if (layers.value == null) {
      CommonFunctions.showError("server_error_1".tr());

      return;
    }

    viewHomeBottomSheet.value = false;
    viewHomeBottomSheet.notifyListeners();

    bottomSheetSizeFraction.value = 0.05;
    bottomSheetSizeFraction.notifyListeners();

    Timer(const Duration(milliseconds: 200), () async {
      viewHomeBottomSheet.value = true;
      viewHomeBottomSheet.notifyListeners();
      selectLayers(layers.value!.firstWhere((element) => element.id == 7));

      (double, double)? center = calculatePositionCenter(
          _lastHandledEvent?.visibleRect.northEastLat,
          _lastHandledEvent?.visibleRect.northEastLon,
          _lastHandledEvent?.visibleRect.southWestLat,
          _lastHandledEvent?.visibleRect.southWestLon);
      if (center != null) {
        await controller.moveCamera(
          CameraPositionMessage(
              point: GeoPointMessage(
                latitude: center.$1,
                longitude: center.$2,
              ),
              zoom: 13,
              tilt: 0,
              bearing: 0),
          1,
          CameraAnimationTypeMessage.linear,
        );
      }
    });

    bottomSheetSize.value = 0;
    bottomSheetSize.notifyListeners();
  }

  void navigateToCityScape() async {
    CommonFunctions.sendEventToAnalytics(AppEvents.navigateToCityScapeFromHome);

    viewHomeBottomSheet.value = false;
    viewHomeBottomSheet.notifyListeners();

    bottomSheetSizeFraction.value = 0.05;
    bottomSheetSizeFraction.notifyListeners();

    Timer(const Duration(milliseconds: 200), () async {
      viewHomeBottomSheet.value = true;
      viewHomeBottomSheet.notifyListeners();
      await controller.moveCamera(
        CameraPositionMessage(
            point: GeoPointMessage(
              latitude: 25.2522719,
              longitude: 46.3872519,
            ),
            zoom: 17,
            tilt: 45,
            bearing: 0),
        1,
        CameraAnimationTypeMessage.linear,
      );
    });

    bottomSheetSize.value = 0;
    bottomSheetSize.notifyListeners();
  }

  Future<void> getMinLayers() async {
    try {
      layers.value = await layersRepositories.getMinLayers();
      layers.value?.insert(0, cityPlaces);
      layers.notifyListeners();
    } catch (e) {
      //print(e);
    }
  }

  Future clearAll() async {
    await controller.removeAllMarkers();
    await controller.removeAllPolygons();
    await controller.removeAllPolylines();
    await controller.removeAll();
    return;
  }

  void moveCamera() async {
    try {
      final permission = await Permission.location.request();
      //print("grfrsdcvdv $permission");
      if (permission.isGranted) {
        //print("grfrsdcvdv granted");
        await controller.onLocationPremissionGranted();
        //print("grfrsdcvdv granted 111");
      }
    } catch (ex) {
      // print(ex);
    }
    await controller.changeFollowState();

    await controller.setCameraPosition(
      CameraPositionMessage(
        point: CommonProperties.userLocation != null
            ? GeoPointMessage(
                latitude: CommonProperties.userLocation?.lat ?? 0,
                longitude: CommonProperties.userLocation?.lon ?? 0)
            : kingdomTower,
        zoom: CommonProperties.userLocation != null ? 13 : 17,
        tilt: CommonProperties.userLocation != null ? 0 : 45,
        bearing: 0,
      ),
    );
  }

  void setBottomSheetSize(double size) {
    bottomSheetSizeFraction.value = size;
    bottomSheetSizeFraction.notifyListeners();
    bottomSheetSize.value = 0;
    bottomSheetSize.notifyListeners();
  }

// To Save the map state when goes to the background.
  void saveMapState() async {
    print("saveMapState");
    currentCameraPosition = await controller.getCameraPosition();
  }

// To retreive the map state when goes to the background.

  void retreiveMapState() {
    print("retreiveMapState $currentCameraPosition");

    if (currentCameraPosition != null)
      controller.setCameraPosition(currentCameraPosition!);
    refreshMap = true;
    oldZoom = currentCameraPosition!.zoom;
    callSearch();
  }

  void refreshView() {
    clearAllCards();
    viewHomeBottomSheet.value = false;
    viewHomeBottomSheet.notifyListeners();
    bottomSheetSize.notifyListeners();
    bottomSheetSizeFraction.notifyListeners();
  }
}
