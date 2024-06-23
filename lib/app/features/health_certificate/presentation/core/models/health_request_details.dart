import 'dart:convert';

import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/enums/health_certificate.dart';

HealthRequestDetails healthRequestDetailsFromJson(String str) =>
    HealthRequestDetails.fromJson(json.decode(str));

String healthRequestDetailsToJson(HealthRequestDetails data) =>
    json.encode(data.toJson());

class HealthRequestDetails {
  HealthRequestDetails({
    this.statusDetails,
    this.data,
  });

  List<StatusDetail>? statusDetails;
  Data? data;

  factory HealthRequestDetails.fromJson(Map<String, dynamic> json) =>
      HealthRequestDetails(
        statusDetails: json["statusDetails"] != null
            ? List<StatusDetail>.from(
                json["statusDetails"].map((x) => StatusDetail.fromJson(x)))
            : null,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "statusDetails":
            List<dynamic>.from(statusDetails!.map((x) => x.toJson())),
        "data": data!.toJson(),
      };

  String? getShareURLForWallet() {
    String? id = data?.result?.healthCertificateInfo?.certificateUuid;
    bool isPrintable = data?.result?.printable ?? false;

    if (isPrintable && id != null) return "";
    //MM  return RemoteConfig.publicLicenseShareURL + "/" + id;
  }

  String getQRCode() {
    return "";
    //MM  return RemoteConfig.publicLicenseShareURL + "/" + getCertificateUuid();
  }

  String getCertificateUuid() {
    return data?.result?.healthCertificateInfo?.certificateUuid.toString() ??
        "";
  }

  String getRequestId() {
    return data?.result?.requestId.toString() ?? "";
  }

  String getRequestIdOrLicenseId(bool isLicense) {
    if (isLicense) {
      return getLicenseId();
    } else {
      return getRequestId();
    }
  }

  String getrequestTypeName() {
    return data?.result?.requestTypeName.toString() ?? "";
  }

  String getFullName() {
    return data?.result?.ownerInfo?.fullName ?? "";
  }

  String getMobileNumber() {
    return data?.result?.ownerInfo?.mobile ?? "";
  }

  String getMunicipalityName() {
    return data?.result?.municipalityName ?? "";
  }

  String getSubMunicipalityName() {
    return data?.result?.subMunicipalityName ?? "";
  }

  String getMedicalExamCode() {
    return data?.result?.medicalExamInfo?.examCode ?? "";
  }

  String getMedicalExamDate() {
    return data?.result?.medicalExamInfo?.examDate ?? "";
  }

  String getMedicalExamHospitalName() {
    return data?.result?.medicalExamInfo?.hospitalName ?? "";
  }

  String getRequestStatusName() {
    return data?.result?.requestStatusName ?? "";
  }

  String getLicenseStatusName() {
    return data?.result?.healthCertificateInfo?.statusName ?? "";
  }

  String getLicenseId() {
    return data?.result?.healthCertificateInfo?.certificateId.toString() ?? "";
  }

  String getLicenseStartDate() {
    return data?.result?.healthCertificateInfo?.issueDate.toString() ?? "";
  }

  String getLicenseEndDate() {
    return data?.result?.healthCertificateInfo?.expiryDate.toString() ?? "";
  }

  LICENSE_MANAGEMENT_STATUS getRequestStatus() {
    switch (data?.result?.requestStatusId) {
      case 1:
        return LICENSE_MANAGEMENT_STATUS.DRAFT;

      case 5:
        return LICENSE_MANAGEMENT_STATUS.DONE;

      case 6:
        return LICENSE_MANAGEMENT_STATUS.CANCELLED;

      case 7:
        return LICENSE_MANAGEMENT_STATUS.SADAD_BILL_ISSUED;

      case 12:
        return LICENSE_MANAGEMENT_STATUS.REJECTED;

      case 15:
        return LICENSE_MANAGEMENT_STATUS.WAITING_PAY_PROCCESS;

      case 200:
        return LICENSE_MANAGEMENT_STATUS.WAITING_MEDICAL_EXAM;

      case 201:
        return LICENSE_MANAGEMENT_STATUS.WAITING_MEDICAL_TRAINING;

      case 203:
        return LICENSE_MANAGEMENT_STATUS.WAITING_EMPLOYEE_VISIT;

      case 161:
        return LICENSE_MANAGEMENT_STATUS.BUY_BAG;

      case 162:
        return LICENSE_MANAGEMENT_STATUS.GO_TO_COURSE;

      case 163:
        return LICENSE_MANAGEMENT_STATUS.PASSED_AND_COMPLETED_TRAINING;

      case 164:
        return LICENSE_MANAGEMENT_STATUS.FAILED;

      case 165:
        return LICENSE_MANAGEMENT_STATUS.RECIPT_FOR_RETEST;

      default:
        return LICENSE_MANAGEMENT_STATUS.DRAFT;
    }
  }

