import 'package:balady_plus/app/features/retrive_car/domain/entities/vehicle_item.dart';
import 'package:equatable/equatable.dart';

class VehicleResponse extends Equatable {
  final List<VehicleItem>? items;
  final int? totalCount;
  VehicleResponse({this.items, this.totalCount});

  @override
  List<Object?> get props => [];
}
