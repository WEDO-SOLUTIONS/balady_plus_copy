import '../../domain/entities/vehicle_item.dart';

class VeichlesListPageParams {
  final String type;

  final List<VehicleItem>? items;

  VeichlesListPageParams({this.items, required this.type});
}