  LICENSE_MANAGEMENT_STATUS getLicenseStatus() {
    switch (data?.result?.healthCertificateInfo?.statusId) {
      case 1:
        return LICENSE_MANAGEMENT_STATUS.DRAFT;

      case 2:
        return LICENSE_MANAGEMENT_STATUS.ACTIVE;

      case 3:
        return LICENSE_MANAGEMENT_STATUS.CANCELED;

      case 4:
        return LICENSE_MANAGEMENT_STATUS.HOLDED;

      case 5:
        return LICENSE_MANAGEMENT_STATUS.EXPIRED;

      case 6:
        return LICENSE_MANAGEMENT_STATUS.PENDING_REQUEST_EXISTS;
      default:
        return LICENSE_MANAGEMENT_STATUS.DRAFT;
    }
  }
}

class Data {
  Data({
    this.responseCode,
    this.responseMessage,
    this.result,
  });

  String? responseCode;
  String? responseMessage;
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        responseMessage: json["responseMessage"],
        result: json["result"] != null ? Result.fromJson(json["result"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseMessage": responseMessage,
        "result": result != null ? result!.toJson() : null,
      };
}

class Result {
  Result(
      {this.requestId,
      this.requestTypeId,
      this.requestTypeName,
      this.requestStatusId,
      this.requestStatusName,
      this.submitterType,
      this.requestSubmitDate,
      this.healthCertificateInfo,
      this.municipalityId,
      this.municipalityName,
      this.subMunicipalityId,
      this.subMunicipalityName,
      this.ownerInfo,
      this.submitterInfo,
      this.comLicenseInfo,
      this.medicalExamInfo,
      this.medicalTrainingInfo,
      this.requestAttachments,
      this.certificateEntityType,
      this.notes,
      this.billInfo,
      this.validToSubmit,
      this.x,
      this.y,
      this.printable});

