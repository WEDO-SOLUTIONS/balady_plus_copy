import 'package:dgis_map/library.dart';

class PoiCardDataFromGoogle {
  final String id;
  final String? name;
  final String? displayName;
  final LatLng? location;
  final String? primaryType;
  final String? displayPrimaryType;

  const PoiCardDataFromGoogle({
    required this.id,
    this.name,
    this.displayName,
    this.location,
    this.primaryType,
    this.displayPrimaryType,
  });
}
