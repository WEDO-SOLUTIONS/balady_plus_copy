class Permit24RequestDetailsModel {
  LocationInfo? locationInfo;
  SubmitterInfo? submitterInfo;
  RequestInfo? requestInfo;
  LicenseInfo? licenseInfo;
  dynamic rejectionInfo;
  List<TransactionsList>? transactionsList;
  String? requestKey;
  dynamic calculatedCostInfo;

  Permit24RequestDetailsModel(
      {this.locationInfo,
      this.submitterInfo,
      this.requestInfo,
      this.licenseInfo,
      this.rejectionInfo,
      this.transactionsList,
      this.calculatedCostInfo,
      this.requestKey});

  factory Permit24RequestDetailsModel.fromJson(Map<String, dynamic> json) =>
      Permit24RequestDetailsModel(
          locationInfo: json["locationInfo"] == null
              ? null
              : LocationInfo.fromJson(json["locationInfo"]),
          submitterInfo: json["submitterInfo"] == null
              ? null
              : SubmitterInfo.fromJson(json["submitterInfo"]),
          requestInfo: json["requestInfo"] == null
              ? null
              : RequestInfo.fromJson(json["requestInfo"]),
          licenseInfo: json["licenseInfo"] == null
              ? null
              : LicenseInfo.fromJson(json["licenseInfo"]),
          rejectionInfo: json["rejectionInfo"],
          requestKey: json["requestKey"]
          /* transactionsList: json["transactionsList"] == null
            ? []
            : List<TransactionsList>.from(json["transactionsList"]!
                .map((x) => TransactionsList.fromJson(x))),*/
          //   calculatedCostInfo: json["calculatedCostInfo"],
          );

  Map<String, dynamic> toJson() => {
        "locationInfo": locationInfo?.toJson(),
        "submitterInfo": submitterInfo?.toJson(),
        "requestInfo": requestInfo?.toJson(),
        "licenseInfo": licenseInfo?.toJson(),
        "rejectionInfo": rejectionInfo,
        "transactionsList": transactionsList == null
            ? []
            : List<dynamic>.from(transactionsList!.map((x) => x.toJson())),
        "calculatedCostInfo": calculatedCostInfo,
      };
}

class LicenseInfo {
  int? licenseNumber;
  String? licenseEndDate;
  String? ownerIdentityNumber;
  String? ownerName;
  int? detailedActivityId;
  String? detailedActivityName;
  int? isicActivityId;
  String? isicActivityName;
  int? permitNumber;
  String? permitEndDate;
  String? permitIssueDate;
  List<dynamic>? additionalActivities;
  Status? status;
  LicenseInfo(
      {this.licenseNumber,
      this.licenseEndDate,
      this.ownerIdentityNumber,
      this.ownerName,
      this.detailedActivityId,
      this.detailedActivityName,
      this.isicActivityId,
      this.isicActivityName,
      this.permitNumber,
      this.permitEndDate,
      this.additionalActivities,
      this.permitIssueDate,
      this.status});

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        licenseNumber: json["licenseNumber"],
        licenseEndDate: json["licenseEndDate"],
        ownerIdentityNumber: json["ownerIdentityNumber"],
        ownerName: json["ownerName"],
        detailedActivityId: json["detailedActivityId"],
        detailedActivityName: json["detailedActivityName"],
        isicActivityId: json["isicActivityId"],
        isicActivityName: json["isicActivityName"],
        permitNumber: json["permitNumber"],
        permitEndDate: json["permitEndDate"],
        permitIssueDate: json["permitIssueDate"],
        status: json["status"] != null ? Status.fromMap(json["status"]) : null,
        additionalActivities: json["additionalActivities"] == null
            ? []
            : List<dynamic>.from(json["additionalActivities"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "licenseNumber": licenseNumber,
        "licenseEndDate": licenseEndDate,
        "ownerIdentityNumber": ownerIdentityNumber,
        "ownerName": ownerName,
        "detailedActivityId": detailedActivityId,
        "detailedActivityName": detailedActivityName,
        "isicActivityId": isicActivityId,
        "isicActivityName": isicActivityName,
        "permitNumber": permitNumber,
        "permitEndDate": permitEndDate,
        "additionalActivities": additionalActivities == null
            ? []
            : List<dynamic>.from(additionalActivities!.map((x) => x)),
      };
}

class Status {
  String? id;
  String? name;
  Status({
    this.id,
    this.name,
  });

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }
}