  int? requestId;
  int? requestTypeId;
  String? requestTypeName;
  int? requestStatusId;
  String? requestStatusName;
  dynamic submitterType;
  String? requestSubmitDate;
  HealthCertificateInfo? healthCertificateInfo;
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  String? subMunicipalityName;
  ErInfo? ownerInfo;
  ErInfo? submitterInfo;
  ComLicenseInfo? comLicenseInfo;
  MedicalExamInfo? medicalExamInfo;
  MedicalTrainingInfo? medicalTrainingInfo;
  List<RequestAttachment>? requestAttachments;
  String? certificateEntityType;
  List<Note>? notes;
  BillInfo? billInfo;
  bool? validToSubmit;
  String? x;
  String? y;
  bool? printable;
  dynamic printUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      requestId: json["requestId"],
      requestTypeId: json["requestTypeId"],
      requestTypeName: json["requestTypeName"],
      requestStatusId: json["requestStatusId"],
      requestStatusName: json["requestStatusName"],
      submitterType: json["submitterType"],
      requestSubmitDate: json["requestSubmitDate"],
      healthCertificateInfo: json["healthCertificateInfo"] != null
          ? HealthCertificateInfo.fromJson(json["healthCertificateInfo"])
          : null,
      municipalityId: json["municipalityId"],
      municipalityName: json["municipalityName"],
      subMunicipalityId: json["subMunicipalityId"],
      subMunicipalityName: json["subMunicipalityName"],
      ownerInfo:
          json["ownerInfo"] != null ? ErInfo.fromJson(json["ownerInfo"]) : null,
      submitterInfo: json["submitterInfo"] != null
          ? ErInfo.fromJson(json["submitterInfo"])
          : null,
      comLicenseInfo: json["comLicenseInfo"] != null
          ? ComLicenseInfo.fromJson(json["comLicenseInfo"])
          : null,
      medicalExamInfo: json["medicalExamInfo"] != null
          ? MedicalExamInfo.fromJson(json["medicalExamInfo"])
          : null,
      medicalTrainingInfo: json["medicalTrainingInfo"] != null
          ? MedicalTrainingInfo.fromJson(json["medicalTrainingInfo"])
          : null,
      requestAttachments: json["requestAttachments"] != null
          ? List<RequestAttachment>.from(json["requestAttachments"]
              .map((x) => RequestAttachment.fromJson(x)))
          : null,
      certificateEntityType: json["certificateEntityType"],
      notes: json["notes"] != null
          ? List<Note>.from(json["notes"].map((x) => Note.fromJson(x)))
          : null,
      validToSubmit: json["validToSubmit"],
      x: json["x"],
      y: json["y"],
      billInfo:
          json["billInfo"] != null ? BillInfo.fromJson(json["billInfo"]) : null,
      printable: json["printable"]);

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requestTypeId": requestTypeId,
        "requestTypeName": requestTypeName,
        "requestStatusId": requestStatusId,
        "requestStatusName": requestStatusName,
        "submitterType": submitterType,
        "requestSubmitDate": requestSubmitDate,
        "healthCertificateInfo": healthCertificateInfo != null
            ? healthCertificateInfo!.toJson()
            : null,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "subMunicipalityName": subMunicipalityName,
        "ownerInfo": ownerInfo != null ? ownerInfo!.toJson() : null,
        "submitterInfo": submitterInfo != null ? submitterInfo!.toJson() : null,
        "comLicenseInfo": comLicenseInfo,
        "medicalExamInfo": medicalExamInfo,
        "medicalTrainingInfo": medicalTrainingInfo,
        "requestAttachments": requestAttachments,
        "certificateEntityType": certificateEntityType,
        "notes":
            notes != null ? List<dynamic>.from(notes!.map((x) => x)) : null,
        "billInfo": billInfo,
        "validToSubmit": validToSubmit,
        "x": x,
        "y": y,
      };
}

class Note {
  Note({
    this.note,
    this.date,
    this.statusName,
    this.author,
  });

  String? note;
  String? date;
  String? statusName;
  String? author;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        note: json["note"],
        date: json["date"],
        statusName: json["statusName"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "date": date,
        "statusName": statusName,
        "author": author,
      };
}

class ComLicenseInfo {
  ComLicenseInfo({
    this.licenseNumber,
    this.activityId,
    this.activityName,
    this.isicNumber,
    this.isicName,
    this.districatId,
    this.districtName,
    this.longitude,
    this.latitude,
    this.streetId,
    this.streetName,
    this.licenseStatusName,
  });

  int? licenseNumber;
  int? activityId;
  String? activityName;
  String? isicNumber;
  String? isicName;
  int? districatId;
  String? districtName;
  String? longitude;
  String? latitude;
  int? streetId;
  String? streetName;
  String? licenseStatusName;

  factory ComLicenseInfo.fromJson(Map<String, dynamic> json) => ComLicenseInfo(
        licenseNumber: json["licenseNumber"],
        activityId: json["activityId"],
        activityName: json["activityName"],
        isicNumber: json["isicNumber"],
        isicName: json["isicName"],
        districatId: json["districatId"],
        districtName: json["districtName"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        streetId: json["streetId"],
        streetName: json["streetName"],
        licenseStatusName: json["licenseStatusName"],
      );

  Map<String, dynamic> toJson() => {
        "licenseNumber": licenseNumber,
        "activityId": activityId,
        "activityName": activityName,
        "isicNumber": isicNumber,
        "isicName": isicName,
        "districatId": districatId,
        "districtName": districtName,
        "longitude": longitude,
        "latitude": latitude,
        "streetId": streetId,
        "streetName": streetName,
        "licenseStatusName": licenseStatusName,
      };
}

class RequestAttachment {
  RequestAttachment({
    this.id,
    this.name,
    this.allowedFilesExtension,
    this.isMandatory,
    this.attached,
    this.approved,
    this.attachUrl,
    this.notes,
    this.updatable,
  });

