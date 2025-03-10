// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/model/deceased_request_details_model.dart';

class DeceasedRequestDetails {
  DeceasedRequestDetails({
    this.requestId,
    this.requestSourceId,
    this.reportOrganizationId,
    this.deathCityId,
    this.deathCityName,
    this.deathTransferStatusId,
    this.deathTransferStatusDesc,
    this.requestStatusId,
    this.requestStatus,
    this.submitterName,
    this.submitterTypeId,
    this.submitterTypeName,
    this.submitterMobileNumber,
    this.relationship,
    this.requestDate,
    this.cancelReason,
    this.entryMode,
    this.hospitalId,
    this.hospitalName,
    this.hospitalOtherName,
    this.locationAddress,
    this.gisLocationMapParameters,
    this.transportAttachResponseDtoList,
    this.deceasedInfoResponseDtoList,
  });

  int? requestId;
  int? requestSourceId;
  dynamic reportOrganizationId;
  int? deathCityId;
  String? deathCityName;
  int? deathTransferStatusId;
  String? deathTransferStatusDesc;
  int? requestStatusId;
  String? requestStatus;
  String? submitterName;
  int? submitterTypeId;
  String? submitterTypeName;
  String? submitterMobileNumber;
  dynamic relationship;
  String? requestDate;
  dynamic cancelReason;
  int? entryMode;
  int? hospitalId;
  String? hospitalName;
  dynamic hospitalOtherName;
  String? locationAddress;
  String? gisLocationMapParameters;
  List<TransportAttachResponseDto>? transportAttachResponseDtoList;
  List<DeceasedInfoResponseDtoList>? deceasedInfoResponseDtoList;

  factory DeceasedRequestDetails.fromMap(Map<String, dynamic> json) =>
      DeceasedRequestDetails(
        requestId: json["requestId"] == null ? null : json["requestId"],
        requestSourceId:
            json["requestSourceId"] == null ? null : json["requestSourceId"],
        reportOrganizationId: json["reportOrganizationId"],
        deathCityId: json["deathCityId"] == null ? null : json["deathCityId"],
        deathCityName:
            json["deathCityName"] == null ? null : json["deathCityName"],
        deathTransferStatusId: json["deathTransferStatusId"] == null
            ? null
            : json["deathTransferStatusId"],
        deathTransferStatusDesc: json["deathTransferStatusDesc"] == null
            ? null
            : json["deathTransferStatusDesc"],
        requestStatusId:
            json["requestStatusId"] == null ? null : json["requestStatusId"],
        requestStatus:
            json["requestStatus"] == null ? null : json["requestStatus"],
        submitterName:
            json["submitterName"] == null ? null : json["submitterName"],
        submitterTypeId:
            json["submitterTypeId"] == null ? null : json["submitterTypeId"],
        submitterTypeName: json["submitterTypeName"] == null
            ? null
            : json["submitterTypeName"],
        submitterMobileNumber: json["submitterMobileNumber"] == null
            ? null
            : json["submitterMobileNumber"],
        relationship: json["relationship"],
        requestDate: json["requestDate"] == null ? null : json["requestDate"],
        cancelReason: json["cancelReason"],
        entryMode: json["entryMode"] == null ? null : json["entryMode"],
        hospitalId: json["hospitalId"] == null ? null : json["hospitalId"],
        hospitalName:
            json["hospitalName"] == null ? null : json["hospitalName"],
        hospitalOtherName: json["hospitalOtherName"],
        locationAddress:
            json["locationAddress"] == null ? null : json["locationAddress"],
        gisLocationMapParameters: json["gisLocationMapParameters"] == null
            ? null
            : json["gisLocationMapParameters"],
        transportAttachResponseDtoList:
            json["transportAttachResponseDtoList"] == null
                ? null
                : List<TransportAttachResponseDto>.from(
                    json["transportAttachResponseDtoList"].map(
                        (x) => TransportAttachResponseDtoModel.fromMap(x))),
        deceasedInfoResponseDtoList: json["deceasedInfoResponseDtoList"] == null
            ? null
            : List<DeceasedInfoResponseDtoList>.from(
                json["deceasedInfoResponseDtoList"].map((x) =>
                    DeceasedInfoResponseDtoList.fromMap(
                        x, json["deathCityId"]))),
      );
}

