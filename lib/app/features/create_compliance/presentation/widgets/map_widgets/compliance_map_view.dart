import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:dgis_map/library.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:geolocator/geolocator.dart';


import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/map_utils.dart';
import '../../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../bloc/map_bloc/map_bloc.dart';
import 'map_address_card.dart';

class ComplinaceMapView extends StatefulWidget {
  final bool showSearch;
  final bool showSearchPaddingScreen;
  final bool showRadius;
  final bool readOnly;

  ComplinaceMapView(
      {this.showSearch = true,
      this.showSearchPaddingScreen = false,
      this.showRadius = false,
      this.readOnly = false});

  @override
  _ComplinaceMapViewState createState() => _ComplinaceMapViewState();
}

class _ComplinaceMapViewState extends State<ComplinaceMapView> {
  bool mapLoading = true;
  bool locationLoading = false;
  LatLng? movedPosition;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            // google map section
            UrbiMapSection(
              readOnly: widget.readOnly,
              currentUserLocation: state.userLocation?.getLatLng(),
              incidentLocation: state.location?.getLatLng() ??
                  state.userLocation?.getLatLng(),
              onCameraIdle: (bool isIdle) {
                if (widget.readOnly != true) {
                  if (movedPosition != null)
                    context
                        .read<MapBloc>()
                        .add(SelectLocationEvent(location: movedPosition!));
                }
              },
              updateMovedPosition: (LatLng p) {
                movedPosition = p;
              },
              onMapController: (DgisMapController controller) {
                context.read<MapBloc>().mapController = controller;
                context.read<MapBloc>().add(InitMapEvent());
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
                            .read<MapBloc>()
                            .add(GetCurentUserLocationEvent());
                    },
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(end: 12),
                      alignment: AlignmentDirectional.topEnd,
                      child: Image.asset(
                        IconPath.vdlocationIcon,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  //  address card
                  if (widget.readOnly != true)
                    MapAddressCard(
                      address: state.gisResponse?.getFullAddress(),
                      submitLocation: () {
                        context
                            .read<MapBloc>()
                            .add(GetGISDataEvent(params: state.location!));
                      },
                      isValidLocation: true,
                    ),
                ],
              ),
            ),
            // search section
            if (widget.showSearch && (widget.readOnly != true))
              MapSearchSection(
                showBigPaddingScreen: widget.showSearchPaddingScreen,
                currentUserLocation: state.userLocation?.getLatLng(),
                onSearchResult: (LatLng location) {

                  context.read<MapBloc>().mapController.moveCamera(
                    CameraPositionMessage(
                      point: GeoPointMessage(latitude: location.latitude, longitude: location.longitude),
                      zoom: 16.0,
                      tilt: 0.0,
                      bearing: 0.0,
                    ),
                    0.3, // duration
                    CameraAnimationTypeMessage.linear,
                  );


                  // context.read<MapBloc>().mapController.animateCamera(
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
}


