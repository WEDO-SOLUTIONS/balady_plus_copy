/*import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';

import '/app/core/utils/utils_exports.dart';
import '/app/features/map/presentation/bloc/map_bloc.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
//import 'package:dgis_map/dgis_map_controller.dart';
//import 'package:dgis_map/library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import '/app/features/map/presentation/widgets/select_address.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
//import 'package:mapness/shared/ui/urbi_map.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const MapPage({super.key, required this.args});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapBloc bloc = MapBloc(args: widget.args);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state.zonesStatus == BlocStatus.success) {}
          },
          listenWhen: (previous, current) =>
              previous.zonesStatus != current.zonesStatus,
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: ("location_establihsment").tr(),
              ),
              body: Container(
                child: Stack(
                  children: [
                    const SizedBox(
                      height: 85,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Textfield(
                          title: 'ابحث هنا ..',
                          color: AppColor.white, 

                        ),
                      ),
                    ),
                    // if (state.gisDataStatus == BlocStatus.success)
                    const Align(
                        alignment: Alignment.bottomCenter,
                        child: SelectAddress()),
                    if (state.gisDataStatus == BlocStatus.loading ||
                        state.validatePointStatus == BlocStatus.loading)
                      Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: AppColor.statusAccentColor,
                          ))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}*/

/*
import 'package:flutter/material.dart';
import 'package:smart_advisor/app/features/map/presentation/bloc/map_bloc.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/activity_details_page_params.dart';

class MapPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const MapPage({super.key, required this.args});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //late DgisMapController controller;
  late MapBloc bloc = MapBloc(args: widget.args);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/

import 'dart:async';
import 'package:collection/collection.dart';

import 'package:async/async.dart';
import 'package:smart_advisor/app/features/documents/general_commercial_conditions.dart';

import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../widgets/tag_map.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/map/presentation/bloc/map_bloc.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import '/app/features/map/presentation/widgets/select_address.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:mapness/shared/ui/urbi_map.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const MapPage({super.key, required this.args});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late DgisMapController controller;
  TextEditingController searchController = TextEditingController();

  late MapBloc bloc = MapBloc(args: widget.args);
  ValueNotifier<List<SuggestMessage>?> suggests = ValueNotifier(null);
  CancelableOperation? _searchOperation;
  StreamSubscription? _debounce;
  VisibleRectEvent? _lastHandledEvent;
  CameraPositionMessage? _lastCameraPosition;
  CameraPositionMessage? _lastRectPosition;
  final _subscriptions = <StreamSubscription>[];

  Timer? _searchClearDebounce;
  static GeoRectMessage saRect = GeoRectMessage(
    northEast: GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
    southWest: GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
  );
  bool isLoading = false;
  void clearSearch() {
    _searchClearDebounce?.cancel();
    _searchClearDebounce = Timer(const Duration(milliseconds: 500), () async {
      await clearAll();
      suggests.value = null;
      searchController.text = "";
    });
  }

  Future clearAll() async {
    await controller.removeAllMarkers();
    await controller.removeAllPolygons();
    await controller.removeAllPolylines();
    await controller.removeAll();
    try {
      await controller.removeAllHighlights();
    } catch (error, stackTrace) {
      /* LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );*/
    }
    return;
  }

  Timer? _suggestDebounce;

  void updateSuggest({required String queryText}) {
    _suggestDebounce?.cancel();
    _suggestDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchOperation?.cancel();
      _searchOperation = CancelableOperation.fromFuture(
        _updateSuggest(
          queryText: queryText,
        ),
      );
    });
  }

  Future<void> _updateSuggest({required String queryText}) async {
    if (queryText.isEmpty) {
      suggests.value = null;
      return;
    }

    List<SuggestedTypeMessage>? allowedResultTypes;
    if (queryText.contains("منطقة") &&
        queryText.contains("منطقه") &&
        queryText.contains("محافظة") &&
        queryText.contains("محافظه") &&
        queryText.contains("مدينة") &&
        queryText.contains("مدينه") &&
        queryText.contains("حى") &&
        queryText.contains("حي")) {
      allowedResultTypes = [SuggestedTypeMessage.admDivCity];
    } else {
      allowedResultTypes = [
        SuggestedTypeMessage.admDivCity,
        SuggestedTypeMessage.attraction,
        SuggestedTypeMessage.attribute,
        SuggestedTypeMessage.branch,
        SuggestedTypeMessage.building,
        SuggestedTypeMessage.coordinates,
        SuggestedTypeMessage.crossroad,
        SuggestedTypeMessage.admDivDistrict,
        SuggestedTypeMessage.parking,
        SuggestedTypeMessage.admDivRegion,
        SuggestedTypeMessage.road,
        SuggestedTypeMessage.route,
        SuggestedTypeMessage.station,
        SuggestedTypeMessage.stationEntrance,
        SuggestedTypeMessage.street,
        SuggestedTypeMessage.text,
      ];
    }
    // showLoading1();

    final result = await controller.fetchSuggest(
      queryText,
      allowedResultTypes: allowedResultTypes,
      // categories: [
      //   SearchCategoryMessage.gasStations,
      //   SearchCategoryMessage.mousques,
      //   SearchCategoryMessage.restaurants,
      // ],
      // sortingType: SortingTypeMessage.byRelevance,
      // isOpenNow: false,
      //  searchRect: _lastHandledEvent?.visibleRect.geoRectMessage(),
    );
    // hideLoading1();

    suggests.value = result.suggests.whereNotNull().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            print("Listener $state");
            if (state.zonesStatus == BlocStatus.success) {
              state.zones?.forEach((zone) {
                Polygon p = Polygon(
                    id: zone.guid ?? "",
                    options: PolygonOptionsMessage(contours: [
                      zone.polygon?.rings?.firstOrNull
                              ?.map((r) => GeoPointMessage(
                                  latitude: r[1], longitude: r[0]))
                              .toList() ??
                          []
                    ]));

                controller.addPolygon(p);
              });
            }
            if (state.layerStatus == BlocStatus.success) {
              print("PolyLines success");
              addPolylineWithPoint(state.layerData);
            }
          },
          listenWhen: (previous, current) =>
              previous.zonesStatus != current.zonesStatus ||
              previous.layerStatus != current.layerStatus,
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: ("location_establihsment").tr(),
              ),
              body: Container(
                child: Stack(
                  children: [
                    UrbiMap(
                      onMapCreated: ((controller) {
                        print("on Map Created");
                        this.controller = controller;
                        initCameraPositionPoint();
                      }),
                    ),
                    Positioned(bottom: 300, left: 12, child: const TagMap()),

                    /* GestureDetector(
                      onTap: () {
                        //  MapSearchSheet
                      },
                      child: SizedBox(
                        height: 85,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Textfield(
                            // isEnabled: false,
                            title: 'ابحث هنا ..',
                            color: AppColor.white,
                            controller: searchController,
                            onSubmit: (String y) {
                              clearSearch();
                            },
                          ),
                        ),
                      ),
                    ),*/
                    if (state.gisDataStatus == BlocStatus.success)
                      const Align(
                          alignment: Alignment.bottomCenter,
                          child: SelectAddress()),
                    if (state.gisDataStatus == BlocStatus.loading ||
                        state.validatePointStatus == BlocStatus.loading ||
                        isLoading)
                      Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: AppColor.statusAccentColor,
                          ))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _objectTapListener(TapEvent event) async {
    if (event is ObjectTapEvent) {
      await controller.setHighlighted([event.dgisObjectId.toMessage()]);
      controller.removeAllMarkers();
      controller.addMarker(Marker(
          id: "1",
          options: MarkerOptionsMessage(
              position: GeoPointWithElevationMessage(
                latitude: event.latLng.latitude,
                longitude: event.latLng.longitude,
                elevation: 1,
              ),
              icon: MarkerIconMessage(
                  width: 23, svgPath: "assets/maps/icons/ic_marker.svg"))));
      bloc.add(ValidatePointEvent(
          lat: event.latLng.latitude, lon: event.latLng.longitude));
    }
  }

  Future<void> initCameraPositionPoint() async {
    // final controller = await ref.read(dgisControllerProvider.future);
    /* await controller.initialize();

    // Styles
    await controller.loadStyles('smart_advisor_assets/maps/styles/common-styles.2gis');

    // Appearance
    await controller.setZoomRestrictions(
      min: 5.5,
    );
    await controller.overrideLocales(['ar-SA']);
    await controller.setAppearance(
      MapAppearanceMessage.night,
    );
*/
    setState(() {
      isLoading = true;
    });
    try {
      await controller
          .setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));

      controller.objectTapEvents.listen(
        _objectTapListener,
      );

      _subscriptions.add(
        controller.visibleRectEvents.listen(
          _visibleRectChangeListener,
        ),
      );

      /* _subscriptions.add(
        controller.cameraPositionEvents.listen(
          _cameraPositionChangeListener,
        ),
      );*/

      GeoPointMessage kingdomTower =
          GeoPointMessage(latitude: 24.712301, longitude: 46.674175);

      try {
        Position p = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(seconds: 3));
        kingdomTower =
            GeoPointMessage(latitude: p.latitude, longitude: p.longitude);
      } catch (ex) {}

      setState(() {
        isLoading = false;
      });
      bloc.add(GetZonesEvent(
          lat: kingdomTower.latitude, lon: kingdomTower.longitude));

      await controller.moveCamera(
          CameraPositionMessage(
              point:
                  kingdomTower /*GeoPointMessage(latitude: p.latitude, longitude: p.longitude)*/,
              zoom: 15,
              tilt: 0,
              bearing: 0),
          1,
          CameraAnimationTypeMessage.linear);

      // ignore: avoid_catches_without_on_clauses, avoid_types_as_parameter_names, non_constant_identifier_names
    } catch (ex) {
      debugPrint('Error setting camera position point: $ex');
    }
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
    //  if (searchOnCameraMove && selectedPointId.value == null) {
    // start Timer when stop move camera  call search funcation
    _startRequestTimer(event.visibleRect.zoom);
    //  }
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
      //  this.oldZoom = oldZoom;
      // if (this.oldZoom.toInt() != zoomValue.toInt()) {
      //  zoomValue = oldZoom;

      bloc.add(GetLayersEvent(
        northEastLatitude: _lastHandledEvent!.visibleRect.northEastLat,
        northEastLongitude: _lastHandledEvent!.visibleRect.northEastLon,
        southWestLongitude: _lastHandledEvent!.visibleRect.southWestLon,
        southWestLlatitude: _lastHandledEvent!.visibleRect.southWestLat,
      ));
      //  if (selectedCustomCategory.value == null) callSearch();
      //   }
    });
    _subscriptions.add(_debounce!);
  }

  void _clearDebounce() {
    _subscriptions.remove(_debounce);
    _debounce = null;
  }

  void addPolylineWithPoint(List? pointList) async {
    print("PolyLines $pointList");
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
                  points: i, width: 2, color: 0xff358281),
              onTap: () {},
            ),
          );
        }
      }
      //  await controller.removeAllMarkers();
      await clearAll();
      print("PolyLines $polylines");
      unawaited(controller.addPolylines(polylines));
    }
  }
}
