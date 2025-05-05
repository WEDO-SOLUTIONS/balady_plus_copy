// import 'dart:async';
//
// import 'package:async/async.dart';
// import 'package:balady_plus/app/core/base/base_view_model.dart';
// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
// import 'package:balady_plus/app/features/map_page/data/model/states.dart';
// import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
// import 'package:collection/collection.dart';
// import 'package:dgis_map/library.dart';
// import 'package:balady_plus/model_map/lat_lng.dart';
// import 'package:flutter/widgets.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:mapness/features/routing/providers/routes.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../../core/dependency_injection/injection_container.dart';
// import '../../../../core/services/local/helpers.dart';
// import '../../../../core/services/local/navigation_services.dart';
// import '../../../../core/utils/app_analytics_events.dart';
// import '../../../events/domain/entities/search_events/search_events_item.dart';
// import '../../../events/domain/entities/search_events/search_events_params.dart';
// import '../../../events/domain/usecase/get_search_events.dart';
// import '../../../vd/domain/entities/gis/gis_params.dart';
// import '../../../vd/domain/entities/gis/gis_response.dart';
// import '../../constants/constants.dart';
// import '../../data/data_sources/point_layers_data.dart';
// import '../../data/enums/custom_search_category.dart';
// import '../../data/enums/map_enums.dart';
// import '../../data/model/building_compliance_certificate.dart';
// import '../../data/model/divisional_chart_boundaries.dart';
// import '../../data/model/excavations.dart';
// import '../../data/model/investment_details_response.dart';
// import '../../data/model/investment_sites.dart';
// import '../../data/model/layers.dart';
// import '../../data/model/rental_details_response.dart';
// import '../../data/model/requests/map_requests_params.dart';
// import '../../data/model/resturant_model.dart';
// import '../../data/model/white_lands.dart';
// import '../../data/repositories/layers_repositories.dart';
// import 'package:balady_plus/app/events_logs/balady_logs.dart';
//
// const int mil = 300;
// TextEditingController searchController = TextEditingController();
//
// class MapViewModel extends BaseViewModel {
//   final mapAppearanceMessage = ValueNotifier<MapAppearanceMessage?>(MapAppearanceMessage.day);
//
//   String? currentSearchSelectionId;
//   final draggableScrollableController = DraggableScrollableController();
//
//   final GeoPointMessage kingdomTower = GeoPointMessage(latitude: 24.712301, longitude: 46.674175);
//   final GeoPointMessage ithraa = GeoPointMessage(latitude: 26.336057, longitude: 50.120372);
//   Layers cityPlaces = Layers(id: 0, type: "", geometryType: "", name: "وصول أسهل", defaultVisibility: true);
//   static GeoRectMessage saRect = GeoRectMessage(
//     northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
//     southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
//   );
//   static List<GeoPointMessage> saRestrictions = [
//     GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
//     GeoPointMessage(latitude: 32.568765, longitude: 32.61185),
//     GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
//     GeoPointMessage(latitude: 15.506104, longitude: 56.694472),
//   ];
//
//   final LayersRepositories layersRepositories;
//
//   MapViewModel({required this.layersRepositories}) {
//     getMinLayers();
//
//     layerSelected.value = cityPlaces;
//   }
//
//   final selectedPointId = ValueNotifier<DgisObjectIdMessage?>(null);
//   final selectedPoint = ValueNotifier<PointLayersData?>(null);
//   final selectedPointCategory = ValueNotifier<SearchCategoryMessage?>(null);
//
//   ValueNotifier<IndoorState> indoorState = ValueNotifier(IndoorState.disabled());
//
//   ValueNotifier<SearchCategoryMessage?> selectedCategory = ValueNotifier(null);
//   ValueNotifier<CustomSearchCategory?> selectedCustomCategory = ValueNotifier(null);
//
//   ValueNotifier<List<SuggestMessage>?> suggests = ValueNotifier(null);
//
//   final layers = ValueNotifier<List<Layers>?>(null);
//
//   final layerSelected = ValueNotifier<Layers?>(null);
//   GISMapLayers gisSelectedLayer = GISMapLayers.cityPlaces;
//
// //////////////////////////////////////////////////////
//   CameraPositionMessage? _lastCameraPosition;
//   CameraPositionMessage? _lastRectPosition;
//   late DgisMapController controller;
//
//   final viewHomeBottomSheet = ValueNotifier(true);
//   final bottomSheetSize = ValueNotifier(0.5);
//   final bottomSheetSizeFraction = ValueNotifier(0.5);
//
//   final locationEnabledState = ValueNotifier(false);
//   final generalControlsState = ValueNotifier(false);
//   final initialized = ValueNotifier(false);
//
//   NaviZoomController get zoomController => controller.naviZoomController;
//
//   final _subscriptions = <StreamSubscription>[];
//
//   StreamSubscription? _debounce;
//   CancelableOperation? _searchOperation;
//   VisibleRectEvent? _lastHandledEvent;
//   double? _cameraTopPadding;
//   double oldZoom = 13;
//   bool refreshMap = true;
//   bool searchOnCameraMove = false;
//
//   //final selectedPoint = ValueNotifier<DgisObjectIdMessage?>(null);
//
//   final selectedDiggingPoint = ValueNotifier<Excavations?>(null);
//   final selectedInvetmentPoint = ValueNotifier<InvestmentSites?>(null);
//   final selectedResturantPoint = ValueNotifier<ResturantModel?>(null);
//   final selectedEventPoint = ValueNotifier<SearchEventsItem?>(null);
//   final selectedImtethalPoint = ValueNotifier<BuildingComplianceCertificate?>(null);
//
//   final selectedWhiteLands = ValueNotifier<WhiteLands?>(null);
//   final showLegend = ValueNotifier<bool?>(null);
//   final showComplianceLegend = ValueNotifier<bool?>(null);
//
//   final selectedLands = ValueNotifier<DivisionalChartBoundaries?>(null);
//
//   final isSearchLoading = ValueNotifier(false);
//
//   double zoomValue = 13;
//   bool updateMap = true;
//
//   Future<void> selectCategory({SearchCategoryMessage? category, CustomSearchCategory? custom}) async {
//     searchController.clear();
//     clearAllCards();
//     if (category == selectedCategory.value) {
//       _searchOperation?.cancel();
//       selectedCategory.value = null;
//     } else {
//       selectedCategory.value = category;
//       selectedCustomCategory.value = null;
//     }
//     if (custom == selectedCustomCategory.value) {
//       selectedCustomCategory.value = null;
//     } else {
//       selectedCustomCategory.value = custom;
//       selectedCategory.value = null;
//     }
//     selectedCategory.notifyListeners();
//     selectedCustomCategory.notifyListeners();
//     showLoading1();
//     await clearAll();
//
//     if (selectedCategory.value != null &&
//         selectedCategory.value != SearchCategoryMessage.restaurants &&
//         custom == null) {
//       performSearch(
//         queryText: selectedCategory.value!.displayName(),
//       );
//     } else if (selectedCategory.value == SearchCategoryMessage.restaurants) {
//       callSearch();
//     } else if (selectedCustomCategory.value == CustomSearchCategory.events) {
//       callEventsSearch();
//     }
//     hideLoading1();
//
//     selectedPointId.value = null;
//     selectedPointId.notifyListeners();
//
//     if (viewHomeBottomSheet.value == false) {
//       // bottomSheetSizeFraction.value = 0.05;
//
//       viewHomeBottomSheet.value = true;
//       viewHomeBottomSheet.notifyListeners();
//       bottomSheetSize.notifyListeners();
//       bottomSheetSizeFraction.notifyListeners();
//     }
//   }
//
//   Timer? _searchClearDebounce;
//
//   void clearSearch() {
//     _searchClearDebounce?.cancel();
//     _searchClearDebounce = Timer(const Duration(milliseconds: 500), () async {
//       await clearAll();
//       suggests.value = null;
//       searchController.text = "";
//     });
//   }
//
// //  late MapObjectManagerMessage mapObjectManager;
//
//   Future<void> performSearch({
//     required String queryText,
//     SearchCategoryMessage? category,
//     SearchQueryMessage? searchQuery,
//     bool showLoader = false,
//     bool moveCamera = true,
//   }) async {
//     _searchOperation?.cancel();
//     bottomSheetSizeFraction.value = 0.05;
//     bottomSheetSizeFraction.notifyListeners();
//     _searchOperation = CancelableOperation.fromFuture(
//       _performSearch(
//         queryText: queryText,
//         category: category,
//         searchQuery: searchQuery,
//         showLoader: showLoader,
//         moveCamera: moveCamera,
//       ),
//     );
//   }
//
//   Future<void> _performSearch({
//     required String queryText,
//     SearchCategoryMessage? category,
//     SearchQueryMessage? searchQuery,
//     bool showLoader = false,
//     bool moveCamera = true,
//   }) async {
//     try {
//       if (showLoader) {
//         await clearAll();
//
//         selectedCategory.value = null;
//         showLoading1();
//         selectedCategory.notifyListeners();
//
//         (double, double)? center = calculatePositionCenter(
//             _lastHandledEvent?.visibleRect.northEastLat,
//             _lastHandledEvent?.visibleRect.northEastLon,
//             _lastHandledEvent?.visibleRect.southWestLat,
//             _lastHandledEvent?.visibleRect.southWestLon);
//         if (center != null) {
//           await controller.moveCamera(
//             CameraPositionMessage(
//               point: GeoPointMessage(
//                 latitude: center.$1,
//                 longitude: center.$2,
//               ),
//               zoom: 13,
//               tilt: 0,
//               bearing: 0,
//             ),
//             1,
//             CameraAnimationTypeMessage.linear,
//           );
//         }
//       }
//       searchController.text = selectedCategory.value != null ? selectedCategory.value!.displayName() : queryText;
//
//       SearchResultMessage data = selectedCategory.value != null
//           ? await controller.searchByCategory(
//               selectedCategory.value!,
//               sortingType: SortingTypeMessage.byRelevance,
//               isOpenNow: false,
//               searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
//               spatialRestriction: saRestrictions,
//             )
//           : (searchQuery != null
//               ? await controller.searchByQuery(
//                   searchQuery,
//                   sortingType: SortingTypeMessage.byRelevance,
//                   spatialRestriction: saRestrictions,
//                 )
//               : await controller.search(
//                   queryText,
//                   categories: [
//                     SearchCategoryMessage.gasStations,
//                     SearchCategoryMessage.mousques,
//                     SearchCategoryMessage.restaurants,
//                   ],
//                   sortingType: SortingTypeMessage.byRelevance,
//                   isOpenNow: false,
//                   searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
//                   spatialRestriction: saRestrictions,
//                 ));
//
//       if (showLoader) hideLoading1();
//       if (_searchOperation?.isCanceled == true) {
//         if (data.firstPage != null) {
//           await controller.releasePage(data.firstPage!);
//         }
//         return;
//       }
//
//       searchOnCameraMove = false;
//       if (data.areaOfInterestPosition != null && moveCamera) {
//         await controller.moveCamera(
//           data.areaOfInterestPosition!,
//           1,
//           CameraAnimationTypeMessage.linear,
//         );
//       }
//
//       if (data.itemMarkerInfos != null) {
//         List<Marker> markers = [];
//
//         final iconPath = selectedCategory.value != null
//             ? selectedCategory.value!.markerIconName()
//             : "assets/maps/icons/ic_marker.svg";
//
//         for (final markerInfo in data.itemMarkerInfos!) {
//           final markerCategory = selectedCategory.value;
//           markers.add(Marker(
//             id: markerInfo?.objectId?.objectId.toString() ?? const Uuid().v4(),
//             options: MarkerOptionsMessage(
//               position: markerInfo!.geoPoint,
//               icon: SvgMarkerIcon(
//                 svgPath: iconPath,
//                 width: 24,
//               ),
//             ),
//             onTap: () async {
//               refreshMap = false;
//               await controller.moveCamera(
//                 CameraPositionMessage(
//                   point: GeoPointMessage(
//                     latitude: markerInfo.geoPoint.latitude,
//                     longitude: markerInfo.geoPoint.longitude,
//                   ),
//                   zoom: 17,
//                   tilt: 0,
//                   bearing: 0,
//                 ),
//                 1,
//                 CameraAnimationTypeMessage.linear,
//               );
//
//               refreshView();
//               selectedPointId.value = markerInfo.objectId;
//
//               selectedPointCategory.value = markerCategory;
//
//               Future.delayed(
//                 const Duration(milliseconds: 300),
//               );
//               refreshMap = true;
//             },
//           ));
//         }
//         if (_searchOperation?.isCanceled == true) {
//           if (data.firstPage != null) {
//             await controller.releasePage(data.firstPage!);
//           }
//           return;
//         }
//         await clearAll();
//         await controller.addMarkers(markers);
//       }
//       if (data.firstPage?.items != null) {
//         await controller.getDistanceTo(
//           _mapToDistanceRequest(
//             data.firstPage!.items.map((e) => e as DirectoryObjectMessage).toList(),
//           ),
//         );
//       }
//       if (data.firstPage != null) {
//         await controller.releasePage(data.firstPage!);
//       }
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     }
//   }
//
//   List<DistanceRequestMessage> _mapToDistanceRequest(List<DirectoryObjectMessage> values) => values
//       .where((element) => element.id != null)
//       .where((element) => element.markerPosition != null)
//       .map((e) => DistanceRequestMessage(
//             geoPoint: GeoPointMessage(
//               latitude: e.markerPosition!.latitude,
//               longitude: e.markerPosition!.longitude,
//             ),
//             dgisObjectId: e.id!,
//           ))
//       .toList();
//
//   Future<void> restorePosition() async {
//     if (_lastRectPosition != null) {
//       await controller.setCameraPosition(_lastRectPosition!);
//     }
//   }
//
//   Future<bool> initialize(DgisMapController controllerMap) async {
//     controller = controllerMap;
//     final result = await controller.initialize();
//     if (!result.wasInitialized) {
//       initialized.value = false;
//       return false;
//     }
//     _setupListeners();
//
//     // await controller.loadStyles(Constants.mapStyle);
//     await controller.overrideLocales(["ar-SA"]);
//
//     await controller.setZoomRestrictions(min: 5.5);
//     await controller.setBetterRouteSettings(BetterRouteSettings.prod);
//
//     try {
//       final permission = await Permission.location.request();
//       if (permission.isGranted) {
//         await controller.onLocationPermissionGranted();
//         await controller.toggleFollowState();
//
//         await controller.setCameraPosition(
//           CameraPositionMessage(
//             point: CommonProperties.userLocation != null
//                 ? GeoPointMessage(
//                     latitude: CommonProperties.userLocation?.lat ?? 0,
//                     longitude: CommonProperties.userLocation?.lon ?? 0,
//                   )
//                 : kingdomTower,
//             zoom: CommonProperties.userLocation != null ? 13 : 17,
//             tilt: CommonProperties.userLocation != null ? 0 : 45,
//             bearing: 0,
//           ),
//         );
//       } else {
//         await controller.toggleFollowState();
//         await controller.setCameraPosition(
//           CameraPositionMessage(
//             point: CommonProperties.userLocation != null
//                 ? GeoPointMessage(
//                     latitude: CommonProperties.userLocation?.lat ?? 0,
//                     longitude: CommonProperties.userLocation?.lon ?? 0,
//                   )
//                 : kingdomTower,
//             zoom: 17,
//             tilt: CommonProperties.userLocation != null ? 0 : 45,
//             bearing: 0,
//           ),
//         );
//       }
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//       await controller.onLocationPermissionGranted();
//       await controller.toggleFollowState();
//       await controller.setCameraPosition(
//         CameraPositionMessage(
//           point: CommonProperties.userLocation != null
//               ? GeoPointMessage(
//                   latitude: CommonProperties.userLocation?.lat ?? 0, longitude: CommonProperties.userLocation?.lon ?? 0)
//               : kingdomTower,
//           zoom: 17,
//           tilt: CommonProperties.userLocation != null ? 0 : 45,
//           bearing: 0,
//         ),
//       );
//     }
//
//     initialized.value = true;
//     generalControlsState.value = true;
//
//     retreiveMapState();
//
//     return true;
//   }
//
//   void onLocationTap() async {
//     await controller.toggleFollowState();
//   }
//
//   void onChangeTheme() async {
//     if (mapAppearanceMessage.value == MapAppearanceMessage.day) {
//       mapAppearanceMessage.value = MapAppearanceMessage.night;
//     } else {
//       mapAppearanceMessage.value = MapAppearanceMessage.day;
//     }
//     controller.setAppearance(mapAppearanceMessage.value!);
//
//     mapAppearanceMessage.notifyListeners();
//   }
//
//   void onLevelTap(IndoorLevel level) => unawaited(controller.selectIndoorLevel(level));
//
//   void setCameraTopPadding(double? topPadding) {
//     _cameraTopPadding = topPadding;
//   }
//
//   @override
//   void dispose() {
//     for (final sub in _subscriptions) {
//       unawaited(sub.cancel());
//     }
//     _subscriptions.clear();
//
//     locationEnabledState.dispose();
//
//     _suggestDebounce?.cancel();
//
//     draggableScrollableController.dispose();
//
//     unawaited(controller.dispose());
//   }
//
//   void showDialog() {
//     clearAllCards();
//     viewHomeBottomSheet.value = true;
//     viewHomeBottomSheet.notifyListeners();
//
//     //bottomSheetSizeFraction.value = 0.05;
//     bottomSheetSize.notifyListeners();
//     bottomSheetSizeFraction.notifyListeners();
//   }
//
//   void clearAllCards() {
//     selectedDiggingPoint.value = null;
//     selectedImtethalPoint.value = null;
//     selectedInvetmentPoint.value = null;
//     selectedResturantPoint.value = null;
//     selectedEventPoint.value = null;
//     selectedPointId.value = null;
//     selectedWhiteLands.value = null;
//     selectedLands.value = null;
//     showLegend.value = null;
//     showComplianceLegend.value = null;
//     selectedDiggingPoint.notifyListeners();
//     selectedImtethalPoint.notifyListeners();
//     selectedInvetmentPoint.notifyListeners();
//     selectedResturantPoint.notifyListeners();
//     selectedEventPoint.notifyListeners();
//     selectedPointId.notifyListeners();
//     selectedLands.notifyListeners();
//     showLegend.notifyListeners();
//     showComplianceLegend.notifyListeners();
//
//     selectedWhiteLands.notifyListeners();
//     controller.setHighlighted([]);
//   }
//
//   void _setupListeners() {
//     // add move carme map Listener
//     _subscriptions.add(
//       controller.visibleRectEvents.listen(
//         _visibleRectChangeListener,
//       ),
//     );
//
//     _subscriptions.add(
//       controller.cameraPositionEvents.listen(
//         _cameraPositionChangeListener,
//       ),
//     );
//
//     _subscriptions.add(
//       controller.cameraStateEvents.listen(
//         _cameraStateChangeListener,
//       ),
//     );
//
//     _subscriptions.add(
//       controller.objectTapEvents.listen(
//         _objectTapListener,
//       ),
//     );
//     _subscriptions.add(
//       controller.markerWithPhotoTapEvents.listen(
//         _onPanoramaTap,
//       ),
//     );
//
//     _subscriptions.add(
//       controller.indoorLevelNames.listen(
//         _indoorLevelsListener,
//       ),
//     );
//     _subscriptions.add(
//       controller.indoorActiveIndex.listen(
//         _indoorActiveLevelListener,
//       ),
//     );
//   }
//
//   void _indoorLevelsListener(IndoorLevelsEvent event) {
//     indoorState.value = event.levelNames.isEmpty
//         ? IndoorState.disabled()
//         : indoorState.value.copyWith(
//             hasLevels: true,
//             levelNames: event.levelNames,
//           );
//   }
//
//   void _indoorActiveLevelListener(IndoorActiveLevelEvent event) {
//     indoorState.value = indoorState.value.copyWith(
//       activeLevel: event.index,
//     );
//   }
//
//   void _cameraPositionChangeListener(CameraPositionMessage event) async {
//     _lastCameraPosition = event;
//   }
//
//   void _cameraStateChangeListener(CameraStateEvent event) async {
//     if (event.state == CameraState.fly) {
//       searchOnCameraMove = false;
//     } else if (event.state == CameraState.busy) {
//       searchOnCameraMove = true;
//     }
//   }
//
//   // When move camera map any change zoom in, zoom out ...
//   void _visibleRectChangeListener(VisibleRectEvent event) async {
//     if ((!await controller.containsRect(saRect, event.visibleRect.geoRectMessage()))) {
//       if (_lastRectPosition != null) {
//         await controller.setCameraPosition(_lastRectPosition!);
//       }
//     } else {
//       _lastRectPosition = _lastCameraPosition;
//     }
//     _lastHandledEvent = event;
//     if (searchOnCameraMove && selectedPointId.value == null) {
//       // start Timer when stop move camera  call search funcation
//       _startRequestTimer(event.visibleRect.zoom);
//     }
//   }
//
//   // When click on ayn object
//   Future<void> _objectTapListener(TapEvent event) async {
//     if (event is ObjectTapEvent) {
//       selectedPointId.value = event.dgisObjectId.toMessage();
//       selectedPointCategory.value = null;
//       viewHomeBottomSheet.value = false;
//       viewHomeBottomSheet.notifyListeners();
//       bottomSheetSize.notifyListeners();
//       bottomSheetSizeFraction.notifyListeners();
//       controller.setHighlighted([event.dgisObjectId.toMessage()]);
//     }
//   }
//
//   void _startRequestTimer(double oldZoom) {
//     if (refreshMap == false) return;
//
//     if (_debounce != null) {
//       unawaited(_debounce!.cancel());
//       _clearDebounce();
//     }
//     _debounce = Stream.fromFuture(
//       Future.delayed(
//         const Duration(milliseconds: 1000),
//       ),
//     ).listen((_) async {
//       this.oldZoom = oldZoom;
//       if (this.oldZoom.toInt() != zoomValue.toInt()) {
//         zoomValue = oldZoom;
//
//         if (selectedCustomCategory.value == null) callSearch();
//       }
//     });
//     _subscriptions.add(_debounce!);
//   }
//
//   void _clearDebounce() {
//     _subscriptions.remove(_debounce);
//     _debounce = null;
//   }
//
//   void _onPanoramaTap(MarkerWithPhotoTapEvent event) {
//     try {
//       final data = event.photoData;
//       unawaited(controller.moveCameraToSelectedPanorama());
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     }
//   }
//
//   void getLocationAndMoveCamera() async {
//     var latlng = await Helpers.getMapLocation();
//
//     if (latlng != null) {
//       await controller.setCameraPosition(
//         CameraPositionMessage(
//           zoom: 20,
//           tilt: 0,
//           bearing: 0,
//           point: GeoPointMessage(
//             latitude: 24.708194,
//             longitude: 46.673345,
//           ),
//         ),
//       );
//     }
//   }
//
//   callSearch() async {
//     // await clearAll();
//     if (selectedCategory.value != SearchCategoryMessage.restaurants && selectedCustomCategory.value == null) {
//       String? query = selectedCategory.value != null ? selectedCategory.value!.displayName() : searchController.text;
//       if (query.isNotEmpty) {
//         // showLoading1();
//
//         await performSearch(
//           queryText: query,
//           moveCamera: false,
//         );
//         // hideLoading1();
//       }
//       _clearDebounce();
//       hideLoading1();
//     } else if (selectedCategory.value == SearchCategoryMessage.restaurants) {
//       callResturantsSearch();
//
//       return;
//     } else if (selectedCustomCategory.value != null) {
//       // callEventsSearch();
//       return;
//     }
//
//     GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
//       (element) => element.layerId == layerSelected.value!.id,
//     );
//     if (gisLayer == GISMapLayers.cityPlaces) {
//       return;
//     } else {
//       callGISLayersSearch();
//     }
//   }
//
//   void callGISLayersSearch() async {
//     GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
//       (element) => element.layerId == layerSelected.value!.id,
//     );
//
//     showLoading1();
//     bottomSheetSize.notifyListeners();
//
//     if (gisLayer != null) {
//       List? pointList = await layersRepositories.getPointsInLayers(
//         params: MapRequestParams(
//           layer: gisLayer,
//           northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
//           northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
//           southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
//           southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
//         ),
//       );
//       switch (layerSelected.value!.geometryType) {
//         case 'esriGeometryPoint':
//           addMarkersWithPoint(pointList, layerSelected.value!.id);
//           break;
//         case 'esriGeometryPolyline':
//           addPolylineWithPoint(pointList, layerSelected.value!.id);
//           break;
//         case 'esriGeometryPolygon':
//           addPolygonWithPoint(pointList, layerSelected.value!.id);
//           break;
//       }
//     }
//     _clearDebounce();
//     hideLoading1();
//   }
//
//   callEventsSearch() async {
//     await clearAll();
//
//     GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
//       (element) => element.layerId == 13,
//     );
//     showLoading1();
//     bottomSheetSize.notifyListeners();
//
//     if (gisLayer != null) {
//       final searchEvents = GetSearchEvents(repository: sl());
//       final getEventsFailureOrSuccess = await searchEvents(SearchEventsParams(size: 1000, page: 1));
//
//       await getEventsFailureOrSuccess.fold((l) {}, (r) async {
//         final markers = r.items
//             ?.map(
//               (element) {
//                 if (element.getLocation() != null) {
//                   return Marker(
//                     id: element.id.toString(),
//                     options: MarkerOptionsMessage(
//                       position: GeoPointWithElevationMessage(
//                           elevation: 1,
//                           latitude: element.getLocation()!.latitude,
//                           longitude: element.getLocation()!.longitude),
//                       icon: SvgMarkerIcon(
//                         svgPath: Constants.icMarker,
//                         width: 30,
//                       ),
//                     ),
//                     onTap: () async {
//                       refreshMap = false;
//
//                       refreshView();
//                       selectedEventPoint.value = element;
//
//                       selectedEventPoint.value = element;
//                       selectedEventPoint.notifyListeners();
//
//                       await Future.delayed(
//                         const Duration(milliseconds: 300),
//                       );
//                       refreshMap = true;
//                     },
//                   );
//                 }
//                 return null;
//               },
//             )
//             .whereNotNull()
//             .toList();
//         //await controller.removeAllMarkers();
//         await clearAll();
//         controller.addMarkers(markers ?? []);
//       });
//     }
//     _clearDebounce();
//     hideLoading1();
//   }
//
//   callResturantsSearch() async {
//     Layers layer = Layers(id: 1, name: "مطاعم", defaultVisibility: true, type: "", geometryType: "esriGeometryPoint");
//
//     GISMapLayers? gisLayer = GISMapLayers.values.firstWhereOrNull(
//       (element) => element.layerId == layer.id,
//     );
//     showLoading1();
//     bottomSheetSize.notifyListeners();
//
//     List? pointList = await layersRepositories.getPointsInLayers(
//       params: MapRequestParams(
//         layer: gisLayer!,
//         northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
//         northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
//         southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
//         southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
//       ),
//     );
//
//     addMarkersWithPoint(pointList, layer.id);
//
//     _clearDebounce();
//     hideLoading1();
//   }
//
//   getPointDetails(int objectId) async {
//     showLoading1();
//
//     List? pointList = await layersRepositories.getPointDetailsInLayers(
//         params: MapRequestParams(
//       layer: gisSelectedLayer,
//       objectId: objectId,
//       northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
//       northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
//       southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
//       southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
//     ));
//
//     hideLoading1();
//
//     NavigationService.navigatorKey.currentState!
//         .pushNamed(RouteName.DiggingMapDetailsPage, arguments: pointList?.first);
//   }
//
//   Future<InvestmentDetailsResponse?> getInvestmentDetails(String id, String type) async {
//     showLoading1();
//
//     InvestmentDetailsResponse? data = await layersRepositories.getInvetmentDetails(id, type);
//
//     hideLoading1();
//     if (data != null) {
//       NavigationService.navigatorKey.currentState!.pushNamed(RouteName.investmentPage, arguments: data);
//     }
//
//     return data;
//   }
//
//   Future<RentalDetailsResponse?> getTempRentalDetails(String id, String type) async {
//     showLoading1();
//
//     RentalDetailsResponse? data = await layersRepositories.getTempRentalDetails(id, type);
//
//     hideLoading1();
//     if (data != null) {
//       NavigationService.navigatorKey.currentState!.pushNamed(RouteName.tempRentalPage, arguments: data);
//     }
//
//     return data;
//   }
//
//   void addOneMarkerWithMoveCamera(GeoPointWithElevationMessage markerPosition, DgisObjectIdMessage id) async {
//     selectedCategory.value = null;
//     selectedCategory.notifyListeners();
//     refreshMap = false;
//     await clearAll();
//     await controller.moveCamera(
//       CameraPositionMessage(
//         point: GeoPointMessage(
//           latitude: markerPosition.latitude,
//           longitude: markerPosition.longitude,
//         ),
//         zoom: 17,
//         tilt: 0,
//         bearing: 0,
//       ),
//       1,
//       CameraAnimationTypeMessage.linear,
//     );
//     controller.addMarkers([
//       Marker(
//         id: id.toString(),
//         options: MarkerOptionsMessage(
//           position: markerPosition,
//           icon: SvgMarkerIcon(
//             svgPath: Constants.icMarker,
//             width: 40,
//           ),
//         ),
//         onTap: () async {
//           refreshView();
//           selectedPointId.value = id;
//           selectedPointId.notifyListeners();
//         },
//       )
//     ]);
//
//     selectedPointId.value = id;
//     viewHomeBottomSheet.value = false;
//     selectedPointId.notifyListeners();
//     viewHomeBottomSheet.notifyListeners();
//     // await Future.delayed(const Duration(milliseconds: 300));
//     //  refreshMap = true;
//   }
//
//   void addOneMarkerToPosisiotnWithMoveCamera(GeoPointWithElevationMessage markerPosition) async {
//     await clearAll();
//     await controller.moveCamera(
//       CameraPositionMessage(
//         point: GeoPointMessage(
//           latitude: markerPosition.latitude,
//           longitude: markerPosition.longitude,
//         ),
//         zoom: 17,
//         tilt: 0,
//         bearing: 0,
//       ),
//       1,
//       CameraAnimationTypeMessage.linear,
//     );
//     controller.addMarkers([
//       Marker(
//         id: "ComplianceRoad",
//         options: MarkerOptionsMessage(
//           position: markerPosition,
//           icon: SvgMarkerIcon(
//             svgPath: Constants.icMarker,
//             width: 40,
//           ),
//         ),
//         onTap: () async {},
//       )
//     ]);
//
//     viewHomeBottomSheet.value = false;
//     selectedPointId.notifyListeners();
//     viewHomeBottomSheet.notifyListeners();
//   }
//
//   void addMarkersWithPoint(List? pointList, int layerId) async {
//     if (pointList != null && pointList.isNotEmpty) {
//       String iconPath = Constants.icMarkerRestaurant;
//       switch (layerId) {
//         case 0:
//           iconPath = Constants.icMarkerMosques;
//           break;
//         case 1:
//           iconPath = Constants.icMarkerRestaurant;
//           break;
//         case 2:
//           iconPath = Constants.icMarkerInvestmentSites;
//           break;
//         case 3:
//           iconPath = Constants.icMarkerCemeteries;
//           break;
//         case 4:
//           iconPath = Constants.icMarkerGardensParks;
//           break;
//         case 6:
//           iconPath = Constants.icMarkerGasStations;
//           break;
//       }
//       final markers = pointList.map(
//         (element) {
//           return Marker(
//             id: element.id.toString(),
//             options: MarkerOptionsMessage(
//               position: element.latLng,
//               icon: SvgMarkerIcon(
//                 svgPath: iconPath,
//                 width: 30,
//               ),
//             ),
//             onTap: () async {
//               refreshMap = false;
//               refreshView();
//               switch (gisSelectedLayer) {
//                 case GISMapLayers.Opportunities:
//                   selectedPoint.value = element;
//                   selectedInvetmentPoint.value = element;
//
//                 case GISMapLayers.Resturants:
//                   selectedPoint.value = element;
//                   selectedResturantPoint.value = element;
//                   break;
//                 case GISMapLayers.Events:
//                   selectedPoint.value = element;
//                   selectedEventPoint.value = element;
//
//                   break;
//                 default:
//                   break;
//               }
//
//               if (selectedCategory.value == SearchCategoryMessage.restaurants) // Temp code for resturant Layers
//               {
//                 selectedPoint.value = element;
//                 selectedResturantPoint.value = element;
//                 selectedResturantPoint.notifyListeners();
//               }
//
//               if (selectedCustomCategory.value == CustomSearchCategory.events) {
//                 selectedPoint.value = element;
//                 selectedEventPoint.value = element;
//                 selectedEventPoint.notifyListeners();
//               }
//               await Future.delayed(
//                 const Duration(milliseconds: 300),
//               );
//               refreshMap = true;
//             },
//           );
//         },
//       ).toList();
//       //await controller.removeAllMarkers();
//       await clearAll();
//
//       controller.addMarkers(markers);
//     }
//   }
//
//   void addPolylineWithPoint(List? pointList, int layerId) async {
//     if (pointList != null && pointList.isNotEmpty) {
//       final List<Polyline> polylines = [];
//       for (var element in pointList) {
//         for (List<GeoPointMessage> i in element.pathsGoogle) {
//           int id = int.parse(element.id);
//           String idPolyline = "${id.toString()}+$i";
//           polylines.add(
//             Polyline(
//               id: idPolyline,
//               options: PolylineOptionsMessage(points: i, width: 2, color: 0xff358281),
//               onTap: () {
//                 refreshView();
//                 switch (gisSelectedLayer) {
//                   case GISMapLayers.Digging:
//                     selectedDiggingPoint.value = element;
//
//                     break;
//
//                   case GISMapLayers.BSAimtithalBuildingsCertificateL:
//                     selectedImtethalPoint.value = element;
//
//                   case GISMapLayers.BSWhiteParcelS:
//                     selectedWhiteLands.value = element;
//
//                   default:
//                     break;
//                 }
//               },
//             ),
//           );
//         }
//       }
//       //  await controller.removeAllMarkers();
//       await clearAll();
//
//       unawaited(controller.addPolylines(polylines));
//     }
//   }
//
//   void addPolygonWithPoint(List? pointList, int layerId) async {
//     if (pointList != null && pointList.isNotEmpty) {
//       final List<Polygon> polygons = [];
//       for (var element in pointList) {
//         polygons.add(
//           Polygon(
//             id: element.id.toString(),
//             options: PolygonOptionsMessage(
//               strokeWidth: 2,
//               strokeColor: element.strokeColor ?? 0x26000000,
//               color: element.color ?? 0xFF000000,
//               contours: [element.paths],
//             ),
//             onTap: () {
//               refreshView();
//               selectedPoint.value = element;
//
//               switch (gisSelectedLayer) {
//                 case GISMapLayers.BSAimtithalBuildingsCertificateL:
//                   selectedImtethalPoint.value = element;
//
//                 case GISMapLayers.BSWhiteParcelS:
//                   selectedWhiteLands.value = element;
//
//                 case GISMapLayers.CadastralParcelsLand:
//                   selectedLands.value = element;
//                 default:
//                   break;
//               }
//             },
//           ),
//         );
//       }
//       //await controller.removeAllMarkers();
//       await clearAll();
//
//       unawaited(controller.addPolygons(polygons));
//     }
//   }
//
//   void selectLayers(Layers value) async {
//     await clearAll();
//
//     clearAllCards();
//     layerSelected.value = value;
//     layerSelected.notifyListeners();
//
//     showLegend.value = null;
//     showComplianceLegend.value = null;
//     layerSelected.value = value;
//     searchController.text = "";
//     viewHomeBottomSheet.value = true;
//     viewHomeBottomSheet.notifyListeners();
//
//     bottomSheetSize.notifyListeners();
//     showLegend.notifyListeners();
//     showComplianceLegend.notifyListeners();
//
//     bottomSheetSizeFraction.notifyListeners();
//     gisSelectedLayer =
//         GISMapLayers.values.firstWhereOrNull((element) => element.layerId == value.id) ?? GISMapLayers.cityPlaces;
//
//     if (gisSelectedLayer != GISMapLayers.cityPlaces) {
//       selectedCategory.value = null;
//     }
//     selectedCategory.notifyListeners();
//
//     notifyListeners();
//     callSearch();
//   }
//
//   dynamic getMapCardData() {}
//
//   void getGISData() {}
//
//   void showLoading1() {
//     isSearchLoading.value = true;
//     isSearchLoading.notifyListeners();
//   }
//
//   void hideLoading1() {
//     isSearchLoading.value = false;
//     isSearchLoading.notifyListeners();
//   }
//
//   void goToLocation() async {
//     Duration duration = CommonProperties.userLocationGIS == null ? const Duration(seconds: 3) : Duration.zero;
//     Timer(duration, () async {
//       if (CommonProperties.userLocation == null) {
//         controller.setCameraPosition(CameraPositionMessage(point: kingdomTower, zoom: 17, tilt: 45, bearing: 0));
//       } else {
//         GISResponse? gis = CommonProperties.userLocationGIS;
//         GISParams? userLocation = CommonProperties.userLocation;
//         if (gis == null) {
//           showLoading1();
//           var location = await sl<EntryPointCubit>().getUserLocationData();
//           hideLoading1();
//           gis = location?.$2;
//           userLocation = location?.$1;
//         }
//
//         if (userLocation == null || gis == null) {
//           controller.setCameraPosition(CameraPositionMessage(point: kingdomTower, zoom: 17, tilt: 45, bearing: 0));
//         } else {
//           if (gis.adminMunicipalityId == "004") {
//             //    controller.setCameraPosition(CameraPositionMessage(
//             //       point: kingdomTower, zoom: 17, tilt: 45, bearing: 0));
//           } else if (gis.adminMunicipalityId == "006") {
//             // controller.setCameraPosition(CameraPositionMessage(
//             //     point: ithraa, zoom: 18, tilt: 45, bearing: 0));
//           } else {
//             controller.setCameraPosition(CameraPositionMessage(
//                 point: GeoPointMessage(latitude: userLocation.y, longitude: userLocation.x),
//                 zoom: 18,
//                 tilt: 45,
//                 bearing: 0));
//           }
//         }
//       }
//     });
//   }
//
//   (double, double)? calculatePositionCenter(double? x1, double? y1, double? x2, double? y2) {
//     if (x1 == null || x2 == null || y1 == null || y2 == null) return null;
//     double centerX = (x1 + x2) / 2;
//     double centerY = (y1 + y2) / 2;
//     return (centerX, centerY);
//   }
//
//   void navigateToImtethal() async {
//     CommonFunctions.sendEventToAnalytics(AppEvents.navigateToBuildingComplianceFromHome);
//     if (layers.value?.isEmpty ?? true) await getMinLayers();
//     if (layers.value == null) {
//       CommonFunctions.showError("server_error_1".tr());
//
//       return;
//     }
//
//     viewHomeBottomSheet.value = false;
//     viewHomeBottomSheet.notifyListeners();
//
//     bottomSheetSizeFraction.value = 0.05;
//     bottomSheetSizeFraction.notifyListeners();
//
//     Timer(const Duration(milliseconds: 200), () async {
//       viewHomeBottomSheet.value = true;
//       viewHomeBottomSheet.notifyListeners();
//       selectLayers(layers.value!.firstWhere((element) => element.id == 7));
//
//       (double, double)? center = calculatePositionCenter(
//           _lastHandledEvent?.visibleRect.northEastLat,
//           _lastHandledEvent?.visibleRect.northEastLon,
//           _lastHandledEvent?.visibleRect.southWestLat,
//           _lastHandledEvent?.visibleRect.southWestLon);
//       if (center != null) {
//         await controller.moveCamera(
//             CameraPositionMessage(
//                 point: GeoPointMessage(
//                   latitude: center.$1,
//                   longitude: center.$2,
//                 ),
//                 zoom: 13,
//                 tilt: 0,
//                 bearing: 0),
//             1,
//             CameraAnimationTypeMessage.linear);
//       }
//     });
//
//     bottomSheetSize.value = 0;
//     bottomSheetSize.notifyListeners();
//   }
//
//   void navigateToCityScape() async {
//     CommonFunctions.sendEventToAnalytics(AppEvents.navigateToCityScapeFromHome);
//
//     viewHomeBottomSheet.value = false;
//     viewHomeBottomSheet.notifyListeners();
//
//     bottomSheetSizeFraction.value = 0.05;
//     bottomSheetSizeFraction.notifyListeners();
//
//     Timer(const Duration(milliseconds: 200), () async {
//       viewHomeBottomSheet.value = true;
//       viewHomeBottomSheet.notifyListeners();
//       await controller.moveCamera(
//         CameraPositionMessage(
//             point: GeoPointMessage(
//               latitude: 25.2522719,
//               longitude: 46.3872519,
//             ),
//             zoom: 17,
//             tilt: 45,
//             bearing: 0),
//         1,
//         CameraAnimationTypeMessage.linear,
//       );
//     });
//
//     bottomSheetSize.value = 0;
//     bottomSheetSize.notifyListeners();
//   }
//
//   Future<void> getMinLayers() async {
//     try {
//       layers.value = await layersRepositories.getMinLayers();
//       layers.value?.insert(0, cityPlaces);
//       layers.notifyListeners();
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     }
//   }
//
//   Future clearAll() async {
//     await controller.removeAllMarkers();
//     await controller.removeAllPolygons();
//     await controller.removeAllPolylines();
//     await controller.removeAll();
//     try {
//       await controller.removeAllHighlights();
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     }
//     return;
//   }
//
//   Timer? _suggestDebounce;
//
//   void updateSuggest({required String queryText}) {
//     _suggestDebounce?.cancel();
//     _suggestDebounce = Timer(const Duration(milliseconds: 500), () {
//       _searchOperation?.cancel();
//       _searchOperation = CancelableOperation.fromFuture(
//         _updateSuggest(
//           queryText: queryText,
//         ),
//       );
//     });
//   }
//
//   Future<void> _updateSuggest({required String queryText}) async {
//     if (queryText.isEmpty) {
//       suggests.value = null;
//       return;
//     }
//
//     List<SuggestedTypeMessage>? allowedResultTypes;
//     if (queryText.contains("منطقة") &&
//         queryText.contains("منطقه") &&
//         queryText.contains("محافظة") &&
//         queryText.contains("محافظه") &&
//         queryText.contains("مدينة") &&
//         queryText.contains("مدينه") &&
//         queryText.contains("حى") &&
//         queryText.contains("حي")) {
//       allowedResultTypes = [SuggestedTypeMessage.admDivCity];
//     } else {
//       allowedResultTypes = [
//         SuggestedTypeMessage.admDivCity,
//         SuggestedTypeMessage.attraction,
//         SuggestedTypeMessage.attribute,
//         SuggestedTypeMessage.branch,
//         SuggestedTypeMessage.building,
//         SuggestedTypeMessage.coordinates,
//         SuggestedTypeMessage.crossroad,
//         SuggestedTypeMessage.admDivDistrict,
//         SuggestedTypeMessage.parking,
//         SuggestedTypeMessage.admDivRegion,
//         SuggestedTypeMessage.road,
//         SuggestedTypeMessage.route,
//         SuggestedTypeMessage.station,
//         SuggestedTypeMessage.stationEntrance,
//         SuggestedTypeMessage.street,
//         SuggestedTypeMessage.text,
//       ];
//     }
//     showLoading1();
//
//     final result = await controller.fetchSuggest(
//       queryText,
//       allowedResultTypes: allowedResultTypes,
//       // categories: [
//       //   SearchCategoryMessage.gasStations,
//       //   SearchCategoryMessage.mousques,
//       //   SearchCategoryMessage.restaurants,
//       // ],
//       // sortingType: SortingTypeMessage.byRelevance,
//       // isOpenNow: false,
//       searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
//     );
//     hideLoading1();
//
//     suggests.value = result.suggests.whereNotNull().toList();
//   }
//
//   void moveCamera() async {
//     try {
//       final permission = await Permission.location.request();
//       if (permission.isGranted) {
//         await controller.onLocationPermissionGranted();
//       }
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//     }
//     await controller.toggleFollowState();
//
//     await controller.setCameraPosition(
//       CameraPositionMessage(
//         point: CommonProperties.userLocation != null
//             ? GeoPointMessage(
//                 latitude: CommonProperties.userLocation?.lat ?? 0, longitude: CommonProperties.userLocation?.lon ?? 0)
//             : kingdomTower,
//         zoom: CommonProperties.userLocation != null ? 13 : 17,
//         tilt: CommonProperties.userLocation != null ? 0 : 45,
//         bearing: 0,
//       ),
//     );
//   }
//
//   void setBottomSheetSize(double size) {
//     bottomSheetSizeFraction.value = size;
//     bottomSheetSizeFraction.notifyListeners();
//     bottomSheetSize.value = 0;
//     bottomSheetSize.notifyListeners();
//   }
//
//   // To retreive the map state when goes to the background.
//
// // To Save the map state when goes to the background.
//   void saveMapState() async {
//     _lastCameraPosition = await controller.getCameraPosition();
//   }
//
//   void retreiveMapState() {
//     if (_lastCameraPosition != null) {
//       controller.setCameraPosition(_lastCameraPosition!);
//     }
//     refreshMap = true;
//     oldZoom = _lastCameraPosition!.zoom;
//     callSearch();
//   }
//
//   void refreshView() {
//     clearAllCards();
//     viewHomeBottomSheet.value = false;
//     viewHomeBottomSheet.notifyListeners();
//     bottomSheetSize.notifyListeners();
//     bottomSheetSizeFraction.notifyListeners();
//   }
// }
