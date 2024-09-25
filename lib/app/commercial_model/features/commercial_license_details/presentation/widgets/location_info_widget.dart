import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class LocationInfoWidget extends StatelessWidget {
  final LocationInfo? locationInfo;

  const LocationInfoWidget({super.key, required this.locationInfo});

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
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(locationInfo!.latitude!),
                        double.parse(locationInfo!.longitude!),
                      ),
                      zoom: 16),
                  markers: {
                    Marker(
                      markerId: const MarkerId('position'),
                      position: LatLng(
                        double.parse(locationInfo!.latitude!),
                        double.parse(locationInfo!.longitude!),
                      ),
                    )
                  },
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(
                      """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                    );
                  },
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                ),
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
