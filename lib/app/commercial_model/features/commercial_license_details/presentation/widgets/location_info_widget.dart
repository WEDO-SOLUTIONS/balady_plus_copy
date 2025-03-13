import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:dgis_map/library.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class LocationInfoWidget extends StatelessWidget {
  final LocationInfo? locationInfo;
  DgisMapController? mapController;
   LocationInfoWidget({super.key, required this.locationInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'locationInfo'.tr(),
      icon: IconPath.qrLocationIcon,
      children: [
        const SizedBox(height: 16),
        locationInfo?.latitude != null && locationInfo?.longitude != null
            ? SizedBox(
                height: 250,
                child:
                UrbiMapSection(
                  readOnly: true,
                  currentUserLocation:LatLng(latitude: double.parse(locationInfo!.latitude!),longitude: double.parse(locationInfo!.longitude!)),
                  incidentLocation:LatLng(latitude: double.parse(locationInfo!.latitude!),longitude: double.parse(locationInfo!.longitude!)),
                  onCameraIdle: (bool isIdle) {
                    mapController?.moveCamera(
                      CameraPositionMessage(
                        point: GeoPointMessage(latitude:  double.parse(locationInfo!.latitude!), longitude: double.parse(locationInfo!.longitude!)),
                        zoom: 16.0,
                        tilt: 0.0,
                        bearing: 0.0,
                      ),
                      0.3, // duration
                      CameraAnimationTypeMessage.linear,
                    );
                  },
                  updateMovedPosition: (LatLng p) {

                  },
                  onMapController: (DgisMapController controller) {
                    mapController = controller;
                  },
                  showRadius: true,
                ),


                // GoogleMap(
                //   initialCameraPosition: CameraPosition(
                //       target: LatLng(
                //         double.parse(locationInfo!.latitude!),
                //         double.parse(locationInfo!.longitude!),
                //       ),
                //       zoom: 16),
                //   markers: {
                //     Marker(
                //       markerId: const MarkerId('position'),
                //       position: LatLng(
                //         double.parse(locationInfo!.latitude!),
                //         double.parse(locationInfo!.longitude!),
                //       ),
                //     )
                //   },
                //   onMapCreated: (GoogleMapController controller) {
                //     controller.setMapStyle(
                //       """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                //     );
                //   },
                //   zoomControlsEnabled: false,
                //   zoomGesturesEnabled: false,
                //   scrollGesturesEnabled: false,
                // ),
              )
            : const SizedBox(),
        CardParameter(
          // from whats
          title: 'municipalityName'.tr(),
          value: locationInfo?.municipalityName ?? "",
        ),
        CardParameter(
          // from whats
          title: 'city'.tr(),
          value: locationInfo?.cityName ?? "",
        ),
        CardParameter(
          // from whats
          title: 'subMunicipalityName'.tr(),
          value: locationInfo?.subMunicipalityName ?? "",
        ),
        CardParameter(
          title: 'district'.tr(),
          value: locationInfo?.districtName ?? "",
        ),
        CardParameter(
          title: 'street'.tr(),
          value: locationInfo?.streetName ?? "",
        ),
        CardParameter(
          title: 'planNumber'.tr(),
          value: locationInfo?.mapNo ?? "",
        ),
        CardParameter(
          title: 'parcel_number'.tr(),
          value: locationInfo?.landNo ?? "",
        ),
        CardParameter(
          title: 'latitude'.tr(),
          value: locationInfo?.latitude ?? '',
        ),
        CardParameter(
          title: 'longitude'.tr(),
          value: locationInfo?.longitude ?? '',
        ),
      ],
    );
  }
}
