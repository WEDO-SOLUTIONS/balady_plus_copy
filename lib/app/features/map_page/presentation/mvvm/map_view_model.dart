import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/map_page/data/model/layers.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;

import '../../constants/constants.dart';
import 'package:flutter/widgets.dart';

const int mil = 300;

class MapViewModel extends BaseViewModel {


  MapViewModel(// required this.authService,
      // required this.setLocale,
      );

  TextEditingController searchController = TextEditingController();
  final subLayerSelected = ValueNotifier<SubLayers?>(null);



  Future<void> performSearch({required String queryText}) async {
    try {
      searchController.text = queryText;
      List<ObjectInfoMessage> data = await controller.search(
        queryText,
        sortingType: SortingTypeMessage.byDistance,
        isOpenNow: true,
      );
      if (data.isNotEmpty) {
        final responseDistance = await controller.getDistanceTo(
          _mapToDistanceRequest(data),
        );
        print(responseDistance);
      }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  List<DistanceRequestMessage> _mapToDistanceRequest(
          List<ObjectInfoMessage> values) =>
      values
          .where((element) => element.dgisObjectId != null)
          .where((element) => element.markerPosition != null)
          .map((e) => DistanceRequestMessage(
                geoPoint: e.markerPosition!.point,
                dgisObjectId: e.dgisObjectId!,
              ))
          .toList();

  ////////////////////////////////////////////////////////////////

  final selectedPointId = ValueNotifier<DgisObjectIdMessage?>(null);

  late DgisMapController controller;

  final viewHomeBottomSheet = ValueNotifier(true);

  final locationEnabledState = ValueNotifier(false);
  final generalControlsState = ValueNotifier(false);
  final initialized = ValueNotifier(false);

  NaviZoomController get zoomController => controller.naviZoomController;

  final _subscriptions = <StreamSubscription>[];

  StreamSubscription? _debounce;
  VisibleRectEvent? _lastHandledEvent;
  double? _cameraTopPadding;

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
        zoomValue: 13,
        geoPoint: GeoPointMessage(
          latitude: 24.713520,
          longitude: 46.675230,
        ),
      ),
    );


    final permission = await Permission.location.request();
    if (permission.isGranted) {
      await controller.onLocationPremissionGranted();
      geoLocator.Position position = await geoLocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geoLocator.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 13),
      );
      await controller.setCameraPosition(
        CameraPositionMessage(
          zoomValue: 13,
          geoPoint: GeoPointMessage(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        ),
      );
    }

    if (kDebugMode) {
      // setLocale(const Locale("ar", "US"), TextDirection.ltr);
      await controller.loadStyles(Constants.mapStyle);
      await controller.overrideLocales(["ar-SA"]);
      // await controller.overrideLocales([localeState.value.locale]);
    }

    await controller.setMarkerOptions(
      MarkerOptionsMessage(
        svgAsset: "assets/svg/ic_marker.svg",
        width: 30.0,
        height: 46.0,
        iconWidth: 24,
      ),
    );

    // await _checkLocationPermissions();
    unawaited(controller.fetchLayers());

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
    _startRequestTimer();
  }

  // When click on ayn object
  Future<void> _objectTapListener(TapEvent event) async {
    // when Click on Map hide ViewHomeBottomSheet if he is not hide
    if (viewHomeBottomSheet.value != false) {
      viewHomeBottomSheet.value = false;
      viewHomeBottomSheet.notifyListeners();
    }

    //
    switch (controller.activeLayerState.value.layer) {
      case BusinessLayers.tourism:
        if (event is ObjectTapEvent) {
          selectedPointId.value = DgisObjectIdMessage(
            objectId: event.dgisObjectId.objectId,
            entranceId: event.dgisObjectId.entranceId,
          );
        }
        return;
      case BusinessLayers.idle:
        // if (event is IdleTapEvent) unawaited(_handleIdleEvent(event));
        return;
      case BusinessLayers.io:
        // if (event is IoTapEvent) unawaited(_handleIoEvent(event));
        return;
      case BusinessLayers.panoramas:
        // handles by [_onPanoramaTap]
        return;
    }
  }

  void _startRequestTimer() {
    if (_debounce != null) {
      unawaited(_debounce!.cancel());
      _clearDebounce();
    }
    _debounce = Stream.fromFuture(
      Future.delayed(
        const Duration(milliseconds: 500),
      ),
    ).listen((_) async {
      await performSearch(queryText: searchController.text);
      _clearDebounce();
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
}
