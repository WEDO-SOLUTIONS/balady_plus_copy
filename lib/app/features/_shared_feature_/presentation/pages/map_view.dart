// import 'dart:async';
// import 'dart:io';
// import 'dart:math' show cos, sqrt, asin;
// import 'package:balady_plus/app/core/utils/common_functions.dart';
// import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:dgis_map/dgis_map_controller.dart';
// import 'package:dgis_map/library.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:geolocator/geolocator.dart';
//
//
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../core/base/base_view_model.dart';
// import '../../../../core/utils/constants/constants.dart';
// import '../../../../core/utils/map_utils.dart';
// import '../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
// import '../../../transaction_inquiry/presentation/core/models/selected_location.dart';
// import '../../../transaction_inquiry/presentation/core/services/customer_voice_repository.dart';
// import '../../../vd/presentation/widgets/map_address_card.dart';
// import '../../balady_features/widgets/UrbiMap/UrbiMapSection.dart';
// import '../widgets/texts/custom_text_widget.dart';
// import 'package:balady_plus/app/events_logs/balady_logs.dart';
//
// class MapView extends StatefulWidget {
//   final SelectedLocation selectedLocation;
//   final Function onLocationChanged;
//   final bool showSearch;
//   final bool showSearchPaddingScreen;
//   final bool showRadius;
//
//   MapView({
//     required this.selectedLocation,
//     required this.onLocationChanged,
//     this.showSearch = true,
//     this.showSearchPaddingScreen = false,
//     this.showRadius = false,
//   });
//
//   @override
//   _MapViewState createState() => _MapViewState();
// }
//
// class _MapViewState extends State<MapView> {
//   GisLocationResult? gisLocationResult;
//   SelectedLocation? selectedLocation;
//
//   // late BitmapDescriptor userCurrentLocationMarker;
//   bool mapLoading = true;
//   bool locationLoading = false;
//
//   // late Set<Circle> circles;
//   bool isLocationAllowed = true;
//
//   LatLng? movedPosition;
//   // late String _mapStyle;
//
//   // CameraPosition initalCameralLocation = CameraPosition(
//   //     zoom: 4, target: LatLng(24.694203971954554, 46.81549530431028));
//
//   bool showPreviousSelectedLocation = false;
//   String? gisAddress;
//   late DgisMapController mapController;
//   bool isFirstLoad = true;
//   @override
//   void initState() {
//     super.initState();
//
//     selectedLocation = widget.selectedLocation.copyWith();
//     gisAddress = selectedLocation?.selectedLocationAddress;
//     if (selectedLocation?.selectedLocation != null) {
//       showPreviousSelectedLocation = true;
//     }
//     setMapLoading();
//
//     // setMapLoading();
//     // setupMap();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         // google map section
//         UrbiMapSection(
//           currentUserLocation: selectedLocation?.userLocation,
//           incidentLocation: null,
//           onCameraIdle: (bool isIdle) {
//             if (widget.showRadius) {
//               if (movedPosition != null && !showPreviousSelectedLocation)
//                 _selectLocation(movedPosition!);
//             } else {
//               getLocationAddress();
//             }
//           },
//           updateMovedPosition: (LatLng p) {
//             movedPosition = p;
//           },
//           onMapController: (DgisMapController controller) {
//             mapController = controller;
//           },
//           showRadius: widget.showRadius,
//         ),
//         // Huawei map section
//         //const HuaweiMapSection(),
//         // pin marker section
//         PinMarkerSection(
//           isLocationAllowed: isLocationAllowed,
//         ),
//         // current location button and address card
//         Container(
//           alignment: Alignment.bottomCenter,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // current location button
//               GestureDetector(
//                 onTap: () async {
//                   bool isSuccess =
//                       await CommonFunctions.checkLocationSettings(context);
//                   if (isSuccess) getCurrentUserLocation();
//                 },
//                 child: Container(
//                   margin: const EdgeInsetsDirectional.only(end: 12),
//                   alignment: AlignmentDirectional.topEnd,
//                   child: Image.asset(
//                     Constants.imgPath + 'location1@3x.png',
//                     height: 50,
//                     width: 50,
//                   ),
//                 ),
//               ),
//               //  address card
//               MapAddressCard(
//                 address: gisAddress,
//                 submitLocation: _submitLocation,
//                 isValidLocation: true,
//               ),
//             ],
//           ),
//         ),
//         // search section
//         if (widget.showSearch)
//           MapSearchSection(
//             showBigPaddingScreen: widget.showSearchPaddingScreen,
//             currentUserLocation: selectedLocation?.userLocation,
//             onSearchResult: (LatLng location) {
//
//
//               mapController.moveCamera(
//                 CameraPositionMessage(
//                   point: GeoPointMessage(latitude: location.latitude, longitude: location.longitude),
//                   zoom: 16.0,
//                   tilt: 0.0,
//                   bearing: 0.0,
//                 ),
//                 0.3, // duration
//                 CameraAnimationTypeMessage.linear,
//               );
//               // mapController.animateCamera(
//               //   CameraUpdate.newCameraPosition(
//               //     CameraPosition(
//               //         target: LatLng(location.latitude, location.longitude),
//               //         zoom: 16.0),
//               //   ),
//               // );
//
//
//             },
//           ),
//       ],
//     );
//   }
//
//   void getCurrentUserLocation() async {
//     if (showPreviousSelectedLocation) {
//       if (selectedLocation?.selectedLocation != null) {
//         animateCamera(selectedLocation!.selectedLocation!.latitude,
//             selectedLocation!.selectedLocation!.longitude);
//       }
//
//       showPreviousSelectedLocation = false;
//       selectedLocation?.userLocation ??= LatLng(
//
//          longitude: selectedLocation!.selectedLocation!.longitude, latitude:  selectedLocation!.selectedLocation!.latitude);
//       return;
//     }
//
//     try {
//       EasyLoading.show();
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best,
//           timeLimit: const Duration(seconds: 20));
//       EasyLoading.dismiss();
//
//       selectedLocation?.userLocation =
//           LatLng(latitude:position.latitude, longitude:position.longitude);
//       selectedLocation?.selectedLocation =
//           LatLng(latitude:position.latitude, longitude:position.longitude);
//       animateCamera(position.latitude, position.longitude);
//     } catch (error, stackTrace) {
//       LogsViewModel().sendEventFromModel(
//         event: ErrorExceptionModel(
//           nameEvent: EventsName.handledException,
//           message: error.toString(),
//           stackTrace: stackTrace.toString(),
//         ),
//       );
//       EasyLoading.dismiss();
//       Position? position;
//       try {
//         position = await Geolocator.getLastKnownPosition();
//       } catch (error, stackTrace) {
//     LogsViewModel().sendEventFromModel(
//       event: ErrorExceptionModel(
//         nameEvent: EventsName.handledException,
//         message: error.toString(),
//         stackTrace: stackTrace.toString(),
//       ),
//     );
//   }
//
//       if (position != null) {
//         selectedLocation?.userLocation =
//             LatLng(latitude:position.latitude, longitude:position.longitude);
//         selectedLocation?.selectedLocation =
//             LatLng(latitude:position.latitude,longitude: position.longitude);
//         animateCamera(position.latitude, position.longitude);
//       }
//     }
//   }
//
//   void animateCamera(double lat, double lng) {
//     try {
//       mapController.moveCamera(
//         CameraPositionMessage(
//           point: GeoPointMessage(latitude: lat, longitude: lng),
//           zoom: 16.0,
//           tilt: 0.0,
//           bearing: 0.0,
//         ),
//         0.3, // duration
//         CameraAnimationTypeMessage.linear,
//       );
//
//       // mapController.animateCamera(
//       //   CameraUpdate.newCameraPosition(
//       //     CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
//       //   ),
//       // );
//
//
//     } catch (error, stackTrace) {
//     LogsViewModel().sendEventFromModel(
//       event: ErrorExceptionModel(
//         nameEvent: EventsName.handledException,
//         message: error.toString(),
//         stackTrace: stackTrace.toString(),
//       ),
//     );
//   }
//   }
//
//   void setMapLoading() {
//     EasyLoading.show();
//     Timer(const Duration(milliseconds: 1300), () async {
//       getCurrentUserLocation();
//       EasyLoading.dismiss();
//     });
//
//     if (Platform.isAndroid) {
//       Timer(const Duration(milliseconds: 1300), () async {
//         setState(() {
//           // mapLoading = false;
//         });
//       });
//     } else {
//       setState(() {
//         //  mapLoading = false;
//       });
//     }
//   }
//
//   void getLocationAddress() async {
//     if (movedPosition != null) {
//       selectedLocation?.selectedLocation = movedPosition;
//        EasyLoading.show();
//       gisLocationResult = await locator<CustomerVoiceRepository>()
//           .getApigeeGisLocation(movedPosition!);
//        EasyLoading.dismiss();
//       setState(() {
//         gisAddress = null;
//         isFirstLoad = false;
//         if (gisLocationResult?.adminMunicipalityName != null) {
//           gisAddress = gisLocationResult!.getFullAddress();
//           selectedLocation?.selectedLocationAddress = gisAddress;
//         }
//       });
//     }
//   }
//
//   void _selectLocation(LatLng position) {
//     double distanceInMeters = calculateDistance(
//         position.latitude,
//         position.longitude,
//         selectedLocation?.userLocation?.latitude,
//         selectedLocation?.userLocation?.longitude);
//
//     if (distanceInMeters <= RemoteConfig.mapRadius) {
//       setState(() {
//         selectedLocation?.selectedLocation = position;
//       });
//
//       getLocationAddress();
//     } else {
//       if (selectedLocation != null) {
//         setState(() {
//           isLocationAllowed = false;
//         });
//         Timer(const Duration(seconds: 1), () async {
//           setState(() {
//             isLocationAllowed = true;
//           });
//
//           // mapController.animateCamera(
//           //   CameraUpdate.newCameraPosition(
//           //     CameraPosition(
//           //         target: LatLng(selectedLocation!.selectedLocation!.latitude,
//           //             selectedLocation!.selectedLocation!.longitude),
//           //         zoom: 13.0),
//           //   ),
//           // );
//
//
//           mapController.moveCamera(
//             CameraPositionMessage(
//               point: GeoPointMessage(latitude: selectedLocation!.selectedLocation!.latitude, longitude:  selectedLocation!.selectedLocation!.longitude),
//               zoom: 13.0,
//               tilt: 0.0,
//               bearing: 0.0,
//             ),
//             0.3, // duration
//             CameraAnimationTypeMessage.linear,
//           );
//         });
//       }
//     }
//   }
//
//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a)) * 1000;
//   }
//
//   void checkDistanceBetweenUserLocationAndSelectedLocation(
//       {LatLng? userLocation, LatLng? selectedLocation}) {
//     if (userLocation == null || selectedLocation == null) return;
//     double distanceInMeters = calculateDistance(
//         userLocation.latitude,
//         userLocation.longitude,
//         selectedLocation.latitude,
//         selectedLocation.longitude);
//
//     if (distanceInMeters > RemoteConfig.mapRadius) {
//       setState(() {
//         this.selectedLocation?.selectedLocation = userLocation;
//       });
//
//       // mapController.animateCamera(
//       //   CameraUpdate.newCameraPosition(
//       //     CameraPosition(
//       //         target: LatLng(userLocation.latitude, userLocation.longitude),
//       //         zoom: 16.0),
//       //   ),
//       // );
//
//       mapController.moveCamera(
//         CameraPositionMessage(
//           point: GeoPointMessage(latitude: userLocation.latitude, longitude:  userLocation.longitude),
//           zoom: 16.0,
//           tilt: 0.0,
//           bearing: 0.0,
//         ),
//         0.3, // duration
//         CameraAnimationTypeMessage.linear,
//       );
//
//
//     }
//   }
//
//   void _submitLocation() {
//     widget.onLocationChanged(selectedLocation);
//   }
// }
//
// // class GoogleMapSection extends StatefulWidget {
// //   final Function(LatLng position) updateMovedPosition;
// //   final Function(bool cameraIdle) onCameraIdle;
// //   final Function(GoogleMapController controller) onMapController;
// //   final LatLng? currentUserLocation;
// //   final bool showRadius;
// //
// //   const GoogleMapSection(
// //       {Key? key,
// //       required this.updateMovedPosition,
// //       required this.onCameraIdle,
// //       required this.currentUserLocation,
// //       required this.onMapController,
// //       required this.showRadius})
// //       : super(key: key);
// //
// //   @override
// //   _GoogleMapSectionState createState() => _GoogleMapSectionState();
// // }
// //
// // class _GoogleMapSectionState extends State<GoogleMapSection> {
// //   Set<Circle>? circles;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     setMapCircle(widget.currentUserLocation);
// //     return GoogleMap(
// //       zoomControlsEnabled: false,
// //       // myLocationEnabled: true,
// //       circles: circles ?? {},
// //       myLocationButtonEnabled: false,
// //       //circles: circles != null ? circles : {},
// //       onCameraMove: (position) {
// //         widget.updateMovedPosition(position.target);
// //       },
// //       onCameraIdle: () {
// //         widget.onCameraIdle(true);
// //       },
// //       onMapCreated: (GoogleMapController controller) {
// //         controller.setMapStyle(
// //           """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
// //         );
// //         widget.onMapController(controller);
// //       },
// //       markers: {
// //         if (widget.currentUserLocation != null &&
// //             MapUtils.userLocationMarker != null)
// //           Marker(
// //               icon: MapUtils.userLocationMarker!,
// //               markerId: const MarkerId("userLocation"),
// //               position: widget.currentUserLocation!),
// //       },
// //       initialCameraPosition: const CameraPosition(
// //           target: LatLng(24.76836756001484, 46.720988751704304), zoom: 5),
// //     );
// //   }
// //
// //   void setMapCircle(LatLng? location) {
// //     if (location != null && widget.showRadius) {
// //       circles = {
// //         Circle(
// //           circleId: const CircleId("1"),
// //           center: LatLng(location.latitude, location.longitude),
// //           radius: RemoteConfig.mapRadius,
// //           fillColor: const Color(0x8094cdd6),
// //           strokeWidth: 0,
// //         )
// //       };
// //     }
// //   }
// // }
// //
// // class HuaweiMapSection extends StatefulWidget {
// //   const HuaweiMapSection({Key? key}) : super(key: key);
// //
// //   @override
// //   _HuaweiMapSectionState createState() => _HuaweiMapSectionState();
// // }
// //
// // class _HuaweiMapSectionState extends State<HuaweiMapSection> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //     // return HuaweiMap(
// //     //   onMapCreated: (HuaweiMapController controller) {
// //     //     mapController = controller;
// //     //
// //     //     mapController.setMapStyle(_mapStyle);
// //     //   },
// //     //   myLocationButtonEnabled: false,
// //     //   circles: circles,
// //     //   onCameraMove: (position) {
// //     //     if (position != null) {
// //     //       movedPosition = position.target;
// //     //     }
// //     //   },
// //     //   onCameraIdle: () {
// //     //     if (movedPosition != null) {
// //     //       if (selectedLocation != null && selectedLocation.userLocation != null)
// //     //         _selectLocation(movedPosition);
// //     //     }
// //     //   },
// //     //   markers: {
// //     //     if (selectedLocation.userLocation != null)
// //     //       Marker(
// //     //           visible: userCurrentLocationMarker != null,
// //     //           icon: userCurrentLocationMarker,
// //     //           markerId: MarkerId("userLocation"),
// //     //           position: LatLng(selectedLocation.userLocation.latitude,
// //     //               selectedLocation.userLocation.longitude)),
// //     //   },
// //     //   // onTap: _selectLocation,
// //     //   initialCameraPosition: selectedLocation.userLocation != null
// //     //       ? CameraPosition(
// //     //           zoom: 16,
// //     //           target: LatLng(selectedLocation.userLocation.latitude,
// //     //               selectedLocation.userLocation.longitude))
// //     //       : initalCameralLocation,
// //     // );
// //   }
// // }
// //
// // class PinMarkerSection extends StatelessWidget {
// //   bool isLocationAllowed = true;
// //   PinMarkerSection({this.isLocationAllowed = true});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       alignment: Alignment.center,
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           (isLocationAllowed)
// //               ? const Center()
// //               : Container(
// //                   color: Colors.white,
// //                   padding: const EdgeInsets.all(2),
// //                   margin: const EdgeInsets.only(bottom: 85),
// //                   child: Text(
// //                     ('location_not_allowed_map').tr(),
// //                     textScaleFactor: 1,
// //                   ),
// //                 ),
// //           Container(
// //             margin: Platform.isAndroid
// //                 ? const EdgeInsets.only(bottom: 25)
// //                 : const EdgeInsets.only(bottom: 30),
// //             height: 30.0,
// //             width: 15.0,
// //             child: Image.asset(
// //               isLocationAllowed
// //                   ? "assets/images/marker@3x.webp"
// //                   : "assets/images/redPinMarker@3x.webp",
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class MapSearchSection extends StatelessWidget {
// //   final showBigPaddingScreen;
// //   Function(LatLng location) onSearchResult;
// //
// //   MapSearchSection(
// //       {Key? key,
// //       this.showBigPaddingScreen = false,
// //       required this.onSearchResult})
// //       : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: showBigPaddingScreen
// //           ? EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40)
// //           : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //       alignment: Alignment.topCenter,
// //       child: GestureDetector(
// //         onTap: () {
// //           _showPlaceSearch(context);
// //         },
// //         child: Container(
// //           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
// //           alignment: Alignment.center,
// //           height: 52,
// //           decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 10),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: <Widget>[
// //                 Expanded(
// //                     child: CustomTextWidget(
// //                   ("lbl_search_for_place").tr(),
// //                   fontColor: AppColor.black400,
// //                   fontWeight: AppFontWeight.medium,
// //                   fontSize: 17,
// //                   textAlign: TextAlign.start,
// //                 )),
// //                 Image.asset(
// //                   Constants.imgPath + 'mapSearch@3x.png',
// //                   height: 24,
// //                   width: 24,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   _showPlaceSearch(BuildContext context) async {
// //     place.Prediction? p = await PlacesAutocomplete.show(
// //         context: context,
// //         apiKey: "AIzaSyA-Hs2J4hgwr1m5ScEnLwpZQpTUdtZfhMI",
// //         mode: Mode.overlay,
// //         types: [],
// //         strictbounds: false,
// //         language: "ar",
// //         components: [new place.Component(place.Component.country, "sa")]);
// //
// //     final places = place.GoogleMapsPlaces(
// //         apiKey: "AIzaSyA-Hs2J4hgwr1m5ScEnLwpZQpTUdtZfhMI");
// //     places.getDetailsByPlaceId(p?.placeId ?? "").then((response) {
// //       var lat = response.result.geometry?.location.lat;
// //       var long = response.result.geometry?.location.lng;
// //
// //       if (lat != null && long != null) {
// //         onSearchResult(LatLng(lat, long));
// //       }
// //     });
// //   }
// // }
