import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:geolocator/geolocator.dart';


import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/map_utils.dart';
import '../../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../vd/presentation/widgets/map_address_card.dart';
import '../../blocs/create_dc_request/map_bloc/dc_map_bloc.dart';

class DCMapView extends StatefulWidget {
  final bool showSearch;
  final bool showSearchPaddingScreen;
  final bool showRadius;

  DCMapView(
      {this.showSearch = true,
      this.showSearchPaddingScreen = false,
      this.showRadius = false});

  @override
  _DCMapViewState createState() => _DCMapViewState();
}

class _DCMapViewState extends State<DCMapView> {
  bool mapLoading = true;
  bool locationLoading = false;
  LatLng? movedPosition;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DCMapBloc, DCMapState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            // google map section
            UrbiMapSection(
              currentUserLocation: state.userLocation?.getLatLng(),
              incidentLocation: state.location?.getLatLng() ??
                  state.userLocation?.getLatLng(),
              onCameraIdle: (bool isIdle) {
                if (movedPosition != null)
                  context
                      .read<DCMapBloc>()
                      .add(SelectLocationEvent(location: movedPosition!));
              },
              updateMovedPosition: (LatLng p) {
                movedPosition = p;
              },
              onMapController: (DgisMapController controller) {
                context.read<DCMapBloc>().mapController = controller;
                context.read<DCMapBloc>().add(InitMapEvent());
              },
              showRadius: widget.showRadius,
            ),

            PinMarkerSection(
              isLocationAllowed: state.isLocationAllowed ?? true,
            ),
            // current location button and address card
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // current location button
                  GestureDetector(
                    onTap: () async {
                      bool isSuccess =
                          await CommonFunctions.checkLocationSettings(context);
                      if (isSuccess)
                        context
                            .read<DCMapBloc>()
                            .add(GetCurentUserLocationEvent());
                    },
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(end: 12),
                      alignment: AlignmentDirectional.topEnd,
                      child: Image.asset(
                        Constants.imgPath + 'location1@3x.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  //  address card
                  MapAddressCard(
                    address: state.gisResponse?.adminMunicipalityName,
                    submitLocation: () {
                      context
                          .read<DCMapBloc>()
                          .add(GetGISDataEvent(params: state.location!));
                    },
                    isValidLocation: true,
                  ),
                ],
              ),
            ),
            // search section
            if (widget.showSearch)
              MapSearchSection(
                showBigPaddingScreen: widget.showSearchPaddingScreen,
                currentUserLocation: state.userLocation?.getLatLng(),
                onSearchResult: (LatLng location) {

                  context.read<DCMapBloc>().mapController.moveCamera(
                    CameraPositionMessage(
                      point: GeoPointMessage(latitude: location.latitude, longitude: location.longitude),
                      zoom: 16.0,
                      tilt: 0.0,
                      bearing: 0.0,
                    ),
                    0.3, // duration
                    CameraAnimationTypeMessage.linear,
                  );

                  // context.read<DCMapBloc>().mapController.animateCamera(
                  //       CameraUpdate.newCameraPosition(
                  //         CameraPosition(
                  //             target:
                  //                 LatLng(location.latitude, location.longitude),
                  //             zoom: 16.0),
                  //       ),
                  //     );


                },
              ),
          ],
        );
      },
    );
  }

  /*void setMapLoading() {
    EasyLoading.show();
    Timer(const Duration(milliseconds: 1300), () async {
      getCurrentUserLocation();
      EasyLoading.dismiss();
    });

    if (Platform.isAndroid) {
      Timer(const Duration(milliseconds: 1300), () async {
        setState(() {
          // mapLoading = false;
        });
      });
    } else {
      setState(() {
        //  mapLoading = false;
      });
    }
  }*/
}

