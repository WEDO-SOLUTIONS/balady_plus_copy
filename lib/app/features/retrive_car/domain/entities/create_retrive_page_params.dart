import 'package:balady_plus/app/features/retrive_car/domain/entities/vehicle_item.dart';
import 'package:equatable/equatable.dart';

class CreateRetrivePageParams extends Equatable {
  final VehicleItem item;
  final String type;

  CreateRetrivePageParams({required this.item, required this.type});
  @override
  List<Object?> get props => [item];
}