class LocationInfo {
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  String? subMunicipalityName;

  LocationInfo({
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.subMunicipalityName,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        subMunicipalityName: json["subMunicipalityName"],
      );

  Map<String, dynamic> toJson() => {
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "subMunicipalityName": subMunicipalityName,
      };
}

class RequestInfo {
  String? requestIssueDate;
  String? billNumber;
  int? requestStatusCode;
  String? requestStatusDesc;
  BillInfo? billInfo;
  int? requestId;
  String? requestCreationDate;

  RequestInfo(
      {this.requestIssueDate,
      this.billNumber,
      this.requestStatusCode,
      this.requestStatusDesc,
      this.billInfo,
      this.requestId,
      this.requestCreationDate});

  factory RequestInfo.fromJson(Map<String, dynamic> json) => RequestInfo(
      requestIssueDate: json["requestIssueDate"],
      billNumber: json["billNumber"],
      requestStatusCode: json["requestStatusCode"],
      requestStatusDesc: json["requestStatusDesc"],
      billInfo:
          json["billInfo"] == null ? null : BillInfo.fromJson(json["billInfo"]),
      requestId: json["requestId"],
      requestCreationDate: json["requestCreationDate"]);

  Map<String, dynamic> toJson() => {
        "requestIssueDate": requestIssueDate,
        "billNumber": billNumber,
        "requestStatusCode": requestStatusCode,
        "requestStatusDesc": requestStatusDesc,
        "billInfo": billInfo?.toJson(),
        "requestId": requestId,
      };
}

class BillInfo {
  String? billNumber;
  String? issueDate;
  String? expiryDate;
  double? billAmount;
  int? billerNumber;
  dynamic warningMessage;
  String? billKey;

  BillInfo(
      {this.billNumber,
      this.issueDate,
      this.expiryDate,
      this.billAmount,
      this.billerNumber,
      this.warningMessage,
      this.billKey});

  factory BillInfo.fromJson(Map<String, dynamic> json) => BillInfo(
      billNumber: json["billNumber"],
      issueDate: json["issueDate"],
      expiryDate: json["expiryDate"],
      billAmount: json["billAmount"]?.toDouble(),
      billerNumber: json["billerNumber"],
      warningMessage: json["warningMessage"],
      billKey: json["billKey"]);

  Map<String, dynamic> toJson() => {
        "billNumber": billNumber,
        "issueDate": issueDate,
        "expiryDate": expiryDate,
        "billAmount": billAmount,
        "billerNumber": billerNumber,
        "warningMessage": warningMessage,
      };
}

class SubmitterInfo {
  int? submitterIdNumber;
  String? mobile;
  String? submitterName;

  SubmitterInfo({
    this.submitterIdNumber,
    this.mobile,
    this.submitterName,
  });

  factory SubmitterInfo.fromJson(Map<String, dynamic> json) => SubmitterInfo(
        submitterIdNumber: json["submitterIdNumber"],
        mobile: json["mobile"],
        submitterName: json["submitterName"],
      );

  Map<String, dynamic> toJson() => {
        "submitterIdNumber": submitterIdNumber,
        "mobile": mobile,
        "submitterName": submitterName,
      };
}

class TransactionsList {
  String? actorName;
  int? statusId;
  String? statusName;
  int? oldStatusId;
  String? oldStatusName;
  String? creationDate;
  dynamic notes;

  TransactionsList({
    this.actorName,
    this.statusId,
    this.statusName,
    this.oldStatusId,
    this.oldStatusName,
    this.creationDate,
    this.notes,
  });

  factory TransactionsList.fromJson(Map<String, dynamic> json) =>
      TransactionsList(
        actorName: json["actorName"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        oldStatusId: json["oldStatusId"],
        oldStatusName: json["oldStatusName"],
        creationDate: json["creationDate"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "actorName": actorName,
        "statusId": statusId,
        "statusName": statusName,
        "oldStatusId": oldStatusId,
        "oldStatusName": oldStatusName,
        "creationDate": creationDate,
        "notes": notes,
      };
}