class DeceasedInfoResponseDtoList {
  DeceasedInfoResponseDtoList(
      {this.deathInfoId,
      this.specialTransferReasonId,
      this.specialTransferReasonName,
      this.specialTransferOtherReason,
      this.deceasedTransportRequestStatusId,
      this.deceasedTransportRequestStatus,
      this.burialCityId,
      this.burialCityName,
      this.name,
      this.isMuslim,
      this.nationalityId,
      this.nationality,
      this.genderId,
      this.gender,
      this.carId,
      this.transferDriverName,
      this.transferDriverNumber,
      this.carModel,
      this.carBrand,
      this.carManufacturingYear,
      this.carDashboardDetailsEn,
      this.carDashboardDetailsAr,
      this.driverMobileNumber,
      this.transferOrganizationName,
      this.transferOrganizationAssignDateTime,
      this.driverAssignDateTime,
      this.anonymous,
      this.transferOrganizationId,
      this.transferOrganizationX,
      this.transferOrganizationY,
      this.multipleCityRequest,
      this.specialTransferNeeded,
      this.deathCityId,
      this.baqieBurialPermitApprovalDate,
      this.baqieBurialPermitStatus,
      this.cemeteryId,
      this.cemeteryName,
      this.trips});

  int? deathInfoId;
  int? specialTransferReasonId;
  String? specialTransferReasonName;
  String? specialTransferOtherReason;
  int? deceasedTransportRequestStatusId;
  String? deceasedTransportRequestStatus;
  int? burialCityId;
  String? burialCityName;
  String? name;
  bool? isMuslim;
  int? nationalityId;
  String? nationality;
  int? genderId;
  String? gender;
  int? carId;
  String? transferDriverName;
  String? transferDriverNumber;
  String? carModel;
  String? carBrand;
  int? carManufacturingYear;
  String? carDashboardDetailsEn;
  String? carDashboardDetailsAr;
  String? driverMobileNumber;
  String? transferOrganizationName;
  String? transferOrganizationAssignDateTime;
  String? driverAssignDateTime;
  bool? anonymous;
  int? transferOrganizationId;
  String? transferOrganizationX;
  String? transferOrganizationY;
  bool? multipleCityRequest;
  bool? specialTransferNeeded;
  int? deathCityId;
  String? baqieBurialPermitStatus;
  String? baqieBurialPermitApprovalDate;
  int? cemeteryId;
  String? cemeteryName;
  List<Trip>? trips;

