import '../../../domain/entities/cemetry_request_details/cemetry_request_details.dart';

class CemetryRequestDetailsModel extends  CemetryRequestDetails{
  CemetryRequestDetailsModel({
      super.entryModeId,
        super.cemeteryId,
        super.cemeteryName,
        super.requestNumber,
        super.requestUniqueKey,
        super.requestDate,
        super.burialDate,
        super.burialDateHijri,
        super.burialTimeId,
        super.burialTimeName,
        super.burialTimeOther,
        super.deceasedBirthdate,
        super.deceasedBirthdateHijri,
        super.deceasedName,
        super.deceasedIdentityNumber,
        super.nationalityId,
        super.nationalityName,
        super.genderId,
        super.genderName,
        super.religionId,
        super.religionName,
        super.submitterName,
        super.submitterMobileNumber,
        super.requestStatusId,
        super.requestStatusName,
        super.apologyReason,
  });

  factory CemetryRequestDetailsModel.fromJson(Map<String, dynamic> json) => CemetryRequestDetailsModel(
        entryModeId: json["entryModeId"],
        cemeteryId: json["cemeteryId"],
        cemeteryName: json["cemeteryName"],
        requestNumber: json["requestNumber"],
        requestUniqueKey: json["requestUniqueKey"],
        requestDate: json["requestDate"],
        burialDate: json["burialDate"],
        burialDateHijri: json["burialDateHijri"],
        burialTimeId: json["burialTimeId"],
        burialTimeName: json["burialTimeName"],
        burialTimeOther: json["burialTimeOther"],
        deceasedBirthdate: json["deceasedBirthdate"],
        deceasedBirthdateHijri: json["deceasedBirthdateHijri"],
        deceasedName: json["deceasedName"],
        deceasedIdentityNumber: json["deceasedIdentityNumber"],
        nationalityId: json["nationalityId"],
        nationalityName: json["nationalityName"],
        genderId: json["genderId"],
        genderName: json["genderName"],
        religionId: json["religionId"],
        religionName: json["religionName"],
        submitterName: json["submitterName"],
        submitterMobileNumber: json["submitterMobileNumber"],
        requestStatusId: json["requestStatusId"],
        requestStatusName: json["requestStatusName"],
        apologyReason: json["apologyReason"],
    );


  @override
  List<Object?> get props => [];
}
