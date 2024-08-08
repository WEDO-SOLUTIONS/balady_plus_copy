// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';

import '../../../../../core/utils/nullable.dart';
import '../../../domain/entities/user_info_response.dart';
import '../baqie_approval_response.dart';
import 'grave_active_request_details.dart';

class DeceasedInfoDto extends Equatable {
  final GraveActiveRequestDetails? graveDetails;
  final LookUpItem? burialCityId;
  final LookUpItem? deathCity;

  final bool? multipleCityRequest;
  final LookUpItem? nationalityId;
  final bool? specialTransferNeeded;
  final String? specialTransferOtherReason;
  final LookUpItem? specialTransferReasonId;

  final String? otherBurialCity;

  final String? burialDateHijri;
  final String? burialDateGorgian;
  final bool? isPandemicDeath;
  final bool? isMuslim;

  final LookUpItem? selectedNationalType;
  final LookUpItem? selectedCemetry;
  final LookUpItem? selectedCemetryType;
  final LookUpItem? selectedTime;
  final String? otherTimeName;
  final String? deceassedId;
  final int? identityType;
  final String? deceassedDOBGorgian;
  final String? deceassedDOBHijri;
  final UserInfoResponse? userInfoResponse;
  final int? gender;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;
  final LookUpItem? selectedOrgnization;
  final String? permitNo;
  final BaqieApprovalResponse? baqieApproval;
  DeceasedInfoDto({
    this.graveDetails,
    this.burialCityId,
    this.deathCity,
    this.multipleCityRequest,
    this.nationalityId,
    this.specialTransferNeeded,
    this.specialTransferOtherReason,
    this.specialTransferReasonId,
    this.otherBurialCity,
    this.burialDateHijri,
    this.burialDateGorgian,
    this.isPandemicDeath,
    this.isMuslim,
    this.selectedNationalType,
    this.selectedCemetry,
    this.selectedCemetryType,
    this.selectedTime,
    this.otherTimeName,
    this.deceassedId,
    this.identityType,
    this.deceassedDOBGorgian,
    this.deceassedDOBHijri,
    this.userInfoResponse,
    this.gender,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.fourthName,
    this.selectedOrgnization,
    this.baqieApproval,
    this.permitNo,
  });

