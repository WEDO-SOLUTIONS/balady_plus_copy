import 'dart:async';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:google_maps_webservice/places.dart' as place;
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        AppStyle,
        BlocRequestStatus,
        CommonFunctions,
        CommonProperties,
        IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomTextWidget,
        DrawIconBasedTypeWidget,
        ElevatedButtonWidget,
        MessageDialog;
import '../../municipal_advisor_exports.dart'
    show
        ActivityLocation,
        MunicipalAdvisorBloc,
        MunicipalAdvisorGetGisLocationEvent,
        MunicipalAdvisorSelectLocationEvent,
        MunicipalAdvisorState;

class LocationPage extends StatefulWidget {
  const LocationPage({
    super.key,
  });

  @override
  State<LocationPage> createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;

  static final CameraPosition defaultLocation = CameraPosition(
    target: CommonProperties.defaultLocation,
    zoom: 10,
  );
  //Varaibles
  LatLng? coordinates;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      bool isSuccess = await CommonFunctions.checkLocationSettings(context);
      if (isSuccess) {
        LatLng? latlng = await Helpers.getMapLocation();
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latlng!, zoom: 16.0),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MunicipalAdvisorBloc bloc =
        ModalRoute.of(context)!.settings.arguments as MunicipalAdvisorBloc;

    return Scaffold(
      body: BlocProvider.value(
        value: bloc,
        child: Builder(builder: (context) {
          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: defaultLocation,
                padding: const EdgeInsets.only(bottom: 60),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;
                  mapController.setMapStyle(
                    """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                  );
                },
                onCameraIdle: () async {
                  if (coordinates == null || !context.mounted) return;
                  context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorGetGisLocationEvent(
                          latLng: coordinates!,
                        ),
                      );
                },
                onCameraMove: (position) {
                  if (context.mounted) {
                    coordinates = position.target;
                  }
                },
              ),
              Positioned(
                bottom: (MediaQuery.of(context).size.height / 2) + 28,
                left: MediaQuery.of(context).size.width / 2 - 12,
                child: const DrawIconBasedTypeWidget(
                  icon: IconPath.marker,
                  iconSize: 25,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: BlocConsumer<MunicipalAdvisorBloc,
                        MunicipalAdvisorState>(
                      listenWhen: (previous, current) =>
                          previous.error != current.error,
                      listener: (_, state) async {
                        if (state.error.isNotEmpty) {
                          MessageDialog.showErrorNotification(msg: state.error);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            CustomTextWidget(
                              'location'.tr(),
                              textStyle: AppStyle.locationCardTitleTextStyle,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const DrawIconBasedTypeWidget(
                                  icon: IconPath.marker,
                                ),
                                const SizedBox(width: 4),
                                CustomTextWidget(
                                  state.gisResponse?.getFullAddress() ??
                                      'municipalAdvisorLocationHint'.tr(),
                                  textStyle:
                                      AppStyle.locationCardAddressTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButtonWidget.confirmLocation(
                              loading: state.status ==
                                  BlocRequestStatus.submissionGetLoading,
                              onPressed: state.gisResponse == null ||
                                      state.status ==
                                          BlocRequestStatus.submissionGetLoading
                                  ? null
                                  : () {
                                      if (coordinates == null) {
                                        return;
                                      }
                                      context.read<MunicipalAdvisorBloc>().add(
                                            MunicipalAdvisorSelectLocationEvent(
                                              location: ActivityLocation(
                                                gisResponse: state.gisResponse!,
                                                latLng: coordinates!,
                                              ),
                                            ),
                                          );
                                      Navigator.of(context).pop();
                                    },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              MapSearchSection(
                showBigPaddingScreen: true,
                onSearchResult: (LatLng location) {
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(location.latitude, location.longitude),
                          zoom: 16.0),
                    ),
                  );
                },
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 230),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // current location button
                    GestureDetector(
                      onTap: () async {
                        bool isSuccess =
                            await CommonFunctions.checkLocationSettings(
                                context);
                        if (isSuccess) {
                          LatLng? latlng = await Helpers.getMapLocation();
                          mapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(target: latlng!, zoom: 16.0),
                          ));
                        }
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
                  ],
                ),
              ),
            ],
          );
        }),
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
