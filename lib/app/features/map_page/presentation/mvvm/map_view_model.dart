import 'dart:async';
import 'package:collection/collection.dart';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/data/data_sources/point_layers_data.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/data/model/investment_sites.dart';
import 'package:balady_plus/app/features/map_page/data/model/layers.dart';
import 'package:balady_plus/app/features/map_page/data/repositories/layers_repositories.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;

import '../../constants/constants.dart';
import 'package:flutter/widgets.dart';

import '../../data/enums/map_enums.dart';
import '../../data/model/requests/map_requests_params.dart';

const int mil = 300;

class MapViewModel extends BaseViewModel {
  final LayersRepositories layersRepositories;

  MapViewModel({required this.layersRepositories});

  final selectedPoint = ValueNotifier<PointLayersData?>(null);

  final selectedDiggingPoint = ValueNotifier<Excavations?>(null);

  late DgisMapController controller;

  final viewHomeBottomSheet = ValueNotifier(false);

  final locationEnabledState = ValueNotifier(false);
  final generalControlsState = ValueNotifier(false);
  final initialized = ValueNotifier(false);

  final isSearchLoading = ValueNotifier(false);

  NaviZoomController get zoomController => controller.naviZoomController;

  final _subscriptions = <StreamSubscription>[];

  StreamSubscription? _debounce;

  double zoomValue = 13;

