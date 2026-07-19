//
//
//
//
//
//
//
//
//
//
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:dgis_map/library.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// //import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import 'package:mapness/shared/ui/urbi_map.dart';
// import 'package:smart_advisor/app/core/utils/common_functions.dart';
//
// import '../../../../../core/dependency_injection/injection_container.dart';
//
// import '../../../../../core/utils/constants/constants.dart';
//
// import 'search_provider.dart';
// import 'urbi_location_model.dart';
//
// class UrbiMapSection extends StatefulWidget {
//   final Function(LatLng position) updateMovedPosition;
//   final Function(bool cameraIdle) onCameraIdle;
//   final Function(DgisMapController controller) onMapController;
//   final LatLng? currentUserLocation;
//   final LatLng? incidentLocation;
//   final bool showRadius;
//   final bool readOnly;
//   final List<Marker>? marker;
//
//   const UrbiMapSection(
//       {Key? key,
//         required this.updateMovedPosition,
//         required this.onCameraIdle,
//         required this.currentUserLocation,
//         required this.incidentLocation,
//         required this.onMapController,
//         required this.showRadius,
//         this.marker,
//         this.readOnly = false})
//       : super(key: key);
//
//   @override
//   _UrbiMapSectionState createState() => _UrbiMapSectionState();
// }
//
// class _UrbiMapSectionState extends State<UrbiMapSection> {
//   // Set<Circle>? circles;
//   double zoom = 5;
//   StreamSubscription<CameraStateEvent>? _cameraStateListener;
//   StreamSubscription<CameraPositionMessage>? _cameraPositionListener;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     zoom = (widget.currentUserLocation != null || widget.readOnly) ? 16 : 5;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // setMapCircle(widget.currentUserLocation);
//
//
//
//
//     return  UrbiMap(
//         onMapCreated: (DgisMapController controller) {
//           // Setup listeners and initialize map
//           // context.read<Step2ActivityDataExportCubit>().mapController = controller;
//           if(widget.currentUserLocation != null) {
//             controller.setCameraPosition(
//               CameraPositionMessage(
//                 point: GeoPointMessage(
//                     latitude: widget.currentUserLocation!.latitude,
//                     longitude: widget.currentUserLocation!.longitude),
//                 zoom: 16.0,
//                 tilt: 0.0,
//                 bearing: 0.0,
//               ),
//             );
//           }
//
//           if(widget.marker != null && widget.marker!.isNotEmpty) {
//             controller.addMarkers(widget.marker!);
//           }
//
//           widget.onMapController(controller);
//
//           _cameraStateListener = controller.cameraStateEvents.listen((event) {
//             if (event.state == CameraState.free) {
//               // Handle camera idle state
//               widget.onCameraIdle(true);
//
//             }
//           });
//           _cameraPositionListener = controller.cameraPositionEvents.listen((event) {
//             // Handle camera position updates
//             widget.updateMovedPosition(LatLng(latitude: event.point.latitude,longitude: event.point.longitude));
//           });
//         }
//     );
//
//
//
//   }
//
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
// }
//
// class PinMarkerSection extends StatelessWidget {
//   bool isLocationAllowed = true;
//   PinMarkerSection({this.isLocationAllowed = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           (isLocationAllowed)
//               ? const Center()
//               : Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(2),
//             margin: const EdgeInsets.only(bottom: 85),
//             child: Text(
//               ('location_not_allowed_map').tr(),
//               textScaleFactor: 1,
//             ),
//           ),
//           Container(
//             margin: Platform.isAndroid
//                 ? const EdgeInsets.only(bottom: 25)
//                 : const EdgeInsets.only(bottom: 30),
//             height: 30.0,
//             width: 15.0,
//             child: Image.asset(
//               isLocationAllowed
//                   ? "assets/images/marker@3x.webp"
//                   : "assets/images/redPinMarker@3x.webp",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MapSearchSection extends StatelessWidget {
//   final showBigPaddingScreen;
//   Function(LatLng location) onSearchResult;
//   final LatLng? currentUserLocation;
//  String query = "";
//
//   MapSearchSection(
//       {Key? key,
//         this.showBigPaddingScreen = false,
//         required this.onSearchResult,
//         required this.currentUserLocation})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
//       alignment: Alignment.center,
//       height: 52,
//       decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
//       child: AutocompleteTextFiled(currentUserLocation:currentUserLocation, onSearchResult: onSearchResult,),
//
//
//       // TypeAheadField<UrbiLocationModel>(
//       //   errorBuilder: (context, error) =>  Text('errors_server_error_1'.tr()),
//       //   emptyBuilder: (context) => query.isNotEmpty? Padding(
//       //     padding: const EdgeInsets.all(8.0),
//       //     child: Text("noSearchFounded".tr()),
//       //   ):SizedBox(),
//       //   suggestionsCallback: (search) => suggestionsCallback(search,currentUserLocation),
//       //   builder: (context, controller, focusNode) {
//       //     return TextField(
//       //         controller: controller,
//       //         focusNode: focusNode,
//       //         autofocus: true,
//       //         decoration: InputDecoration(
//       //           border: OutlineInputBorder(),
//       //           labelText: 'lbl_search_for_place'.tr(),
//       //         )
//       //     );
//       //   },
//       //   itemBuilder: (context, model) {
//       //
//       //     String? area="";
//       //     String? region = "";
//       //     if( model.admDiv != null &&  model.admDiv!.isNotEmpty) {
//       //
//       //
//       //       List? districtArea = model.admDiv!.where((item) => item.type == "district_area").toList();
//       //
//       //       if(districtArea.isNotEmpty) {
//       //         area = districtArea.first.name;
//       //       }
//       //
//       //       List? districtRegion = model.admDiv!.where((item) => item.type == "region").toList();
//       //
//       //       if(districtRegion.isNotEmpty) {
//       //         region = districtRegion.first.name;
//       //       }
//       //
//       //     }
//       //     String Type = "";
//       //     if(model.type == "street") {
//       //       Type= "${model.type!},";
//       //     }
//       //     return Column(
//       //       children: [
//       //         ListTile(
//       //           title: Text( Type + (model.searchAttributes?.suggestedText??"")),
//       //           subtitle: Text("${area!},${region}"),
//       //         ),
//       //         Divider(thickness: 1,)
//       //       ],
//       //     );
//       //   },
//       //
//       //   onSelected: (model) {
//       //     if (model.point != null) {
//       //       onSearchResult(LatLng(latitude: model.point!.lat!,longitude: model.point!.lon!));
//       //     }
//       //   },
//       // ),
//     );
//
//
//
//   }
//
//   Future<List<UrbiLocationModel>> suggestionsCallback(String pattern,LatLng? location) async {
//     query = pattern;
//     UrbiSearchProvider? provider = sl();
//     return provider.search(pattern,location??const LatLng(latitude:24.694163,longitude:46.722667));
//
//
//   }
//
//
// }
//
//
// class AutocompleteTextFiled extends StatefulWidget {
//   final LatLng? currentUserLocation;
//   Function(LatLng location) onSearchResult;
//   String? query;
//   List<UrbiLocationModel> lstSuggestedLocation = [];
//   bool showListView = true;
//
//    AutocompleteTextFiled(
//       {Key? key,
//         required this.currentUserLocation,
//         required this.onSearchResult,})
//       : super(key: key);
//
//   @override
//   _AutocompleteTextFiledState createState() => _AutocompleteTextFiledState();
// }
//
//
// class _AutocompleteTextFiledState extends State<AutocompleteTextFiled> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Autocomplete<UrbiLocationModel>(
//       optionsBuilder: (TextEditingValue textEditingValue) {
//
//         return  widget.lstSuggestedLocation;
//
//       },
//         // onSelected: (model) {
//         //   if (model.point != null) {
//         //     onSearchResult(LatLng(latitude: model.point!.lat!,longitude: model.point!.lon!));
//         //   }
//         // },
//       fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
//         // Implement the text field UI
//
//         return TextField(
//           controller: fieldTextEditingController,
//           focusNode: fieldFocusNode,
//           decoration: InputDecoration(
//             labelText: 'lbl_search_for_place'.tr(),
//           ),
//           onChanged: (text) {
//
//
//             setState(() {
//               widget.query = text;
//               widget.showListView = true;
//             });
//
//             suggestionsCallback(widget.query,widget.currentUserLocation);
//
//           },
//
//           onSubmitted: (text) {
//
//             // Handle the submission of the selected suggestion
//             // Implement the logic for the selection action
//           },
//         );
//       },
//
//       optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<UrbiLocationModel> onSelected, Iterable<UrbiLocationModel> options) {
//         // Implement the UI for displaying the suggestion options
//
//
//         if(widget.query!= null &&widget.query!.isNotEmpty)
//           return widget.showListView==true?Padding(
//             padding: EdgeInsets.only(left: CommonFunctions.isAppAR?30.0:0,bottom: 180,right: CommonFunctions.isAppAR?0.0:30),
//             child: Material(
//               child:
//               ListView(
//                 padding: EdgeInsets.zero,
//                 children: options.map((UrbiLocationModel model) {
//                   String? area="";
//                   String? region = "";
//                   if( model.admDiv != null &&  model.admDiv!.isNotEmpty) {
//
//
//                     List? districtArea = model.admDiv!.where((item) => item.type == "district_area").toList();
//
//                     if(districtArea.isNotEmpty) {
//                       area = districtArea.first.name;
//                     }
//
//                     List? districtRegion = model.admDiv!.where((item) => item.type == "region").toList();
//
//                     if(districtRegion.isNotEmpty) {
//                       region = districtRegion.first.name;
//                     }
//
//                   }
//                   String Type = "";
//                   if(model.type == "street") {
//                     Type= "${model.type!},";
//                   }
//
//
//                   return Column(
//                     children: [
//                       ListTile(
//                         onTap: (){
//                           if (model.point != null) {
//
//                            // textEditingController?.text = Type + (model.searchAttributes?.suggestedText??"");
//
//                             setState(() {
//                               widget.showListView = false;
//                             });
//
//                             widget.onSearchResult(LatLng(latitude: model.point!.lat!,longitude: model.point!.lon!));
//                           }
//                         },
//                         title: Text( Type + (model.searchAttributes?.suggestedText??"")),
//                         subtitle: Text("${area!},${region}"),
//                       ),
//                       Divider(thickness: 1,)
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ):Container();
//         else
//           return Container();
//       },
//
//     );
//   }
//
//   void suggestionsCallback(String? pattern,LatLng? location) async {
//
//     //await Future<void>.delayed(Duration(seconds: 1));
//     if(pattern != null && pattern.isNotEmpty) {
//       UrbiSearchProvider? provider = sl();
//       provider.search(pattern,
//           location ?? const LatLng(latitude: 24.694163, longitude: 46.722667)).then((value){
//
//         widget.lstSuggestedLocation =value;
//       });
//     }
//     else {
//       widget.lstSuggestedLocation = [];
//     }
//
//
//
//
//   }
//
//
// }
//
//
//
//
//
//
//
