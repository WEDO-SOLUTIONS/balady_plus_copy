import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/retrive_car/domain/entities/veichle_card_model.dart';
import 'package:equatable/equatable.dart';

class VehicleItem extends Equatable {
  final String? pyStatusWork;
  final String? nationalId;
  final String? isAlive;
  final String? pzInsKey;
  final VehicleDetails? vehicleDetails;
  final String? pyId;
  final String? mobileNumber;
  final String? statusAr;
  final String? personId;
  final String? vehiclePlateNumber;
  final String? pxCreateDateTime;
  final String? fullName;
  final String? pyLabel;

  VehicleItem({
    this.pyStatusWork,
    this.nationalId,
    this.isAlive,
    this.pzInsKey,
    this.vehicleDetails,
    this.pyId,
    this.mobileNumber,
    this.statusAr,
    this.personId,
    this.vehiclePlateNumber,
    this.pxCreateDateTime,
    this.fullName,
    this.pyLabel,
  });

  VehicleCard get cardItem => VehicleCard(
      carModel:
          "${vehicleDetails?.vehicleModel} ${vehicleDetails?.vehicleType}",
      carStatus: (CommonFunctions.isAppAR ? statusAr : pyStatusWork) ?? "",
      id: pyId ?? "",
      cayYear: "",
      ownerShip: "",
      plateNumber: vehiclePlateNumber ?? "",
      item: this);

  @override
  List<Object?> get props => [pyId];
}

class VehicleDetails extends Equatable {
  VehicleDetails({
    this.chassisNumber,
    this.pyTempInteger,
    this.vehicleModel,
    this.leftLetter,
    this.vehicleType,
    this.rightLetter,
    this.midleLetter,
  });

  final String? chassisNumber;
  final String? pyTempInteger;
  final String? vehicleModel;
  final String? leftLetter;
  final String? vehicleType;
  final String? rightLetter;
  final String? midleLetter;

  String? get modelAndType => "$vehicleModel  $vehicleType";
  @override
  List<Object?> get props => [];
}
