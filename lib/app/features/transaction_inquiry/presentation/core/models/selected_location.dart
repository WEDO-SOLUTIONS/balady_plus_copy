import 'package:google_maps_flutter/google_maps_flutter.dart';

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
