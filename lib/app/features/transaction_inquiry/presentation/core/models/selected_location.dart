

import 'package:dgis_map/library.dart';

class SelectedLocation {
  LatLng? userLocation;
  LatLng? selectedLocation;
  String? selectedLocationAddress;

  SelectedLocation(
      {this.userLocation, this.selectedLocation, this.selectedLocationAddress});

  SelectedLocation copyWith(
          {LatLng? userLocation,
          LatLng? slectedLocation,
          String? slectedLocationAddress}) =>
      SelectedLocation(
        userLocation: userLocation ?? this.userLocation,
        selectedLocation: slectedLocation ?? selectedLocation,
        selectedLocationAddress:
            slectedLocationAddress ?? selectedLocationAddress,
      );
}