  Future<bool> initialize(DgisMapController controllerMap) async {
    controller = controllerMap;
    final result = await controller.initialize();
    if (!result.wasInitialized) {
      initialized.value = false;
      return false;
    }

    _setupListeners();

    await controller.setCameraPosition(
      CameraPositionMessage(
        zoomValue: zoomValue,
        geoPoint: GeoPointMessage(
          latitude: 24.713520,
          longitude: 46.675230,
        ),
      ),
    );

    getLocationAndMoveCamera();

    if (kDebugMode) {
      // setLocale(const Locale("ar", "US"), TextDirection.ltr);
      await controller.loadStyles(Constants.mapStyle);
      await controller.overrideLocales(["ar-SA"]);
      // await controller.overrideLocales([localeState.value.locale]);
    }
    await controller.setMarkerOptions(
      MarkerOptionsMessageOld(
        svgAsset: "assets/svg/ic_marker.svg",
        width: 30.0,
        height: 46.0,
        iconWidth: 24,
      ),
    );
    initialized.value = true;
    generalControlsState.value = true;
    return true;
  }

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
  }

  // When click on ayn object
  Future<void> _objectTapListener(TapEvent event) async {
    // when Click on Map hide ViewHomeBottomSheet if he is not hide
    if (viewHomeBottomSheet.value != false) {
      viewHomeBottomSheet.value = false;
      viewHomeBottomSheet.notifyListeners();
    }

    //
  }

  //////////////////////////////////////////////  search
  TextEditingController searchController = TextEditingController();
  final layerSelected = ValueNotifier<Layers?>(null);
  GISMapLayers? gisSelectedLayer;

  Future<void> performSearch({required String queryText}) async {
    try {
      searchController.text = queryText;
      List<ObjectInfoMessage> data = await controller.search(
        queryText,
        sortingType: SortingTypeMessage.byDistance,
        searchMarker:
            MarkerIconMessage(path: Constants.icMarkerRestaurant, width: 30),
        isOpenNow: true,
      );
      // if (data.isNotEmpty) {
      //   final responseDistance = await controller.getDistanceTo(
      //     _mapToDistanceRequest(data),
      //   );
      //   print(responseDistance);
      // }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  ////////////////////////////////////////////////////////////////
  late VisibleRectEvent _lastHandledEvent;

  // When move camera map any change zoom in, zoom out ...
  void _visibleRectChangeListener(VisibleRectEvent event) {
    _lastHandledEvent = event;
    zoomValue = event.visibleRect.zoom;
    // start Timer when stop move camera  call search funcation
    if (layerSelected.value != null) {
      _startRequestTimer();
    }
  }

  void _startRequestTimer() {
    if (_debounce != null) {
      unawaited(_debounce!.cancel());
      _clearDebounce();
    }
    _debounce = Stream.fromFuture(
      Future.delayed(
        const Duration(milliseconds: 1000),
      ),
    ).listen((_) async {
      callSearch();
    });
    _subscriptions.add(_debounce!);
  }

  void _clearDebounce() {
    _subscriptions.remove(_debounce);
    _debounce = null;
  }

  //////////////////////////////////////////

  callSearch() async {
    // await performSearch(queryText: searchController.text);
    isSearchLoading.value = true;
    isSearchLoading.notifyListeners();
    Layers layer = layerSelected.value!;
    GISMapLayers? gisLayer = GISMapLayers.values
        .firstWhereOrNull((element) => element.layerId == layer.id);
    List? pointList = await layersRepositories.getPointsInLayers(
        params: MapRequestParams(
      layer: gisLayer!,
      northEastLatitude: _lastHandledEvent.visibleRect.northEastLat,
      northEastLongitude: _lastHandledEvent.visibleRect.northEastLon,
      southWestLongitude: _lastHandledEvent.visibleRect.southWestLon,
      southWestLlatitude: _lastHandledEvent.visibleRect.southWestLat,
    ));
    switch (layer.geometryType) {
      case 'esriGeometryPoint':
        addMarkersWithPoint(pointList, layer.id);
        break;
      case 'esriGeometryPolyline':
        addPolylineWithPoint(pointList, layer.id);
        break;
      case 'esriGeometryPolygon':
        addPolygonWithPoint(pointList, layer.id);
        break;
    }
    print("Doneeee");
    _clearDebounce();
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();
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
            id: int.parse(element.id),
            options: MarkerOptionsMessage(
              position: element.latLng,
              icon: MarkerIconMessage(
                path: iconPath,
                width: 30,
              ),
            ),
            onTap: () {
              selectedPoint.value = element;
              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedDiggingPoint.value = element;
                  break;
                default:
                  break;
              }
              controller.setCameraPosition(
                CameraPositionMessage(
                  zoomValue: 17,
                  geoPoint: GeoPointMessage(
                    latitude: element.latLng.latitude,
                    longitude: element.latLng.longitude,
                  ),
                ),
              );
            },
          );
        },
      ).toList();
      await controller.removeAll();
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
            id: id,
            options: PolylineOptionsMessage(
                points: element.paths, width: 4, color: 0xff358281),
            onTap: () {
              selectedPoint.value = element;
              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedDiggingPoint.value = element;
                  break;
                default:
                  break;
              }
              controller.setCameraPosition(
                CameraPositionMessage(
                  zoomValue: 17,
                  geoPoint: GeoPointMessage(
                    latitude: element.paths.first.latitude,
                    longitude: element.paths.first.longitude,
                  ),
                ),
              );
            },
          ),
        );
      }
      await controller.removeAll();
      unawaited(controller.addPolylines(polylines));
    }
  }

  void addPolygonWithPoint(List? pointList, int layerId) async {
    if (pointList != null && pointList.isNotEmpty) {
      final List<Polygon> polygons = [];
      for (var element in pointList) {
        int id = int.parse(element.id);
        polygons.add(
          Polygon(
            id: id,
            options: PolygonOptionsMessage(
              strokeWidth: 2,
              strokeColor: -16711936,
              color: const Color.fromRGBO(23, 123, 244, 95).value,
              contours: [element.paths],
            ),
            onTap: () {
              selectedPoint.value = element;

              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedDiggingPoint.value = element;
                  break;
                default:
                  break;
              }
              print("Done select");
              controller.setCameraPosition(
                CameraPositionMessage(
                  zoomValue: 17,
                  geoPoint: GeoPointMessage(
                    latitude: element.paths.first.latitude,
                    longitude: element.paths.first.longitude,
                  ),
                ),
              );
            },
          ),
        );
      }
      await controller.removeAll();
      unawaited(controller.addPolygons(polygons));
    }
  }

  void selectLayers(Layers value) async {
    layerSelected.value = value;
    gisSelectedLayer = gisSelectedLayer = GISMapLayers.values
        .firstWhereOrNull((element) => element.layerId == value.id);
    callSearch();
  }

  void getLocationAndMoveCamera() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      // await controller.onLocationPremissionGranted();
      geoLocator.Position position =
          await geoLocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geoLocator.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      await controller.setCameraPosition(
        CameraPositionMessage(
          zoomValue: zoomValue,
          geoPoint: GeoPointMessage(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        ),
      );
    }
  }

  dynamic getMapCardData() {}
}
