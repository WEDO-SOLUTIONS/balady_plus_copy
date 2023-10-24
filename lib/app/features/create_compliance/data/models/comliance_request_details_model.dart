import 'package:equatable/equatable.dart';

import '../../create_compliance_exports.dart';

class ComplianceRequestDetailsModel extends ComplianceRequestDetails {
  ComplianceRequestDetailsModel(
      {super.requestId,
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
      super.mainEmtithalItemsDto});

  factory ComplianceRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    ComplianceRequestDetailsModel? details = ComplianceRequestDetailsModel(
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
      ownerDto:
          json["ownerDto"] == null ? null : OwnerDto.fromJson(json["ownerDto"]),
      designerOfficeId: json["designerOfficeId"],
      designerOfficeName: json["designerOfficeName"],
      designerOfficeMobile: json["designerOfficeMobile"],
      designerOfficeMail: json["designerOfficeMail"],
      beneficaryAttachments: json["beneficaryAttachments"] == null
          ? []
          : List<AttachmentModel>.from(json["beneficaryAttachments"]!
              .map((x) => AttachmentModel.fromJson(x))),
      officeAttachments: json["officeAttachments"] == null
          ? []
          : List<Attachment>.from(json["officeAttachments"]!
              .map((x) => AttachmentModel.fromJson(x))),
      requestAttachments: json["requestAttachments"] == null
          ? []
          : List<Attachment>.from(json["requestAttachments"]!
              .map((x) => AttachmentModel.fromJson(x))),
      notes: json["notes"] == null
          ? []
          : List<Note>.from(json["notes"]!.map((x) => Note.fromJson(x))),
      locationResponseInfoDto: json["locationResponseInfoDto"] == null
          ? null
          : LocationResponseInfoDto.fromJson(json["locationResponseInfoDto"]),
      isFawry: json["isFawry"],
      emtithalItems: json["emtithalItems"] == null
          ? []
          : List<EmtithalItemModel>.from(
              json["emtithalItems"]!.map((x) => EmtithalItemModel.fromJson(x))),
      ownershipDocInfoDto: json["ownershipDocInfoDto"] == null
          ? null
          : OwnershipDocInfoDto.fromJson(json["ownershipDocInfoDto"]),
      requestOwnersDto: json["requestOwnersDto"] == null
          ? []
          : List<dynamic>.from(json["requestOwnersDto"]!.map((x) => x)),
      mainEmtithalItemsDto: json["mainEmtithalItemsDto"] == null
          ? []
          : List<MainEmtithalItemsDtoModel>.from(json["mainEmtithalItemsDto"]!
              .map((x) => MainEmtithalItemsDtoModel.fromJson(x))),
      etmamOrderResponseDto: json["etmamOrderResponseDto"],
      usageDisable: json["usageDisable"],
    );

    List<EmtithalItem> emtithalItems = [];

    details.mainEmtithalItemsDto?.forEach((element) {
      element.subEmtithalItems?.forEach((element) {
        EmtithalItem item = EmtithalItem(
            empAnswer: element.empAnswer,
            submitterAnswer: element.submitterAnswer,
            itemDesc: element.itemDesc,
            itemId: element.itemId,
            momItemId: element.momItemId);
        emtithalItems.add(item);
      });
    });

    details.emtithalItems = emtithalItems;
    return details;
  }

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
        landNumber: json["landsInfo"] != null
            ? json["landsInfo"][0] != null
                ? (json["landsInfo"][0]!["landNumber"]).toString()
                : null
            : null,
        landArea: json["landsInfo"] != null
            ? json["landsInfo"][0] != null
                ? (json["landsInfo"][0]!["landArea"]).toString()
                : null
            : null,
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

class MainEmtithalItemsDtoModel extends MainEmtithalItemsDto {
  MainEmtithalItemsDtoModel({
    super.mainItemId,
    super.mainItemDesc,
    super.subEmtithalItems,
  });

  factory MainEmtithalItemsDtoModel.fromJson(Map<String, dynamic> json) =>
      MainEmtithalItemsDtoModel(
        mainItemId: json["mainItemId"],
        mainItemDesc: json["mainItemDesc"],
        subEmtithalItems: json["subEmtithalItems"] == null
            ? []
            : List<SubEmtithalItemModel>.from(json["subEmtithalItems"]!
                .map((x) => SubEmtithalItemModel.fromJson(x))),
      );
}

class SubEmtithalItemModel extends SubEmtithalItem {
  SubEmtithalItemModel({
    super.itemId,
    super.momItemId,
    super.itemDesc,
    super.submitterAnswer,
    super.empAnswer,
  });

  factory SubEmtithalItemModel.fromJson(Map<String, dynamic> json) =>
      SubEmtithalItemModel(
        itemId: json["itemId"],
        momItemId: json["momItemId"],
        itemDesc: json["itemDesc"],
        submitterAnswer: json["submitterAnswer"],
        empAnswer: json["empAnswer"],
      );
}
