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
}
/*
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
  late MapBloc bloc = MapBloc(args: widget.args);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state.zonesStatus == BlocStatus.success) {
              state.zones?.forEach((zone) {
                Polygon p = Polygon(
                    id: zone.guid ?? "",
                    options: PolygonOptionsMessage(contours: [
                      zone.polygon?.rings?.firstOrNull
                          ?.map((r) =>
                              GeoPointMessage(latitude: r[1], longitude: r[0]))
                          .toList()
                    ]));

                controller.addPolygon(p);
              });
            }
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
                    UrbiMap(
                      onMapCreated: ((controller) {
                        print("on Map Created");
                        this.controller = controller;
                        initCameraPositionPoint();
                      }),
                    ),
                    if (state.gisDataStatus == BlocStatus.success)
                      Align(
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

  Future<void> _objectTapListener(TapEvent event) async {
    if (event is ObjectTapEvent) {
      await controller.setHighlighted([event.dgisObjectId.toMessage()]);

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
    try {
      print("HEREEE $controller");
      await controller
          .setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));

      controller.objectTapEvents.listen(
        _objectTapListener,
      );
      GeoPointMessage _kingdomTower =
          GeoPointMessage(latitude: 24.712301, longitude: 46.674175);

      await Permission.location.request();
      try {
        Position p = await Geolocator.getCurrentPosition();
        _kingdomTower =
            GeoPointMessage(latitude: p.latitude, longitude: p.longitude);
      } catch (ex) {}

      bloc.add(GetZonesEvent(
          lat: _kingdomTower.latitude, lon: _kingdomTower.longitude));

      await controller.moveCamera(
          CameraPositionMessage(
              point:
                  _kingdomTower /*GeoPointMessage(latitude: p.latitude, longitude: p.longitude)*/,
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
}
*/