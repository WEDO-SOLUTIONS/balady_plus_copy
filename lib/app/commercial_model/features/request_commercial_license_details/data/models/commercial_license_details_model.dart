import 'package:intl/intl.dart';

class RequestCommercialLicenseDetailsModel {
  int requestId;
  int statusId;
  String statusName;
  String subMunicipalityId;
  String subMunicipalityName;
  int typeId;
  String typeName;
  int licenseTypeId;
  String licenseTypeName;
  DateTime? lastUpdateDate;
  int? cancellationReasonId;
  String? cancellationReasonName;
  LicenseInfo licenseInfo;
  List<AttachmentsInfo>? attachmentsInfo;
  List<RequestNotesInfo>? requestNotesInfo;
  bool availableCloseDate;
  bool isFromInitialApproval;

  RequestCommercialLicenseDetailsModel({
    required this.requestId,
    required this.statusId,
    required this.cancellationReasonId,
    required this.cancellationReasonName,
    required this.statusName,
    required this.subMunicipalityId,
    required this.subMunicipalityName,
    required this.typeId,
    required this.typeName,
    required this.licenseTypeId,
    required this.licenseTypeName,
    required this.lastUpdateDate,
    required this.licenseInfo,
    required this.attachmentsInfo,
    required this.requestNotesInfo,
    required this.availableCloseDate,
    required this.isFromInitialApproval
  });

  factory RequestCommercialLicenseDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      RequestCommercialLicenseDetailsModel(
        requestId: json["requestId"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        subMunicipalityId: json["subMunicipalityId"] ?? "",
        subMunicipalityName: json["subMunicipalityName"] ?? "",
        cancellationReasonName: json["cancellationReasonName"],
        cancellationReasonId: json["cancellationReasonId"],
        typeId: json["typeId"],
        typeName: json["typeName"],
        licenseTypeId: json["licenseTypeId"],
        licenseTypeName: json["licenseTypeName"],
        lastUpdateDate: json["lastUpdateDate"] != null
            ? DateFormat("yyyy/MM/dd ").parse(json["lastUpdateDate"])
            : null,
        licenseInfo: LicenseInfo.fromJson(json["licenseInfo"]),
        availableCloseDate: json["availableCloseDate"] ?? false,
        isFromInitialApproval: json["hasInitialApproval"] ?? false,
        attachmentsInfo: json["attachmentsInfo"] != null
            ? List<AttachmentsInfo>.from(
                json["attachmentsInfo"].map((x) => AttachmentsInfo.fromJson(x)))
            : null,
        requestNotesInfo: json["requestNotesInfo"] != null
            ? List<RequestNotesInfo>.from(json["requestNotesInfo"]
                .map((x) => RequestNotesInfo.fromJson(x)))
            : null,
      );
}

class AttachmentsInfo {
  int id;
  String name;
  // String allowedFilesExtension;
  // bool attached;
  // bool approved;
  String? attachUrl;
  // int maxSize;
  // dynamic notes;
  // String attachDescription;
  // String originFileName;

  AttachmentsInfo({
    required this.id,
    required this.name,
    // required this.allowedFilesExtension,
    // required this.attached,
    // required this.approved,
    required this.attachUrl,
    // required this.maxSize,
    // required this.notes,
    // required this.attachDescription,
    // required this.originFileName,
  });

  factory AttachmentsInfo.fromJson(Map<String, dynamic> json) =>
      AttachmentsInfo(
        id: json["id"],
        name: json["name"] ?? '',
        // allowedFilesExtension: json["allowedFilesExtension"],
        // attached: json["attached"],
        // approved: json["approved"],
        attachUrl: json["attachUrl"],
        // maxSize: json["maxSize"],
        // notes: json["notes"],
        // attachDescription: json["attachDescription"],
        // originFileName: json["originFileName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "allowedFilesExtension": allowedFilesExtension,
        // "attached": attached,
        // "approved": approved,
        "attachUrl": attachUrl,
        // "maxSize": maxSize,
        // "notes": notes,
        // "attachDescription": attachDescription,
        // "originFileName": originFileName,
      };
}

class LicenseInfo {
  int licenseId;
  int statusId;
  String statusName;
  String? issueDate;
  String licenseEndDate;
  String licenseSadadEndDate;

  LicenseInfo({
    required this.licenseId,
    required this.statusId,
    required this.statusName,
    required this.issueDate,
    required this.licenseEndDate,
    required this.licenseSadadEndDate,
  });

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        licenseId: json["licenseId"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        issueDate: json["issueDate"] ?? '',
        licenseEndDate: json["licenseEndDate"] ?? '',
        licenseSadadEndDate: json["licenseSadadEndDate"] ?? '',
      );
}

class RequestNotesInfo {
  DateTime date;
  int id;
  String note;

  RequestNotesInfo({
    required this.date,
    required this.id,
    required this.note,
  });

  factory RequestNotesInfo.fromJson(Map<String, dynamic> json) =>
      RequestNotesInfo(
        date: DateFormat("yyyy/MM/dd ").parse(json["date"]),
        id: json["id"],
        note: json["note"],
      );
}
