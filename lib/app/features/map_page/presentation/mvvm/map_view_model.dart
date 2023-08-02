import 'dart:async';
import 'package:collection/collection.dart';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:uuid/uuid.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../constants/constants.dart';
import 'package:flutter/widgets.dart';

import '../../data/data_sources/point_layers_data.dart';
import '../../data/enums/map_enums.dart';
import '../../data/model/building_compliance_certificate.dart';
import '../../data/model/excavations.dart';
import '../../data/model/investment_details_response.dart';
import '../../data/model/investment_sites.dart';
import '../../data/model/layers.dart';
import '../../data/model/requests/map_requests_params.dart';
import '../../data/model/white_lands.dart';
import '../../data/repositories/layers_repositories.dart';

const int mil = 300;

class MapViewModel extends BaseViewModel {
  final LayersRepositories layersRepositories;

  MapViewModel({required this.layersRepositories});
  TextEditingController searchController = TextEditingController();
  final selectedPointId = ValueNotifier<DgisObjectIdMessage?>(null);
  final selectedPoint = ValueNotifier<PointLayersData?>(null);

  ValueNotifier<SearchCategoryMessage?> selectedCategory = ValueNotifier(null);

  final layerSelected = ValueNotifier<Layers?>(null);
  GISMapLayers? gisSelectedLayer;
//////////////////////////////////////////////////////

  late DgisMapController controller;

  final viewHomeBottomSheet = ValueNotifier(true);
  final bottomSheetSize = ValueNotifier(0.5);
  final locationEnabledState = ValueNotifier(false);
  final generalControlsState = ValueNotifier(false);
  final initialized = ValueNotifier(false);

  NaviZoomController get zoomController => controller.naviZoomController;

  final _subscriptions = <StreamSubscription>[];

  StreamSubscription? _debounce;
  VisibleRectEvent? _lastHandledEvent;
  double? _cameraTopPadding;

  //final selectedPoint = ValueNotifier<DgisObjectIdMessage?>(null);

  final selectedDiggingPoint = ValueNotifier<Excavations?>(null);
  final selectedInvetmentPoint = ValueNotifier<InvestmentSites?>(null);
  final selectedImtethalPoint =
      ValueNotifier<BuildingComplianceCertificate?>(null);

  final selectedWhiteLands = ValueNotifier<WhiteLands?>(null);
  final isSearchLoading = ValueNotifier(false);

  double zoomValue = 13;

  Future<void> selectCategory({required SearchCategoryMessage category}) async {
    if (category == selectedCategory.value) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    isSearchLoading.value = true;

    isSearchLoading.notifyListeners();
    performSearch(
      queryText: selectedCategory.value!.displayName(),
    );
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();

    selectedPointId.value = null;
    selectedPointId.notifyListeners();
  }

