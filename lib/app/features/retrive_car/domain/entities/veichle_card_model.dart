import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/retrive_car/domain/entities/vehicle_item.dart';
import 'package:equatable/equatable.dart';

class VehicleCard extends Equatable {
  final String id;
  final String carModel;
  final String cayYear;
  final String carStatus;
  final String plateNumber;
  final String ownerShip;
  final VehicleItem item;

  VehicleCard(
      {required this.id,
      required this.carModel,
      required this.carStatus,
      required this.cayYear,
      required this.ownerShip,
      required this.plateNumber,
      required this.item});

  String get plateEnNumber => CommonFunctions.replaceArabicNumberWithEnglish(
      item.vehicleDetails?.pyTempInteger.toString() ?? "");
  String get plateArNumber => CommonFunctions.replaceEnglishNumberWithArabic(
      item.vehicleDetails?.pyTempInteger.toString() ?? "");

  String get plateLetters =>
      "${item.vehicleDetails?.rightLetter.toString() ?? ""} ${item.vehicleDetails?.midleLetter.toString() ?? ""} ${item.vehicleDetails?.leftLetter.toString() ?? ""}";

  @override
  List<Object?> get props =>
      [id, carModel, carStatus, cayYear, ownerShip, plateNumber];
}
