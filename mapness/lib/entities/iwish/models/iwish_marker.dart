import 'package:dgis_map/library.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';

class IwishMarker {
  final String id;
  final IwishCategory category;
  final GeoPointMessage location;
  final IwishState state;

  IwishMarker({
    required this.state,
    required this.id,
    required this.category,
    required this.location,
  });
}
