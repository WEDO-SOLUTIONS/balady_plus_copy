// import 'package:dgis_map/dgis_map_controller.dart';
// import 'package:dgis_map/library.dart';
// import 'package:flutter/material.dart';
//
//
// import '../../../../../core/utils/utils_exports.dart'
//     show AppColor, CommonProperties, IconPath;
// import '../../../../_shared_feature_/balady_features/widgets/UrbiMap/urbi_map_section.dart';
// import '../../../home_exports.dart' show HomeAppBar, CircleIcon;
//
// class HomeMap extends StatelessWidget {
//    HomeMap({super.key});
//   DgisMapController? mapController;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.4,
//       child: Stack(
//         children: [
//           SizedBox(
//             child:
//
//             UrbiMapSection(
//               readOnly: true,
//               currentUserLocation:CommonProperties.defaultLocation,
//               incidentLocation:CommonProperties.defaultLocation,
//               onCameraIdle: (bool isIdle) {
//                 mapController?.moveCamera(
//                   CameraPositionMessage(
//                     point: GeoPointMessage(latitude:  CommonProperties.defaultLocation.latitude, longitude: CommonProperties.defaultLocation.longitude),
//                     zoom: 6.0,
//                     tilt: 0.0,
//                     bearing: 0.0,
//                   ),
//                   0.3, // duration
//                   CameraAnimationTypeMessage.linear,
//                 );
//               },
//               updateMovedPosition: (LatLng p) {
//
//               },
//               onMapController: (DgisMapController controller) {
//                 mapController = controller;
//               },
//               showRadius: true,
//             ),
//             // GoogleMap(
//             //   initialCameraPosition: CameraPosition(
//             //       target: CommonProperties.defaultLocation, zoom: 6),
//             //   onMapCreated: (GoogleMapController controller) {
//             //     controller.setMapStyle(
//             //       """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
//             //     );
//             //   },
//             // ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 HomeAppBar(),
//                 SizedBox(height: 16),
//                 Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: CircleIcon(
//                     icon: IconPath.search,
//                     iconColor: AppColor.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned.directional(
//             bottom: 120,
//             end: 16,
//             textDirection: TextDirection.rtl,
//             child: const CircleIcon(
//               icon: IconPath.layers,
//               iconColor: AppColor.white,
//               backgroundColor: AppColor.primary900Light,
//             ),
//           ),
//           Positioned.directional(
//             bottom: 60,
//             end: 16,
//             textDirection: TextDirection.rtl,
//             child: const CircleIcon(
//               icon: IconPath.currentLocation,
//               iconColor: AppColor.white,
//               backgroundColor: AppColor.primary900Light,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