  DeceasedInfoDto copyWith(
      {Nullable<GraveActiveRequestDetails?>? graveDetails,
      LookUpItem? deathCity,
      LookUpItem? burialCityId,
      bool? multipleCityRequest,
      Nullable<LookUpItem?>? nationalityId,
      bool? specialTransferNeeded,
      Nullable<String?>? specialTransferOtherReason,
      Nullable<LookUpItem?>? specialTransferReasonId,
      Nullable<String?>? otherBurialCity,
      String? burialDateHijri,
      String? burialDateGorgian,
      bool? isPandemicDeath,
      Nullable<bool?>? isMuslim,
      LookUpItem? selectedNationalType,
      Nullable<LookUpItem?>? selectedCemetry,
      LookUpItem? selectedCemetryType,
      LookUpItem? selectedTime,
      Nullable<String?>? otherTimeName,
      Nullable<String?>? deceassedId,
      Nullable<String?>? deceassedDOBGorgian,
      Nullable<String?>? deceassedDOBHijri,
      Nullable<UserInfoResponse?>? userInfoResponse,
      Nullable<int?>? gender,
      Nullable<String?>? firstName,
      Nullable<String?>? secondName,
      Nullable<String?>? thirdName,
      Nullable<String?>? fourthName,
      LookUpItem? selectedOrgnization,
      String? permitNo,
      Nullable<BaqieApprovalResponse?>? baqieApproval}) {
    return DeceasedInfoDto(
      baqieApproval:
          baqieApproval == null ? this.baqieApproval : baqieApproval.value,
      deathCity: deathCity ?? this.deathCity,
      graveDetails:
          graveDetails == null ? this.graveDetails : graveDetails.value,
      burialCityId: burialCityId ?? this.burialCityId,
      multipleCityRequest: multipleCityRequest ?? this.multipleCityRequest,
      nationalityId:
          nationalityId == null ? this.nationalityId : nationalityId.value,
      specialTransferNeeded:
          specialTransferNeeded ?? this.specialTransferNeeded,
      specialTransferOtherReason: specialTransferOtherReason == null
          ? this.specialTransferOtherReason
          : specialTransferOtherReason.value,
      specialTransferReasonId: specialTransferReasonId == null
          ? this.specialTransferReasonId
          : specialTransferReasonId.value,
      otherBurialCity: otherBurialCity == null
          ? this.otherBurialCity
          : otherBurialCity.value,
      burialDateHijri: burialDateHijri ?? this.burialDateHijri,
      burialDateGorgian: burialDateGorgian ?? this.burialDateGorgian,
      isPandemicDeath: isPandemicDeath ?? this.isPandemicDeath,
      isMuslim: isMuslim == null ? this.isMuslim : isMuslim.value,
      selectedNationalType: selectedNationalType ?? this.selectedNationalType,
      selectedCemetry: selectedCemetry == null
          ? this.selectedCemetry
          : selectedCemetry.value,
      selectedCemetryType: selectedCemetryType ?? this.selectedCemetryType,
      selectedTime: selectedTime ?? this.selectedTime,
      otherTimeName:
          otherTimeName == null ? this.otherTimeName : otherTimeName.value,
      deceassedId: deceassedId == null ? this.deceassedId : deceassedId.value,
      deceassedDOBGorgian: deceassedDOBGorgian == null
          ? this.deceassedDOBGorgian
          : deceassedDOBGorgian.value,
      deceassedDOBHijri: deceassedDOBHijri == null
          ? this.deceassedDOBHijri
          : deceassedDOBHijri.value,
      userInfoResponse: userInfoResponse == null
          ? this.userInfoResponse
          : userInfoResponse.value,
      gender: gender == null ? this.gender : gender.value,
      firstName: firstName == null ? this.firstName : firstName.value,
      secondName: secondName == null ? this.secondName : secondName.value,
      thirdName: thirdName == null ? this.thirdName : thirdName.value,
      fourthName: fourthName == null ? this.fourthName : fourthName.value,
      selectedOrgnization: selectedOrgnization ?? this.selectedOrgnization,
      permitNo: permitNo ?? this.permitNo,
    );
  }

  Map<String, dynamic> toMap() => {
        "graveRequestId": graveDetails?.requestId,
        "identityNo": deceassedId,
        "identityType": selectedNationalType?.id,
        "birthDate": deceassedDOBHijri,
        "burialDate": burialDateGorgian,
        "burialDateHijri": burialDateHijri,
        "firstName": firstName,
        "secondName": secondName,
        "thirdName": thirdName,
        "fourthName": fourthName,
        "isMuslim": isMuslim,
        "nationalityId": nationalityId?.id,
        "genderId": gender,
        "specialTransferReasonId": specialTransferReasonId?.id,
        "specialTransferOtherReason": specialTransferOtherReason,
        "burialCityId":
            multipleCityRequest == true ? burialCityId?.id : deathCity?.id,
        "burialTimeId": selectedTime?.id,
        "burialTimeOther": otherTimeName,
        "cemeteryId": selectedCemetry?.id,
        "cemeteryTypeId": selectedCemetryType?.id,
        "isPandemicDeath": isPandemicDeath,
        "transferOrganizationId": selectedOrgnization?.id,
        "permitId": permitNo,
        "specialTransferNeeded": specialTransferNeeded
      };
  @override
  List<Object?> get props {
    return [
      burialCityId,
      multipleCityRequest,
      nationalityId,
      specialTransferNeeded,
      specialTransferOtherReason,
      specialTransferReasonId,
      otherBurialCity,
      burialDateHijri,
      burialDateGorgian,
      isPandemicDeath,
      isMuslim,
      selectedNationalType,
      selectedCemetry,
      selectedCemetryType,
      selectedTime,
      otherTimeName,
      baqieApproval,
      deceassedId,
      deceassedDOBGorgian,
      deceassedDOBHijri,
      userInfoResponse,
      gender,
      firstName,
      secondName,
      thirdName,
      fourthName,
      selectedOrgnization,
      permitNo,
      graveDetails
    ];
  }
}

/*String getReligion() {
    return (muslimReligion == false) ? ("non_muslim").tr() : ("muslim").tr();
  }*/
