import 'dart:async';
import 'dart:io';

import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/pages/map_search/search_page.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/urbi_map.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../presentation/widgets/texts/custom_text_widget.dart';
import '../UrbiMap/search_provider.dart';
import '../UrbiMap/urbi_location_model.dart';

class UrbiMapSection extends StatefulWidget {
  final Function(LatLng position) updateMovedPosition;
  final Function(bool cameraIdle) onCameraIdle;
  final Function(DgisMapController controller) onMapController;
  final LatLng? currentUserLocation;
  final LatLng? incidentLocation;
  final bool showRadius;
  final bool readOnly;

  const UrbiMapSection(
      {Key? key,
        required this.updateMovedPosition,
        required this.onCameraIdle,
        required this.currentUserLocation,
        required this.incidentLocation,
        required this.onMapController,
        required this.showRadius,
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
          return ListTile(
            title: Text(model.fullName??""),
            subtitle: Text(model.type??""),
          );
        },
        onSelected: (model) {
          if (model.point != null) {
                 onSearchResult(LatLng(latitude: model.point!.lat!,longitude: model.point!.lon!));
               }
        },
      ),
    );


    //   Container(
    //   margin: showBigPaddingScreen
    //       ? EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40)
    //       : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //   alignment: Alignment.topCenter,
    //   child: GestureDetector(
    //     onTap: () {
    //
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(builder: (context) => const SearchPage(expansion: Expansion.expanded)),
    //       // );
    //      // Nav.push(SearchPage(expansion: Expansion.expanded));
    //     //  _showPlaceSearch(context);
    //     },
    //     child:
    //     Container(
    //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    //       alignment: Alignment.center,
    //       height: 52,
    //       decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Expanded(
    //                 child: CustomTextWidget(
    //                   ("lbl_search_for_place").tr(),
    //                   fontColor: AppColor.black400,
    //                   fontWeight: AppFontWeight.medium,
    //                   fontSize: 17,
    //                   textAlign: TextAlign.start,
    //                 )),
    //             Image.asset(
    //               IconPath.vdmapSearchIcon,
    //               height: 24,
    //               width: 24,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Future<List<UrbiLocationModel>> suggestionsCallback(String pattern,LatLng? location) async {

    UrbiSearchProvider? provider = sl();
   return provider.search(pattern,location??const LatLng(latitude:46.722667,longitude:24.694163));


  }


}






