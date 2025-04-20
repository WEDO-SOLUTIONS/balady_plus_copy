class LicensesResponseItem {
  final int? requestId;
  final int? licenseNo;
  final int? requestTypeId;
  final String? requestTypeName;
  final String? shopName;
  final dynamic identityNumber;
  final String? crNumber;
  final String? crName;
  final String? municipalityId;
  final String? subMunicipalityId;
  final String? municipalityName;
  final String? subMunicipalityName;
  final String? entityType;
  final int? activityId;
  final String? activityName;
  final String? isicNumber;
  final String? isicName;
  final String? licenseStartDate;
  final String? licenseEndDate;
  final String? sadadEndDate;
  final int? licenseStatusId;
  final String? licenseStatusName;
  final int? expireInDays;
  final String? notes;
  final dynamic reportUrl;
  final bool? valid;
  final bool? immediateRequest;
  final dynamic reqParams;

  LicensesResponseItem({
    this.requestId,
    this.licenseNo,
    this.requestTypeId,
    this.requestTypeName,
    this.shopName,
    this.identityNumber,
    this.crNumber,
    this.crName,
    this.municipalityId,
    this.subMunicipalityId,
    this.municipalityName,
    this.subMunicipalityName,
    this.entityType,
    this.activityId,
    this.activityName,
    this.isicNumber,
    this.isicName,
    this.licenseStartDate,
    this.licenseEndDate,
    this.sadadEndDate,
    this.licenseStatusId,
    this.licenseStatusName,
    this.expireInDays,
    this.notes,
    this.reportUrl,
    this.valid,
    this.immediateRequest,
    this.reqParams,
  });

  LicensesResponseItem copyWith({
    int? requestId,
    int? licenseNo,
    int? requestTypeId,
    String? requestTypeName,
    String? shopName,
    dynamic identityNumber,
    String? crNumber,
    String? crName,
    String? municipalityId,
    String? subMunicipalityId,
    String? municipalityName,
    String? subMunicipalityName,
    String? entityType,
    int? activityId,
    String? activityName,
    String? isicNumber,
    String? isicName,
    String? licenseStartDate,
    String? licenseEndDate,
    String? sadadEndDate,
    int? licenseStatusId,
    String? licenseStatusName,
    int? expireInDays,
    String? notes,
    dynamic reportUrl,
    bool? valid,
    bool? immediateRequest,
    dynamic reqParams,
  }) =>
      LicensesResponseItem(
        requestId: requestId ?? this.requestId,
        licenseNo: licenseNo ?? this.licenseNo,
        requestTypeId: requestTypeId ?? this.requestTypeId,
        requestTypeName: requestTypeName ?? this.requestTypeName,
        shopName: shopName ?? this.shopName,
        identityNumber: identityNumber ?? this.identityNumber,
        crNumber: crNumber ?? this.crNumber,
        crName: crName ?? this.crName,
        municipalityId: municipalityId ?? this.municipalityId,
        subMunicipalityId: subMunicipalityId ?? this.subMunicipalityId,
        municipalityName: municipalityName ?? this.municipalityName,
        subMunicipalityName: subMunicipalityName ?? this.subMunicipalityName,
        entityType: entityType ?? this.entityType,
        activityId: activityId ?? this.activityId,
        activityName: activityName ?? this.activityName,
        isicNumber: isicNumber ?? this.isicNumber,
        isicName: isicName ?? this.isicName,
        licenseStartDate: licenseStartDate ?? this.licenseStartDate,
        licenseEndDate: licenseEndDate ?? this.licenseEndDate,
        sadadEndDate: sadadEndDate ?? this.sadadEndDate,
        licenseStatusId: licenseStatusId ?? this.licenseStatusId,
        licenseStatusName: licenseStatusName ?? this.licenseStatusName,
        expireInDays: expireInDays ?? this.expireInDays,
        notes: notes ?? this.notes,
        reportUrl: reportUrl ?? this.reportUrl,
        valid: valid ?? this.valid,
        immediateRequest: immediateRequest ?? this.immediateRequest,
        reqParams: reqParams ?? this.reqParams,
      );

  factory LicensesResponseItem.fromJson(Map<String, dynamic> json) =>
      LicensesResponseItem(
        requestId: json["requestId"],
        licenseNo: json["licenseNo"],
        requestTypeId: json["requestTypeId"],
        requestTypeName: json["requestTypeName"],
        shopName: json["shopName"],
        identityNumber: json["identityNumber"],
        crNumber: json["crNumber"],
        crName: json["crName"],
        municipalityId: json["municipalityId"],
        subMunicipalityId: json["subMunicipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityName: json["subMunicipalityName"],
        entityType: json["entityType"],
        activityId: json["activityId"],
        activityName: json["activityName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        licenseStartDate: json["licenseStartDate"],
        licenseEndDate: json["licenseEndDate"],
        sadadEndDate: json["sadadEndDate"],
        licenseStatusId: json["licenseStatusId"],
        licenseStatusName: json["licenseStatusName"],
        expireInDays: json["expireInDays"],
        notes: json["notes"],
        reportUrl: json["reportUrl"],
        valid: json["valid"],
        immediateRequest: json["immediateRequest"],
        reqParams: json["reqParams"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "licenseNo": licenseNo,
        "requestTypeId": requestTypeId,
        "requestTypeName": requestTypeName,
        "shopName": shopName,
        "identityNumber": identityNumber,
        "crNumber": crNumber,
        "crName": crName,
        "municipalityId": municipalityId,
        "subMunicipalityId": subMunicipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityName": subMunicipalityName,
        "entityType": entityType,
        "activityId": activityId,
        "activityName": activityName,
        "isicNumber": isicNumber,
        "isicName": isicName,
        "licenseStartDate": licenseStartDate,
        "licenseEndDate": licenseEndDate,
        "sadadEndDate": sadadEndDate,
        "licenseStatusId": licenseStatusId,
        "licenseStatusName": licenseStatusName,
        "expireInDays": expireInDays,
        "notes": notes,
        "reportUrl": reportUrl,
        "valid": valid,
        "immediateRequest": immediateRequest,
        "reqParams": reqParams,
      };
}
