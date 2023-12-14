import 'package:balady_plus/app/features/ekram/domain/entities/deceased_request_details/deceased_request_details.dart';

class DeceasedRequestDetailsModel extends DeceasedRequestDetails {
  DeceasedRequestDetailsModel({
    super.requestId,
    super.requestSourceId,
    super.reportOrganizationId,
    super.deathCityId,
    super.deathCityName,
    super.deathTransferStatusId,
    super.deathTransferStatusDesc,
    super.requestStatusId,
    super.requestStatus,
    super.submitterName,
    super.submitterTypeId,
    super.submitterTypeName,
    super.submitterMobileNumber,
    super.relationship,
    super.requestDate,
    super.cancelReason,
    super.entryMode,
    super.hospitalId,
    super.hospitalName,
    super.hospitalOtherName,
    super.locationAddress,
    super.gisLocationMapParameters,
    super.transportAttachResponseDtoList,
    super.deceasedInfoResponseDtoList,
  });

  factory DeceasedRequestDetailsModel.fromMap(Map<String, dynamic> json) =>
      DeceasedRequestDetailsModel(
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
        /*gisLocationMapParameters: json["gisLocationMapParameters"] == null
            ? null
            : json["gisLocationMapParameters"],*/
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

class DeceasedInfoResponseDtoListModel extends DeceasedInfoResponseDtoList {
  DeceasedInfoResponseDtoListModel(
      {super.deathInfoId,
      super.specialTransferReasonId,
      super.specialTransferReasonName,
      super.specialTransferOtherReason,
      super.deceasedTransportRequestStatusId,
      super.deceasedTransportRequestStatus,
      super.burialCityId,
      super.burialCityName,
      super.name,
      super.isMuslim,
      super.nationalityId,
      super.nationality,
      super.genderId,
      super.gender,
      super.carId,
      super.transferDriverName,
      super.transferDriverNumber,
      super.carModel,
      super.carBrand,
      super.carManufacturingYear,
      super.carDashboardDetailsEn,
      super.carDashboardDetailsAr,
      super.driverMobileNumber,
      super.transferOrganizationName,
      super.transferOrganizationAssignDateTime,
      super.driverAssignDateTime,
      super.anonymous,
      super.transferOrganizationId,
      super.transferOrganizationX,
      super.transferOrganizationY,
      super.multipleCityRequest,
      super.specialTransferNeeded,
      super.trips,
      super.deathCityId});

  factory DeceasedInfoResponseDtoListModel.fromMap(Map<String, dynamic> json) =>
      DeceasedInfoResponseDtoListModel(
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
        deceasedTransportRequestStatusId:
            json["deceasedTransportRequestStatusId"] == null
                ? null
                : json["deceasedTransportRequestStatusId"],
        deceasedTransportRequestStatus:
            json["deceasedTransportRequestStatus"] == null
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
        driverMobileNumber: json["driverMobileNumber"],
        transferOrganizationName: json["transferOrganizationName"] == null
            ? null
            : json["transferOrganizationName"],
        transferOrganizationAssignDateTime:
            json["transferOrganizationAssignDateTime"] == null
                ? null
                : json["transferOrganizationAssignDateTime"],
        driverAssignDateTime: json["driverAssignDateTime"] == null
            ? null
            : json["driverAssignDateTime"],
        anonymous: json["anonymous"] == null ? null : json["anonymous"],
        transferOrganizationId: json["transferOrganizationId"] == null
            ? null
            : json["transferOrganizationId"],
        transferOrganizationX: json["transferOrganizationX"] == null
            ? null
            : json["transferOrganizationX"],
        transferOrganizationY: json["transferOrganizationY"] == null
            ? null
            : json["transferOrganizationY"],
        multipleCityRequest: json["multipleCityRequest"] == null
            ? null
            : json["multipleCityRequest"],
        specialTransferNeeded: json["specialTransferNeeded"] == null
            ? null
            : json["specialTransferNeeded"],
        trips: json["trips"] != null
            ? List<Trip>.from(json["trips"].map((x) => Trip.fromMap(x)))
            : null,
      );
}

class TransportAttachResponseDtoModel extends TransportAttachResponseDto {
  const TransportAttachResponseDtoModel(
      {super.attachmentType, super.fileName, super.id});

  factory TransportAttachResponseDtoModel.fromMap(Map<String, dynamic> json) =>
      TransportAttachResponseDtoModel(
          attachmentType: json["attachmentType"],
          fileName: json["fileName"],
          id: json["id"]);
}