  int? id;
  String? name;
  String? allowedFilesExtension;
  bool? isMandatory;
  bool? attached;
  bool? approved;
  String? attachUrl;
  dynamic notes;
  bool? updatable;

  factory RequestAttachment.fromJson(Map<String, dynamic> json) =>
      RequestAttachment(
        id: json["id"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        isMandatory: json["isMandatory"],
        attached: json["attached"],
        approved: json["approved"],
        attachUrl: json["attachUrl"],
        notes: json["notes"],
        updatable: json["updatable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "allowedFilesExtension": allowedFilesExtension,
        "isMandatory": isMandatory,
        "attached": attached,
        "approved": approved,
        "attachUrl": attachUrl,
        "notes": notes,
        "updatable": updatable,
      };
}

class MedicalTrainingInfo {
  MedicalTrainingInfo({
    this.id,
    this.startDate,
    this.expiryDate,
    this.trainingCenter,
    this.passed,
  });

  int? id;
  String? startDate;
  String? expiryDate;
  String? trainingCenter;
  bool? passed;

  factory MedicalTrainingInfo.fromJson(Map<String, dynamic> json) =>
      MedicalTrainingInfo(
        id: json["id"],
        startDate: json["startDate"],
        expiryDate: json["expiryDate"],
        trainingCenter: json["trainingCenter"],
        passed: json["passed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate,
        "expiryDate": expiryDate,
        "trainingCenter": trainingCenter,
        "passed": passed,
      };
}

class HealthCertificateInfo {
  HealthCertificateInfo(
      {this.certificateId,
      this.issueDate,
      this.expiryDate,
      this.statusId,
      this.statusName,
      this.notes,
      this.certificateUuid,
      this.expiryDateG,
      this.issueDateG});

  int? certificateId;
  String? issueDate;
  String? expiryDate;
  String? issueDateG;
  String? expiryDateG;
  int? statusId;
  String? statusName;
  dynamic notes;
  String? certificateUuid;

  factory HealthCertificateInfo.fromJson(Map<String, dynamic> json) =>
      HealthCertificateInfo(
          certificateId: json["certificateId"],
          issueDate: json["issueDate"],
          issueDateG: json["issueDateG"],
          expiryDateG: json["expiryDateG"],
          expiryDate: json["expiryDate"],
          statusId: json["statusId"],
          statusName: json["statusName"],
          notes: json["notes"],
          certificateUuid: json["certificateUuid"]);

  Map<String, dynamic> toJson() => {
        "certificateId": certificateId,
        "issueDate": issueDate,
        "expiryDate": expiryDate,
        "statusId": statusId,
        "statusName": statusName,
        "notes": notes,
      };
}

class MedicalExamInfo {
  MedicalExamInfo({
    this.id,
    this.examCode,
    this.examDate,
    this.examStartDate,
    this.examExpiryDate,
    this.hospitalName,
    this.medicallyFit,
    this.medicallyUnFitReason,
  });

  int? id;
  String? examCode;
  String? examDate;
  String? examStartDate;
  dynamic examExpiryDate;
  String? hospitalName;
  bool? medicallyFit;
  dynamic medicallyUnFitReason;

  factory MedicalExamInfo.fromJson(Map<String, dynamic> json) =>
      MedicalExamInfo(
        id: json["id"],
        examCode: json["examCode"],
        examDate: json["examDate"],
        examStartDate: json["examStartDate"],
        examExpiryDate: json["examExpiryDate"],
        hospitalName: json["hospitalName"],
        medicallyFit: json["medicallyFit"],
        medicallyUnFitReason: json["medicallyUnFitReason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examCode": examCode,
        "examDate": examDate,
        "examStartDate": examStartDate,
        "examExpiryDate": examExpiryDate,
        "hospitalName": hospitalName,
        "medicallyFit": medicallyFit,
        "medicallyUnFitReason": medicallyUnFitReason,
      };
}

class ErInfo {
  ErInfo({
    this.identityNumber,
    this.identityTypeId,
    this.identityTypeName,
    this.firstName,
    this.fatherName,
    this.grandFatherName,
    this.familyName,
    this.fullName,
    this.birthDate,
    this.nationalityCode,
    this.nationalityName,
    this.professionId,
    this.professionName,
    this.mobile,
    this.email,
  });

  int? identityNumber;
  int? identityTypeId;
  String? identityTypeName;
  String? firstName;
  String? fatherName;
  dynamic grandFatherName;
  String? familyName;
  String? fullName;
  String? birthDate;
  int? nationalityCode;
  String? nationalityName;
  int? professionId;
  String? professionName;
  String? mobile;
  dynamic email;

  factory ErInfo.fromJson(Map<String, dynamic> json) => ErInfo(
        identityNumber: json["identityNumber"],
        identityTypeId: json["identityTypeId"],
        identityTypeName: json["identityTypeName"],
        firstName: json["firstName"],
        fatherName: json["fatherName"],
        grandFatherName: json["grandFatherName"],
        familyName: json["familyName"],
        fullName: json["fullName"],
        birthDate: json["birthDate"],
        nationalityCode: json["nationalityCode"],
        nationalityName: json["nationalityName"],
        professionId: json["professionId"],
        professionName: json["professionName"],
        mobile: json["mobile"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "identityTypeId": identityTypeId,
        "identityTypeName": identityTypeName,
        "firstName": firstName,
        "fatherName": fatherName,
        "grandFatherName": grandFatherName,
        "familyName": familyName,
        "fullName": fullName,
        "birthDate": birthDate,
        "nationalityCode": nationalityCode,
        "nationalityName": nationalityName,
        "professionId": professionId,
        "professionName": professionName,
        "mobile": mobile,
        "email": email,
      };
}

class StatusDetail {
  StatusDetail({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) => StatusDetail(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class BillInfo {
  BillInfo({
    this.billNumber,
    this.billAmount,
    this.billCreationDate,
    this.billStatus,
    this.billFees,
    this.billCreated,
    this.warnings,
  });

  String? billNumber;
  dynamic billAmount;
  String? billCreationDate;
  bool? billCreated;
  List<String>? warnings;
  String? billStatus;
  List<BillFee>? billFees;

  factory BillInfo.fromJson(Map<String, dynamic> json) => BillInfo(
        billNumber: json["billNumber"],
        billAmount: json["billAmount"],
        billCreationDate: json["billCreationDate"],
        billStatus: json["billStatus"],
        billCreated: json["billCreated"],
        warnings: json["warnings"] != null
            ? List<String>.from(json["warnings"].map((x) => x))
            : null,
        billFees: json["billFees"] != null
            ? List<BillFee>.from(
                json["billFees"].map((x) => BillFee.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "billNumber": billNumber,
        "billAmount": billAmount,
        "billCreationDate": billCreationDate,
        "billStatus": billStatus,
        "billFees": List<dynamic>.from(billFees!.map((x) => x.toJson())),
      };

  LICENSE_MANAGEMENT_STATUS getBillStatus() {
    return billStatus == "مدفوع"
        ? LICENSE_MANAGEMENT_STATUS.ACTIVE
        : LICENSE_MANAGEMENT_STATUS.DRAFT;
  }
}

class BillFee {
  BillFee({
    this.costItemValue,
    this.costItemTypeId,
    this.costItemDescription,
  });

  dynamic costItemValue;
  dynamic costItemTypeId;
  String? costItemDescription;

  factory BillFee.fromJson(Map<String, dynamic> json) => BillFee(
        costItemValue: json["costItemValue"],
        costItemTypeId: json["costItemTypeId"],
        costItemDescription: json["costItemDescription"],
      );

  Map<String, dynamic> toJson() => {
        "costItemValue": costItemValue,
        "costItemTypeId": costItemTypeId,
        "costItemDescription": costItemDescription,
      };
}
