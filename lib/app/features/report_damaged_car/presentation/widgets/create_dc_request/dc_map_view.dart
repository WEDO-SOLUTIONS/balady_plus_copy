import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as place;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/map_utils.dart';
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
            GoogleMapSection(
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
              onMapController: (GoogleMapController controller) {
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
                onSearchResult: (LatLng location) {
                  context.read<DCMapBloc>().mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target:
                                  LatLng(location.latitude, location.longitude),
                              zoom: 16.0),
                        ),
                      );
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

class GoogleMapSection extends StatefulWidget {
  final Function(LatLng position) updateMovedPosition;
  final Function(bool cameraIdle) onCameraIdle;
  final Function(GoogleMapController controller) onMapController;
  final LatLng? currentUserLocation;
  final LatLng? incidentLocation;
  final bool showRadius;

  const GoogleMapSection(
      {Key? key,
      required this.updateMovedPosition,
      required this.onCameraIdle,
      required this.currentUserLocation,
      required this.incidentLocation,
      required this.onMapController,
      required this.showRadius})
      : super(key: key);

  @override
  _GoogleMapSectionState createState() => _GoogleMapSectionState();
}

class _GoogleMapSectionState extends State<GoogleMapSection> {
  Set<Circle>? circles;
  double zoom = 5;

  @override
  void initState() {
    super.initState();
    zoom = widget.currentUserLocation != null ? 16 : 5;
  }

  @override
  Widget build(BuildContext context) {
    setMapCircle(widget.currentUserLocation);
    return GoogleMap(
      zoomControlsEnabled: false,
      // myLocationEnabled: true,
      circles: circles ?? {},
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(
          """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
        );
        widget.onMapController(controller);
      },
      myLocationButtonEnabled: false,
      //circles: circles != null ? circles : {},
      onCameraMove: (position) {
        widget.updateMovedPosition(position.target);
      },
      onCameraIdle: () {
        widget.onCameraIdle(true);
      },
      markers: {
        if (widget.currentUserLocation != null &&
            MapUtils.userLocationMarker != null)
          Marker(
              icon: MapUtils.userLocationMarker!,
              markerId: const MarkerId("userLocation"),
              position: widget.currentUserLocation!),
      },
      initialCameraPosition: CameraPosition(
          target: (widget.incidentLocation ?? widget.currentUserLocation) ??
              LatLng(24.76836756001484, 46.720988751704304),
          zoom: zoom),
    );
  }

  void setMapCircle(LatLng? location) {
    if (location != null && widget.showRadius) {
      circles = {
        Circle(
          circleId: const CircleId("1"),
          center: LatLng(location.latitude, location.longitude),
          radius: RemoteConfig.mapRadius,
          fillColor: const Color(0x8094cdd6),
          strokeWidth: 0,
        )
      };
    }
  }
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

  MapSearchSection(
      {Key? key,
      this.showBigPaddingScreen = false,
      required this.onSearchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: showBigPaddingScreen
          ? EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          _showPlaceSearch(context);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          alignment: Alignment.center,
          height: 52,
          decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: CustomTextWidget(
                  ("lbl_search_for_place").tr(),
                  fontColor: AppColor.black400,
                  fontWeight: AppFontWeight.medium,
                  fontSize: 17,
                  textAlign: TextAlign.start,
                )),
                Image.asset(
                  Constants.imgPath + 'mapSearch@3x.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPlaceSearch(BuildContext context) async {
    place.Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyA-Hs2J4hgwr1m5ScEnLwpZQpTUdtZfhMI",
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        language: "ar",
        components: [new place.Component(place.Component.country, "sa")]);

    final places = place.GoogleMapsPlaces(
        apiKey: "AIzaSyA-Hs2J4hgwr1m5ScEnLwpZQpTUdtZfhMI");
    places.getDetailsByPlaceId(p?.placeId ?? "").then((response) {
      var lat = response.result.geometry?.location.lat;
      var long = response.result.geometry?.location.lng;

      if (lat != null && long != null) {
        onSearchResult(LatLng(lat, long));
      }
    });
  }
}
