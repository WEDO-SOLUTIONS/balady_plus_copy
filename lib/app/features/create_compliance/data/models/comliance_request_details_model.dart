import 'package:equatable/equatable.dart';

import '../../create_compliance_exports.dart';

class ComplianceRequestDetailsModel extends ComplianceRequestDetails {
  ComplianceRequestDetailsModel({
    super.requestId,
    super.requestNote,
    super.creationDate,
    super.emtithalCertNumber,
    super.emtithalCertIssueDate,
    super.currentTabId,
    super.typeId,
    super.typeName,
    super.statusId,
    super.statusName,
    super.submitterThrough,
    super.submitterType,
    super.certificateBaseType,
    super.licenseNumber,
    super.licenseIssueDate,
    super.licenseExpiryDate,
    super.licenseStatusId,
    super.licenseStatusName,
    super.licenseDescription,
    super.oldLicenseNumber,
    super.issuingMunicipalityName,
    super.mainUsageCode,
    super.mainUsageName,
    super.subUsageCode,
    super.subUsageName,
    super.buildArea,
    super.agentType,
    super.agentTypeName,
    super.submitterDto,
    super.ownerDto,
    super.designerOfficeId,
    super.designerOfficeName,
    super.designerOfficeMobile,
    super.designerOfficeMail,
    super.beneficaryAttachments,
    super.officeAttachments,
    super.requestAttachments,
    super.notes,
    super.locationResponseInfoDto,
    super.isFawry,
    super.emtithalItems,
    super.ownershipDocInfoDto,
    super.requestOwnersDto,
    super.etmamOrderResponseDto,
    super.usageDisable,
  });

