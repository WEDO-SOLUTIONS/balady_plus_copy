class PosterRequestDetailsModel {
  final int? requestId;
  final String? creationDate;
  final RequestStatus? requestStatus;
  final RequestStatus? requestType;
  final RequestStatus? municipality;
  final RequestStatus? subMunicipality;
  final List<RequestStatus>? alerts;
  final OwnerResponseDto? ownerResponseDto;
  final SubmitterResponseDto? submitterResponseDto;
  final dynamic licenseId;
  final String? billNumber;
  final dynamic permitStartDate;
  final dynamic permitEndDate;
  final dynamic permitDuration;
  final dynamic permitIssuingDate;
  final dynamic licenseExpirationDate;
  final RequestStatus? licenseStatus;
  final List<RequestNote>? requestNotes;
  final List<Poster>? posters;
  final CostCalculationInfo? costCalculationInfo;
  final List<IndividualRequest>? individualRequests;

  PosterRequestDetailsModel({
    this.requestId,
    this.creationDate,
    this.requestStatus,
    this.requestType,
    this.municipality,
    this.subMunicipality,
    this.alerts,
    this.ownerResponseDto,
    this.submitterResponseDto,
    this.licenseId,
    this.billNumber,
    this.permitStartDate,
    this.permitEndDate,
    this.permitDuration,
    this.permitIssuingDate,
    this.licenseExpirationDate,
    this.licenseStatus,
    this.requestNotes,
    this.posters,
    this.costCalculationInfo,
    this.individualRequests,
  });

  factory PosterRequestDetailsModel.fromJson(Map<String, dynamic> json) =>
      PosterRequestDetailsModel(
        requestId: json["requestId"],
        creationDate: json["creationDate"],
        requestStatus: json["requestStatus"] == null
            ? null
            : RequestStatus.fromJson(json["requestStatus"]),
        requestType: json["requestType"] == null
            ? null
            : RequestStatus.fromJson(json["requestType"]),
        municipality: json["municipality"] == null
            ? null
            : RequestStatus.fromJson(json["municipality"]),
        subMunicipality: json["subMunicipality"] == null
            ? null
            : RequestStatus.fromJson(json["subMunicipality"]),
        alerts: json["alerts"] == null
            ? []
            : List<RequestStatus>.from(
                json["alerts"]!.map((x) => RequestStatus.fromJson(x))),
        ownerResponseDto: json["ownerResponseDto"] == null
            ? null
            : OwnerResponseDto.fromJson(json["ownerResponseDto"]),
        submitterResponseDto: json["submitterResponseDto"] == null
            ? null
            : SubmitterResponseDto.fromJson(json["submitterResponseDto"]),
        licenseId: json["licenseId"],
        billNumber: json["billNumber"],
        permitStartDate: json["permitStartDate"],
        permitEndDate: json["permitEndDate"],
        permitDuration: json["permitDuration"],
        permitIssuingDate: json["permitIssuingDate"],
        licenseExpirationDate: json["licenseExpirationDate"],
        licenseStatus: json["licenseStatus"] == null
            ? null
            : RequestStatus.fromJson(json["licenseStatus"]),
        requestNotes: json["requestNotes"] == null
            ? []
            : List<RequestNote>.from(
                json["requestNotes"]!.map((x) => RequestNote.fromJson(x))),
        posters: json["posters"] == null
            ? []
            : List<Poster>.from(
                json["posters"]!.map((x) => Poster.fromJson(x))),
        costCalculationInfo: json["costCalculationInfo"] == null
            ? null
            : CostCalculationInfo.fromJson(json["costCalculationInfo"]),
        individualRequests: json["individualRequests"] == null
            ? []
            : List<IndividualRequest>.from(json["individualRequests"]!
                .map((x) => IndividualRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "creationDate": creationDate,
        "requestStatus": requestStatus?.toJson(),
        "requestType": requestType?.toJson(),
        "municipality": municipality,
        "subMunicipality": subMunicipality,
        "alerts": alerts == null
            ? []
            : List<dynamic>.from(alerts!.map((x) => x.toJson())),
        "ownerResponseDto": ownerResponseDto?.toJson(),
        "submitterResponseDto": submitterResponseDto?.toJson(),
        "licenseId": licenseId,
        "billNumber": billNumber,
        "permitStartDate": permitStartDate,
        "permitEndDate": permitEndDate,
        "permitDuration": permitDuration,
        "permitIssuingDate": permitIssuingDate,
        "licenseExpirationDate": licenseExpirationDate,
        "licenseStatus": licenseStatus,
        "requestNotes": requestNotes == null
            ? []
            : List<dynamic>.from(requestNotes!.map((x) => x.toJson())),
        "posters": posters == null
            ? []
            : List<dynamic>.from(posters!.map((x) => x.toJson())),
        "costCalculationInfo": costCalculationInfo?.toJson(),
        "individualRequests": individualRequests == null
            ? []
            : List<dynamic>.from(individualRequests!.map((x) => x.toJson())),
      };
}

class RequestStatus {
  final String? id;
  final String? name;

  RequestStatus({
    this.id,
    this.name,
  });

  factory RequestStatus.fromJson(Map<String, dynamic> json) => RequestStatus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class CostCalculationInfo {
  final int? postersCount;
  final dynamic postersCountDescription;
  final double? postersAreaSum;
  final dynamic postersAreaSumDescription;
  final dynamic durationInDays;
  final dynamic durationInDaysDescription;
  final double? totalCost;
  final dynamic totalCostDescription;
  final dynamic licensesCountDescription;
  final dynamic licensesCount;
  CostCalculationInfo(
      {this.postersCount,
      this.postersCountDescription,
      this.postersAreaSum,
      this.postersAreaSumDescription,
      this.durationInDays,
      this.durationInDaysDescription,
      this.totalCost,
      this.totalCostDescription,
      this.licensesCountDescription,
      this.licensesCount});

  factory CostCalculationInfo.fromJson(Map<String, dynamic> json) =>
      CostCalculationInfo(
        postersCount: json["postersCount"],
        postersCountDescription: json["postersCountDescription"],
        postersAreaSum: json["postersAreaSum"]?.toDouble(),
        postersAreaSumDescription: json["postersAreaSumDescription"],
        durationInDays: json["durationInDays"],
        durationInDaysDescription: json["durationInDaysDescription"],
        totalCost: json["totalCost"]?.toDouble(),
        totalCostDescription: json["totalCostDescription"],
        licensesCountDescription: json["licensesCountDescription"],
        licensesCount: json["licensesCount"],
      );

  Map<String, dynamic> toJson() => {
        "postersCount": postersCount,
        "postersCountDescription": postersCountDescription,
        "postersAreaSum": postersAreaSum,
        "postersAreaSumDescription": postersAreaSumDescription,
        "durationInDays": durationInDays,
        "durationInDaysDescription": durationInDaysDescription,
        "totalCost": totalCost,
        "totalCostDescription": totalCostDescription,
      };
}

class IndividualRequest {
  final int? individualRequestId;
  final int? licenseId;
  final RequestStatus? status;
  final String? creationDate;
  final dynamic billNumber;
  final dynamic permitIssuingDate;
  final String? permitStartDate;
  final dynamic permitEndDate;
  final RequestStatus? subMunicipality;

  IndividualRequest({
    this.individualRequestId,
    this.licenseId,
    this.status,
    this.creationDate,
    this.billNumber,
    this.permitIssuingDate,
    this.permitStartDate,
    this.permitEndDate,
    this.subMunicipality,
  });

  factory IndividualRequest.fromJson(Map<String, dynamic> json) =>
      IndividualRequest(
        individualRequestId: json["individualRequestId"],
        licenseId: json["licenseId"],
        status: json["status"] == null
            ? null
            : RequestStatus.fromJson(json["status"]),
        creationDate: json["creationDate"],
        billNumber: json["billNumber"],
        permitIssuingDate: json["permitIssuingDate"],
        permitStartDate: json["permitStartDate"],
        permitEndDate: json["permitEndDate"],
        subMunicipality: json["subMunicipality"] == null
            ? null
            : RequestStatus.fromJson(json["subMunicipality"]),
      );

  Map<String, dynamic> toJson() => {
        "individualRequestId": individualRequestId,
        "licenseId": licenseId,
        "status": status?.toJson(),
        "creationDate": creationDate,
        "billNumber": billNumber,
        "permitIssuingDate": permitIssuingDate,
        "permitStartDate": permitStartDate,
        "permitEndDate": permitEndDate,
        "subMunicipality": subMunicipality?.toJson(),
      };
}

class OwnerResponseDto {
  final String? ownerIdentityId;
  final int? ownerIdentityTypeId;
  final String? ownerIdentityType;
  final String? ownerMobileNumber;
  final String? ownerName;
  final String? ownerEmail;

  OwnerResponseDto({
    this.ownerIdentityId,
    this.ownerIdentityTypeId,
    this.ownerIdentityType,
    this.ownerMobileNumber,
    this.ownerName,
    this.ownerEmail,
  });

  factory OwnerResponseDto.fromJson(Map<String, dynamic> json) =>
      OwnerResponseDto(
        ownerIdentityId: json["ownerIdentityId"],
        ownerIdentityTypeId: json["ownerIdentityTypeId"],
        ownerIdentityType: json["ownerIdentityType"],
        ownerMobileNumber: json["ownerMobileNumber"],
        ownerName: json["ownerName"],
        ownerEmail: json["ownerEmail"],
      );

  Map<String, dynamic> toJson() => {
        "ownerIdentityId": ownerIdentityId,
        "ownerIdentityTypeId": ownerIdentityTypeId,
        "ownerIdentityType": ownerIdentityType,
        "ownerMobileNumber": ownerMobileNumber,
        "ownerName": ownerName,
        "ownerEmail": ownerEmail,
      };
}

class Poster {
  final int? posterId;
  final String? posterName;
  final String? typeName;
  final int? typeId;
  final double? length;
  final double? width;
  final double? area;
  final double? discountPercentage;
  final List<Attachment>? attachments;

  Poster({
    this.posterId,
    this.posterName,
    this.typeName,
    this.typeId,
    this.length,
    this.width,
    this.area,
    this.discountPercentage,
    this.attachments,
  });

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
        posterId: json["posterId"],
        posterName: json["posterName"],
        typeName: json["typeName"],
        typeId: json["typeId"],
        length: json["length"]?.toDouble(),
        width: json["width"]?.toDouble(),
        area: json["area"]?.toDouble(),
        discountPercentage: json["discountPercentage"]?.toDouble(),
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posterId": posterId,
        "posterName": posterName,
        "typeName": typeName,
        "typeId": typeId,
        "length": length,
        "width": width,
        "area": area,
        "discountPercentage": discountPercentage,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class Attachment {
  final int? id;
  final int? typeId;
  final String? key;
  final String? name;
  final String? attachUrl;
  final String? originFileName;

  Attachment({
    this.id,
    this.typeId,
    this.key,
    this.name,
    this.attachUrl,
    this.originFileName,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        typeId: json["typeId"],
        key: json["key"],
        name: json["name"],
        attachUrl: json["attachUrl"],
        originFileName: json["originFileName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "typeId": typeId,
        "key": key,
        "name": name,
        "attachUrl": attachUrl,
        "originFileName": originFileName,
      };
}

class RequestNote {
  final int? id;
  final String? note;
  final String? date;

  RequestNote({
    this.id,
    this.note,
    this.date,
  });

  factory RequestNote.fromJson(Map<String, dynamic> json) => RequestNote(
        id: json["id"],
        note: json["note"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "date": date,
      };
}

class SubmitterResponseDto {
  final String? submitterIdentityId;
  final int? submitterIdentityTypeId;
  final String? submitterIdentityType;
  final String? submitterMobileNumber;
  final String? submitterName;
  final String? submitterEmail;

  SubmitterResponseDto({
    this.submitterIdentityId,
    this.submitterIdentityTypeId,
    this.submitterIdentityType,
    this.submitterMobileNumber,
    this.submitterName,
    this.submitterEmail,
  });

  factory SubmitterResponseDto.fromJson(Map<String, dynamic> json) =>
      SubmitterResponseDto(
        submitterIdentityId: json["submitterIdentityId"],
        submitterIdentityTypeId: json["submitterIdentityTypeId"],
        submitterIdentityType: json["submitterIdentityType"],
        submitterMobileNumber: json["submitterMobileNumber"],
        submitterName: json["submitterName"],
        submitterEmail: json["submitterEmail"],
      );

  Map<String, dynamic> toJson() => {
        "submitterIdentityId": submitterIdentityId,
        "submitterIdentityTypeId": submitterIdentityTypeId,
        "submitterIdentityType": submitterIdentityType,
        "submitterMobileNumber": submitterMobileNumber,
        "submitterName": submitterName,
        "submitterEmail": submitterEmail,
      };
}