  Future<void> performSearch(
      {required String queryText, SearchCategoryMessage? category}) async {
    try {
      searchController.text = selectedCategory.value != null
          ? selectedCategory.value!.displayName()
          : queryText;

      SearchResultMessage data = selectedCategory.value != null
          ? await controller.searchByCategory(
              selectedCategory.value!,
              sortingType: SortingTypeMessage.byDistance,
              isOpenNow: false,
              searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
            )
          : await controller.search(
              queryText,
              sortingType: SortingTypeMessage.byDistance,
              isOpenNow: false,
              searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
            );
      await controller.removeAllMarkers();

      if (data.itemMarkerInfos != null) {
        List<Marker> markers = [];

        final iconPath = selectedCategory.value != null
            ? selectedCategory.value!.markerIconName()
            : "assets/maps/icons/ic_marker.svg";

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
            onTap: () {
              selectedPointId.value = markerInfo.objectId;
              selectedDiggingPoint.value = null;
              selectedInvetmentPoint.value = null;
              selectedImtethalPoint.value = null;
              selectedWhiteLands.value = null;
              if (viewHomeBottomSheet.value != false) {
                viewHomeBottomSheet.value = false;
                viewHomeBottomSheet.notifyListeners();
              }
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
    if (!result.wasInitialized) {
      initialized.value = false;
      return false;
    }

    _setupListeners();

    await controller.setCameraPosition(
      CameraPositionMessage(
        point: GeoPointMessage(
          latitude: 24.713520,
          longitude: 46.675230,
        ),
        zoom: 13,
        tilt: 0,
        bearing: 0,
      ),
    );

    final permission = await Permission.location.request();
    if (permission.isGranted) {
      await controller.onLocationPremissionGranted();
      geoLocator.Position position =
          await geoLocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geoLocator.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 13),
      );
      await controller.setCameraPosition(
        CameraPositionMessage(
          point: GeoPointMessage(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          zoom: 13,
          tilt: 0,
          bearing: 0,
        ),
      );
    }

    await controller.changeFollowState();

    // setLocale(const Locale("ar", "US"), TextDirection.ltr);
    await controller.loadStyles(Constants.mapStyle);
    await controller.overrideLocales(["ar-SA", "en-SA"]);
    // await controller.overrideLocales([localeState.value.locale]);

    await controller.setMarkerOptions(
      MarkerOptionsMessageOld(
        svgAsset: "assets/svg/ic_marker.svg",
        width: 30.0,
        height: 46.0,
        iconWidth: 24,
      ),
    );

    // await _checkLocationPermissions();
    // unawaited(controller.fetchLayers());

    initialized.value = true;
    generalControlsState.value = true;

    // final layers = finalawait LayersProvider.get().layers();
    // final ioLayer = layers.where((element) => element.id == 2).first;
    // esriIOLayerInfo = await LayersProvider.get().layerInfo(ioLayer);
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
    bottomSheetSize.value = 0.5;
    bottomSheetSize.notifyListeners();
    viewHomeBottomSheet.notifyListeners();
  }

  void clearAllCards() {
    selectedDiggingPoint.value = null;
    selectedImtethalPoint.value = null;
    selectedInvetmentPoint.value = null;
    selectedPointId.value = null;
    selectedWhiteLands.value = null;
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

    zoomValue = event.visibleRect.zoom;
    // start Timer when stop move camera  call search funcation
    _startRequestTimer();
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
    var latlng = await Helpers.getCurrentLocation();

    if (latlng != null)
      await controller.setCameraPosition(
        CameraPositionMessage(
          zoom: 13,
          tilt: 0,
          bearing: 0,
          point: GeoPointMessage(
            latitude: 24.729761968361412,
            longitude: 46.665576686472015,
          ),
        ),
      );
  }

  callSearch() async {
    print("search");
    if (selectedCategory.value != null) {
      controller.removeAll();

      performSearch(
        queryText: selectedCategory.value!.displayName(),
      );
    }

    if (layerSelected.value == null) return;

    GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
        (element) => element.layerId == layerSelected.value!.id);

    isSearchLoading.value = true;
    bottomSheetSize.notifyListeners();
    isSearchLoading.notifyListeners();
    if (gisLayer != null) {
      List? pointList = await layersRepositories.getPointsInLayers(
          params: MapRequestParams(
        layer: gisLayer,
        northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
        northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
        southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
        southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
      ));
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
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();
  }

  getPointDetails(int objectId) async {
    isSearchLoading.value = true;
    isSearchLoading.notifyListeners();

    List? pointList = await layersRepositories.getPointDetailsInLayers(
        params: MapRequestParams(
      layer: gisSelectedLayer!,
      objectId: objectId,
      northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
      northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
      southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
      southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
    ));

    print("Doneeee");
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();

    Navigator.pushNamed(NavigationService.navigatorKey.currentContext!,
        RouteName.DiggingMapDetailsPage,
        arguments: pointList?.first);
  }

  Future<InvestmentDetailsResponse?> getInvestmentDetails(
      String id, String type) async {
    isSearchLoading.value = true;
    isSearchLoading.notifyListeners();

    InvestmentDetailsResponse? data =
        await layersRepositories.getInvetmentDetails(id, type);

    print("Doneeee");
    print(data);
    isSearchLoading.value = false;
    isSearchLoading.notifyListeners();
    Navigator.pushNamed(NavigationService.navigatorKey.currentContext!,
        RouteName.InvestmentMapDetailsPage,
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
            onTap: () {
              print("on Tap");
              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedPoint.value = element;
                  selectedDiggingPoint.value = element;
                  selectedInvetmentPoint.value = null;
                  selectedImtethalPoint.value = null;
                  selectedWhiteLands.value = null;
                  break;

                case GISMapLayers.Opportunities:
                  selectedPoint.value = element;
                  selectedInvetmentPoint.value = element;
                  selectedDiggingPoint.value = null;
                  selectedImtethalPoint.value = null;
                  selectedWhiteLands.value = null;
                  break;
                case GISMapLayers.BSAimtithalBuildingsCertificateL:
                  print("Clickkkkked");
                  selectedPoint.value = element;
                  selectedImtethalPoint.value = element;

                  selectedInvetmentPoint.value = null;
                  selectedDiggingPoint.value = null;
                  selectedWhiteLands.value = null;

                case GISMapLayers.BSWhiteParcelS:
                  print("Clickkkkked");
                  selectedPoint.value = element;
                  selectedImtethalPoint.value = null;

                  selectedInvetmentPoint.value = null;
                  selectedDiggingPoint.value = null;
                  selectedWhiteLands.value = element;

                default:
                  break;
              }
              bottomSheetSize.notifyListeners();

              /* controller.setCameraPosition(
                CameraPositionMessage(
                  zoomValue: 17,
                  geoPoint: GeoPointMessage(
                    latitude: element.latLng.latitude,
                    longitude: element.latLng.longitude,
                  ),
                ),
              );*/
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
            id: id.toString(),
            options: PolylineOptionsMessage(
                points: element.paths, width: 4, color: 0xff358281),
            onTap: () {
              selectedPoint.value = element;

              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedPoint.value = element;
                  selectedDiggingPoint.value = element;
                  selectedInvetmentPoint.value = null;
                  selectedImtethalPoint.value = null;
                  selectedWhiteLands.value = null;
                  break;

                case GISMapLayers.Opportunities:
                  selectedPoint.value = element;
                  selectedInvetmentPoint.value = element;
                  selectedDiggingPoint.value = null;
                  selectedImtethalPoint.value = null;
                  selectedWhiteLands.value = null;
                  break;
                case GISMapLayers.BSAimtithalBuildingsCertificateL:
                  print("Clickkkkked");
                  selectedPoint.value = element;
                  selectedImtethalPoint.value = element;

                  selectedInvetmentPoint.value = null;
                  selectedDiggingPoint.value = null;
                  selectedWhiteLands.value = null;

                case GISMapLayers.BSWhiteParcelS:
                  print("Clickkkkked");
                  selectedPoint.value = element;
                  selectedImtethalPoint.value = null;

                  selectedInvetmentPoint.value = null;
                  selectedDiggingPoint.value = null;
                  selectedWhiteLands.value = element;

                default:
                  break;
              }
              bottomSheetSize.notifyListeners();

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
            id: id.toString(),
            options: PolygonOptionsMessage(
              strokeWidth: 2,
              strokeColor: element.color,
              color: element.color,
              contours: [element.paths],
            ),
            onTap: () {
              selectedPoint.value = element;

              switch (gisSelectedLayer) {
                case GISMapLayers.Digging:
                  selectedPoint.value = element;
                  selectedDiggingPoint.value = element;
                  selectedInvetmentPoint.value = null;
                  selectedImtethalPoint.value = null;
                  selectedWhiteLands.value = null;
                  break;

                case GISMapLayers.Opportunities:
                  selectedPoint.value = element;
                  selectedInvetmentPoint.value = element;
                  selectedDiggingPoint.value = null;
                  selectedImtethalPoint.value = null;
                  selectedWhiteLands.value = null;
                  break;
                case GISMapLayers.BSAimtithalBuildingsCertificateL:
                  print("Clickkkkked");
                  selectedPoint.value = element;
                  selectedImtethalPoint.value = element;

                  selectedInvetmentPoint.value = null;
                  selectedDiggingPoint.value = null;
                  selectedWhiteLands.value = null;

                case GISMapLayers.BSWhiteParcelS:
                  print("Clickkkkked");
                  selectedPoint.value = null;
                  selectedImtethalPoint.value = null;

                  selectedInvetmentPoint.value = null;
                  selectedDiggingPoint.value = null;
                  selectedWhiteLands.value = element;
                default:
                  break;
              }
              print("Done select ${gisSelectedLayer}");
              bottomSheetSize.notifyListeners();

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

  dynamic getMapCardData() {}
}