  factory DeceasedInfoResponseDtoList.fromMap(Map<String, dynamic> json, int? deathCityId) => DeceasedInfoResponseDtoList(
      cemeteryName: json["cemeteryName"],
      cemeteryId: json["cemeteryId"],
      baqieBurialPermitApprovalDate: json["baqieBurialPermitApprovalDate"],
      baqieBurialPermitStatus: json["baqieBurialPermitStatus"],
      deathInfoId: json["deathInfoId"] == null ? null : json["deathInfoId"],
      specialTransferReasonId: json["specialTransferReasonId"] == null
          ? null
          : json["specialTransferReasonId"],
      specialTransferReasonName: json["specialTransferReasonName"] == null
          ? null
          : json["specialTransferReasonName"],
      specialTransferOtherReason: json["specialTransferOtherReason"] == null
          ? null
          : json["specialTransferOtherReason"],
      deceasedTransportRequestStatusId: json["deceasedTransportRequestStatusId"] == null
          ? null
          : json["deceasedTransportRequestStatusId"],
      deceasedTransportRequestStatus: json["deceasedTransportRequestStatus"] == null
          ? null
          : json["deceasedTransportRequestStatus"],
      burialCityId: json["burialCityId"],
      burialCityName: json["burialCityName"],
      name: json["name"] == null ? null : json["name"],
      isMuslim: json["isMuslim"] == null ? null : json["isMuslim"],
      nationalityId:
          json["nationalityId"] == null ? null : json["nationalityId"],
      nationality: json["nationality"] == null ? null : json["nationality"],
      genderId: json["genderId"] == null ? null : json["genderId"],
      gender: json["gender"] == null ? null : json["gender"],
      carId: json["carId"] == null ? null : json["carId"],
      transferDriverName: json["transferDriverName"] == null
          ? null
          : json["transferDriverName"],
      transferDriverNumber: json["transferDriverNumber"] == null
          ? null
          : json["transferDriverNumber"],
      carModel: json["carModel"] == null ? null : json["carModel"],
      carBrand: json["carBrand"] == null ? null : json["carBrand"],
      carManufacturingYear: json["carManufacturingYear"] == null
          ? null
          : json["carManufacturingYear"],
      carDashboardDetailsEn: json["carDashboardDetailsEn"] == null
          ? null
          : json["carDashboardDetailsEn"],
      carDashboardDetailsAr: json["carDashboardDetailsAr"] == null
          ? null
          : json["carDashboardDetailsAr"],
      driverMobileNumber:
          json["driverMobileNumber"] == null ? "" : json["driverMobileNumber"],
      transferOrganizationName: json["transferOrganizationName"] == null
          ? null
          : json["transferOrganizationName"],
      transferOrganizationAssignDateTime: json["transferOrganizationAssignDateTime"] == null
          ? null
          : json["transferOrganizationAssignDateTime"],
      driverAssignDateTime: json["driverAssignDateTime"] == null ? null : json["driverAssignDateTime"],
      anonymous: json["anonymous"] == null ? null : json["anonymous"],
      transferOrganizationId: json["transferOrganizationId"] == null ? null : json["transferOrganizationId"],
      transferOrganizationX: json["transferOrganizationX"] == null ? null : json["transferOrganizationX"],
      transferOrganizationY: json["transferOrganizationY"] == null ? null : json["transferOrganizationY"],
      multipleCityRequest: json["multipleCityRequest"] == null ? null : json["multipleCityRequest"],
      specialTransferNeeded: json["specialTransferNeeded"] == null ? null : json["specialTransferNeeded"],
      trips: json["trips"] != null ? List<Trip>.from(json["trips"].map((x) => Trip.fromMap(x))) : null,
      deathCityId: deathCityId);

  String getSpecialTransferReason() {
    if (specialTransferNeeded == true) {
      if (specialTransferOtherReason?.isNotEmpty ?? false) {
        return specialTransferOtherReason ?? "";
      }
      return specialTransferReasonName ?? "";
    }
    return "";
  }

  String getCityType() {
    return multipleCityRequest == true
        ? ("outside_city").tr()
        : ("inside_city").tr();
  }

  LatLng? getTransferOrganizationLocation() {
    double? x = double.tryParse(transferOrganizationX ?? "");
    double? y = double.tryParse(transferOrganizationY ?? "");
    if (x != null && y != null) return LatLng(latitude: y, longitude:x);
  }
}

class TransportAttachResponseDto extends Equatable {
  final int? id;
  final String? fileName;
  final int? attachmentType;
  const TransportAttachResponseDto(
      {this.attachmentType, this.fileName, this.id});

  String getLetterName() {
    if (attachmentType == 8507) {
      return "مرفق خطاب الشرطة";
    }

    if (attachmentType == 8508) {
      return "خطاب تنفيذ الحد الشرعي";
    }
    return "مرفق";
  }

  @override
  List<Object?> get props => [];
}

class Trip {
  int? nextTripStationTypeId;
  String? nextTripStationTypeName;
  Trip({
    this.nextTripStationTypeId,
    this.nextTripStationTypeName,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      nextTripStationTypeId: map['nextTripStationTypeId'] != null
          ? map['nextTripStationTypeId'] as int
          : null,
      nextTripStationTypeName: map['nextTripStationTypeName'] != null
          ? map['nextTripStationTypeName'] as String
          : null,
    );
  }
}
