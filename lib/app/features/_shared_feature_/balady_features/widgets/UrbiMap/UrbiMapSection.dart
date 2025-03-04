import 'dart:async';
import 'dart:io';

import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:mapness/shared/ui/urbi_map.dart';

import '../../../../../core/dependency_injection/injection_container.dart';

import '../../../../../core/utils/constants/constants.dart';

import 'search_provider.dart';
import 'urbi_location_model.dart';

class UrbiMapSection extends StatefulWidget {
  final Function(LatLng position) updateMovedPosition;
  final Function(bool cameraIdle) onCameraIdle;
  final Function(DgisMapController controller) onMapController;
  final LatLng? currentUserLocation;
  final LatLng? incidentLocation;
  final bool showRadius;
  final bool readOnly;
  final List<Marker>? marker;

  const UrbiMapSection(
      {Key? key,
        required this.updateMovedPosition,
        required this.onCameraIdle,
        required this.currentUserLocation,
        required this.incidentLocation,
        required this.onMapController,
        required this.showRadius,
        this.marker,
        this.readOnly = false})
      : super(key: key);

  @override
  _UrbiMapSectionState createState() => _UrbiMapSectionState();
}

class _UrbiMapSectionState extends State<UrbiMapSection> {
  // Set<Circle>? circles;
  double zoom = 5;
  StreamSubscription<CameraStateEvent>? _cameraStateListener;
  StreamSubscription<CameraPositionMessage>? _cameraPositionListener;


  @override
  void initState() {
    super.initState();

    zoom = (widget.currentUserLocation != null || widget.readOnly) ? 16 : 5;
  }

  @override
  Widget build(BuildContext context) {
    // setMapCircle(widget.currentUserLocation);




    return  UrbiMap(
        onMapCreated: (DgisMapController controller) {
          // Setup listeners and initialize map
          // context.read<Step2ActivityDataExportCubit>().mapController = controller;
        if(widget.currentUserLocation != null) {
          controller.setCameraPosition(
            CameraPositionMessage(
              point: GeoPointMessage(
                  latitude: widget.currentUserLocation!.latitude,
                  longitude: widget.currentUserLocation!.longitude),
              zoom: 16.0,
              tilt: 0.0,
              bearing: 0.0,
            ),
          );
        }

        if(widget.marker != null && widget.marker!.isNotEmpty) {
          controller.addMarkers(widget.marker!);
        }

          widget.onMapController(controller);

          _cameraStateListener = controller.cameraStateEvents.listen((event) {
            if (event.state == CameraState.free) {
              // Handle camera idle state
              widget.onCameraIdle(true);

            }
          });
          _cameraPositionListener = controller.cameraPositionEvents.listen((event) {
            // Handle camera position updates
            widget.updateMovedPosition(LatLng(latitude: event.point.latitude,longitude: event.point.longitude));
          });
        }
    );



  }

//   void setMapCircle(LatLng? location) {
//     if (location != null && widget.showRadius) {
//       circles = {
//         Circle(
//           circleId: const CircleId("1"),
//           center: LatLng(location.latitude, location.longitude),
//           radius: RemoteConfig.mapRadius,
//           fillColor: const Color(0x8094cdd6),
//           strokeWidth: 0,
//         )
//       };
//     }
//   }
}

class PinMarkerSection extends StatelessWidget {
  bool isLocationAllowed = true;
  PinMarkerSection({this.isLocationAllowed = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          (isLocationAllowed)
              ? const Center()
              : Container(
            color: Colors.white,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(bottom: 85),
            child: Text(
              ('location_not_allowed_map').tr(),
              textScaleFactor: 1,
            ),
          ),
          Container(
            margin: Platform.isAndroid
                ? const EdgeInsets.only(bottom: 25)
                : const EdgeInsets.only(bottom: 30),
            height: 30.0,
            width: 15.0,
            child: Image.asset(
              isLocationAllowed
                  ? "assets/images/marker@3x.png"
                  : "assets/images/redPinMarker@3x.png",
            ),
          ),
        ],
      ),
    );
  }
}

class MapSearchSection extends StatelessWidget {
  final showBigPaddingScreen;
  Function(LatLng location) onSearchResult;
  final LatLng? currentUserLocation;


  MapSearchSection(
      {Key? key,
        this.showBigPaddingScreen = false,
        required this.onSearchResult,
        required this.currentUserLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
      alignment: Alignment.center,
      height: 52,
      decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
      child: TypeAheadField<UrbiLocationModel>(
        errorBuilder: (context, error) =>  Text('errors_server_error_1'.tr()),
        emptyBuilder: (context) =>  Text("noSearchFounded".tr()),
        suggestionsCallback: (search) => suggestionsCallback(search,currentUserLocation),
        builder: (context, controller, focusNode) {
          return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'lbl_search_for_place'.tr(),
              )
          );
        },
        itemBuilder: (context, model) {

          String? area="";
          String? region = "";
          if( model.admDiv != null &&  model.admDiv!.isNotEmpty) {


            List? districtArea = model.admDiv!.where((item) => item.type == "district_area").toList();

            if(districtArea.isNotEmpty) {
              area = districtArea.first.name;
            }

            List? districtRegion = model.admDiv!.where((item) => item.type == "region").toList();

            if(districtRegion.isNotEmpty) {
              region = districtRegion.first.name;
            }

          }
          String Type = "";
          if(model.type == "street") {
            Type= "${model.type!},";
          }
          return Column(
            children: [
              ListTile(
                title: Text( Type + (model.searchAttributes?.suggestedText??"")),
                subtitle: Text("${area!},${region}"),
              ),
              Divider(thickness: 1,)
            ],
          );
        },

        onSelected: (model) {
          if (model.point != null) {
                 onSearchResult(LatLng(latitude: model.point!.lat!,longitude: model.point!.lon!));
               }
        },
      ),
    );



  }

  Future<List<UrbiLocationModel>> suggestionsCallback(String pattern,LatLng? location) async {

    UrbiSearchProvider? provider = sl();
   return provider.search(pattern,location??const LatLng(latitude:24.694163,longitude:46.722667));


  }


}






