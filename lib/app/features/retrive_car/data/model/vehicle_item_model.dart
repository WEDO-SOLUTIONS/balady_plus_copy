import '../../domain/entities/vehicle_item.dart';

class VehicleItemModel extends VehicleItem {
  VehicleItemModel({
    super.pyStatusWork,
    super.nationalId,
    super.isAlive,
    super.pzInsKey,
    super.vehicleDetails,
    super.pyId,
    super.mobileNumber,
    super.statusAr,
    super.personId,
    super.vehiclePlateNumber,
    super.pxCreateDateTime,
    super.fullName,
    super.pyLabel,
  });

  factory VehicleItemModel.fromJson(Map<String, dynamic> json) =>
      VehicleItemModel(
        pyStatusWork: json["pyStatusWork"],
        nationalId: json["NationalID"],
        isAlive: json["IsAlive"],
        pzInsKey: json["pzInsKey"],
        vehicleDetails: json["VehicleDetails"] == null
            ? null
            : VehicleDetailsModel.fromJson(json["VehicleDetails"]),
        pyId: json["pyID"],
        mobileNumber: json["MobileNumber"],
        statusAr: json["Status_Ar"],
        personId: json["PersonID"],
        vehiclePlateNumber: json["VehiclePlateNumber"],
        pxCreateDateTime: json["pxCreateDateTime"],
        fullName: json["FullName"],
        pyLabel: json["pyLabel"],
      );
}

class VehicleDetailsModel extends VehicleDetails {
  VehicleDetailsModel({
    super.chassisNumber,
    super.pyTempInteger,
    super.vehicleModel,
    super.leftLetter,
    super.vehicleType,
    super.midleLetter,
    super.rightLetter,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) =>
      VehicleDetailsModel(
        chassisNumber: json["ChassisNumber"],
        pyTempInteger: json["PlateDigit"],
        vehicleModel: json["VehicleModel"],
        leftLetter: json["LeftLetter"],
        vehicleType: json["VehicleType"],
        midleLetter: json["MiddleLetter"],
        rightLetter: json["RightLetter"],
      );
}