  factory ComplianceRequestDetailsModel.fromJson(Map<String, dynamic> json) =>
      ComplianceRequestDetailsModel(
        requestId: json["requestId"],
        requestNote: json["requestNote"],
        creationDate: json["creationDate"],
        emtithalCertNumber: json["emtithalCertNumber"],
        emtithalCertIssueDate: json["emtithalCertIssueDate"],
        currentTabId: json["currentTabId"],
        typeId: json["typeId"],
        typeName: json["typeName"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        submitterThrough: json["submitterThrough"],
        submitterType: json["submitterType"],
        certificateBaseType: json["certificateBaseType"],
        licenseNumber: json["licenseNumber"],
        licenseIssueDate: json["licenseIssueDate"],
        licenseExpiryDate: json["licenseExpiryDate"],
        licenseStatusId: json["licenseStatusId"],
        licenseStatusName: json["licenseStatusName"],
        licenseDescription: json["licenseDescription"],
        oldLicenseNumber: json["oldLicenseNumber"],
        issuingMunicipalityName: json["issuingMunicipalityName"],
        mainUsageCode: json["mainUsageCode"],
        mainUsageName: json["mainUsageName"],
        subUsageCode: json["subUsageCode"],
        subUsageName: json["subUsageName"],
        buildArea: json["buildArea"],
        agentType: json["agentType"],
        agentTypeName: json["agentTypeName"],
        submitterDto: json["submitterDto"] == null
            ? null
            : SubmitterDto.fromJson(json["submitterDto"]),
        ownerDto: json["ownerDto"] == null
            ? null
            : OwnerDto.fromJson(json["ownerDto"]),
        designerOfficeId: json["designerOfficeId"],
        designerOfficeName: json["designerOfficeName"],
        designerOfficeMobile: json["designerOfficeMobile"],
        designerOfficeMail: json["designerOfficeMail"],
        beneficaryAttachments: json["beneficaryAttachments"] == null
            ? []
            : List<Attachment>.from(json["beneficaryAttachments"]!
                .map((x) => Attachment.fromJson(x))),
        officeAttachments: json["officeAttachments"] == null
            ? []
            : List<Attachment>.from(
                json["officeAttachments"]!.map((x) => Attachment.fromJson(x))),
        requestAttachments: json["requestAttachments"] == null
            ? []
            : List<Attachment>.from(
                json["requestAttachments"]!.map((x) => Attachment.fromJson(x))),
        notes: json["notes"] == null
            ? []
            : List<dynamic>.from(json["notes"]!.map((x) => x)),
        locationResponseInfoDto: json["locationResponseInfoDto"] == null
            ? null
            : LocationResponseInfoDto.fromJson(json["locationResponseInfoDto"]),
        isFawry: json["isFawry"],
        emtithalItems: json["emtithalItems"] == null
            ? []
            : List<EmtithalItem>.from(
                json["emtithalItems"]!.map((x) => EmtithalItem.fromJson(x))),
        ownershipDocInfoDto: json["ownershipDocInfoDto"] == null
            ? null
            : OwnershipDocInfoDto.fromJson(json["ownershipDocInfoDto"]),
        requestOwnersDto: json["requestOwnersDto"] == null
            ? []
            : List<dynamic>.from(json["requestOwnersDto"]!.map((x) => x)),
        etmamOrderResponseDto: json["etmamOrderResponseDto"],
        usageDisable: json["usageDisable"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requestNote": requestNote,
        "creationDate": creationDate,
        "emtithalCertNumber": emtithalCertNumber,
        "emtithalCertIssueDate": emtithalCertIssueDate,
        "currentTabId": currentTabId,
        "typeId": typeId,
        "typeName": typeName,
        "statusId": statusId,
        "statusName": statusName,
        "submitterThrough": submitterThrough,
        "submitterType": submitterType,
        "certificateBaseType": certificateBaseType,
        "licenseNumber": licenseNumber,
        "licenseIssueDate": licenseIssueDate,
        "licenseExpiryDate": licenseExpiryDate,
        "licenseStatusId": licenseStatusId,
        "licenseStatusName": licenseStatusName,
        "licenseDescription": licenseDescription,
        "oldLicenseNumber": oldLicenseNumber,
        "issuingMunicipalityName": issuingMunicipalityName,
        "mainUsageCode": mainUsageCode,
        "mainUsageName": mainUsageName,
        "subUsageCode": subUsageCode,
        "subUsageName": subUsageName,
        "buildArea": buildArea,
        "agentType": agentType,
        "agentTypeName": agentTypeName,
        "submitterDto": submitterDto?.toJson(),
        "ownerDto": ownerDto?.toJson(),
        "designerOfficeId": designerOfficeId,
        "designerOfficeName": designerOfficeName,
        "designerOfficeMobile": designerOfficeMobile,
        "designerOfficeMail": designerOfficeMail,
        "beneficaryAttachments": beneficaryAttachments == null
            ? []
            : List<dynamic>.from(beneficaryAttachments!.map((x) => x.toJson())),
        "officeAttachments": officeAttachments == null
            ? []
            : List<dynamic>.from(officeAttachments!.map((x) => x.toJson())),
        "requestAttachments": requestAttachments == null
            ? []
            : List<dynamic>.from(requestAttachments!.map((x) => x.toJson())),
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
        "locationResponseInfoDto": locationResponseInfoDto?.toJson(),
        "isFawry": isFawry,
        "emtithalItems": emtithalItems == null
            ? []
            : List<dynamic>.from(emtithalItems!.map((x) => x.toJson())),
        "ownershipDocInfoDto": ownershipDocInfoDto?.toJson(),
        "requestOwnersDto": requestOwnersDto == null
            ? []
            : List<dynamic>.from(requestOwnersDto!.map((x) => x)),
        "etmamOrderResponseDto": etmamOrderResponseDto,
        "usageDisable": usageDisable,
      };
  @override
  List<Object?> get props => [];
}

class AttachmentModel extends Attachment {
  AttachmentModel({
    super.id,
    super.name,
    super.allowedFilesExtension,
    super.isMandatory,
    super.attached,
    super.approved,
    super.attachUrl,
    super.notes,
    super.updatable,
    super.maxSize,
    super.attachDescription,
    super.fileName,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      AttachmentModel(
        id: json["id"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        isMandatory: json["isMandatory"],
        attached: json["attached"],
        approved: json["approved"],
        attachUrl: json["attachUrl"],
        notes: json["notes"],
        updatable: json["updatable"],
        maxSize: json["maxSize"],
        attachDescription: json["attachDescription"],
        fileName: json["fileName"] ?? json["originFileName"],
      );
}

class EmtithalItemModel extends EmtithalItem {
  EmtithalItemModel({
    super.itemId,
    super.momItemId,
    super.itemDesc,
    super.submitterAnswer,
    super.empAnswer,
  });

  factory EmtithalItemModel.fromJson(Map<String, dynamic> json) =>
      EmtithalItemModel(
        itemId: json["itemId"],
        momItemId: json["momItemId"],
        itemDesc: json["itemDesc"],
        submitterAnswer: json["submitterAnswer"],
        empAnswer: json["empAnswer"],
      );
}

class LocationResponseInfoDtoModel extends LocationResponseInfoDto {
  LocationResponseInfoDtoModel({
    super.municipalityId,
    super.amanahId,
    super.municipalityName,
    super.subMunicipalityId,
    super.baladiaId,
    super.subMunicipalityName,
    super.districtId,
    super.districtName,
    super.cityId,
    super.cityName,
    super.streetId,
    super.streetName,
    super.mapNumber,
    super.mapName,
    super.x,
    super.y,
    super.landNumber,
    super.landArea,
    super.isLocationCorrect,
    super.guid,
  });

  factory LocationResponseInfoDtoModel.fromJson(Map<String, dynamic> json) =>
      LocationResponseInfoDtoModel(
        municipalityId: json["municipalityId"],
        amanahId: json["amanahId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        baladiaId: json["baladiaId"],
        subMunicipalityName: json["subMunicipalityName"],
        districtId: json["districtId"],
        districtName: json["districtName"],
        cityId: json["cityId"],
        cityName: json["cityName"],
        streetId: json["streetId"],
        streetName: json["streetName"],
        mapNumber: json["mapNumber"],
        mapName: json["mapName"],
        x: json["x"],
        y: json["y"],
        landNumber: json["landNumber"],
        landArea: json["landArea"],
        isLocationCorrect: json["isLocationCorrect"],
        guid: json["guid"],
      );
}

class OwnerDtoModel extends OwnerDto {
  OwnerDtoModel({
    super.identityNumber,
    super.identityType,
    super.identityTypeDec,
    super.ownerName,
    super.agentType,
    super.agencyDto,
    super.specialIqama,
  });

  factory OwnerDtoModel.fromJson(Map<String, dynamic> json) => OwnerDtoModel(
        identityNumber: json["identityNumber"],
        identityType: json["identityType"],
        identityTypeDec: json["identityTypeDec"],
        ownerName: json["ownerName"],
        agentType: json["agentType"],
        agencyDto: json["agencyDto"],
        specialIqama: json["specialIqama"],
      );
}

class OwnershipDocInfoDtoModel extends OwnershipDocInfoDto {
  OwnershipDocInfoDtoModel({
    super.ownershipDocumentType,
    super.ownerShipDocTypeName,
    super.ownershipDocumentNo,
    super.ownershipDocumentDate,
    super.ownersInfo,
    super.paper,
  });

  factory OwnershipDocInfoDtoModel.fromJson(Map<String, dynamic> json) =>
      OwnershipDocInfoDtoModel(
        ownershipDocumentType: json["ownershipDocumentType"],
        ownerShipDocTypeName: json["ownerShipDocTypeName"],
        ownershipDocumentNo: json["ownershipDocumentNo"],
        ownershipDocumentDate: json["ownershipDocumentDate"],
        ownersInfo: json["ownersInfo"],
        paper: json["paper"],
      );
}

class SubmitterDtoModel extends SubmitterDto {
  SubmitterDtoModel({
    super.submitterIdNumber,
    super.submitterBirthDate,
    super.submitterTypeDesc,
    super.mobile,
    super.mail,
    super.gender,
    super.genderName,
    super.submitterName,
    super.submitterIdentityType,
    super.submitterIdentityTypeName,
  });

  factory SubmitterDtoModel.fromJson(Map<String, dynamic> json) =>
      SubmitterDtoModel(
        submitterIdNumber: json["submitterIdNumber"],
        submitterBirthDate: json["submitterBirthDate"],
        submitterTypeDesc: json["submitterTypeDesc"],
        mobile: json["mobile"],
        mail: json["mail"],
        gender: json["gender"],
        genderName: json["genderName"],
        submitterName: json["submitterName"],
        submitterIdentityType: json["submitterIdentityType"],
        submitterIdentityTypeName: json["submitterIdentityTypeName"],
      );
}
