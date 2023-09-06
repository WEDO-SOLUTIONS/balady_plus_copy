import 'package:equatable/equatable.dart';

import '../../../vd/domain/entities/gis/gis_params.dart';

class ComplianceRequestDetails extends Equatable {
  final int? requestId;
  final dynamic requestNote;
  final String? creationDate;
  final dynamic emtithalCertNumber;
  final dynamic emtithalCertIssueDate;
  final int? currentTabId;
  final int? typeId;
  final String? typeName;
  final int? statusId;
  final String? statusName;
  final String? submitterThrough;
  final String? submitterType;
  final String? certificateBaseType;
  final dynamic licenseNumber;
  final dynamic licenseIssueDate;
  final dynamic licenseExpiryDate;
  final dynamic licenseStatusId;
  final dynamic licenseStatusName;
  final dynamic licenseDescription;
  final dynamic oldLicenseNumber;
  final String? issuingMunicipalityName;
  final int? mainUsageCode;
  final String? mainUsageName;
  final int? subUsageCode;
  final String? subUsageName;
  final dynamic buildArea;
  final dynamic agentType;
  final dynamic agentTypeName;
  final SubmitterDto? submitterDto;
  final OwnerDto? ownerDto;
  final String? designerOfficeId;
  final String? designerOfficeName;
  final String? designerOfficeMobile;
  final String? designerOfficeMail;
  final List<Attachment>? beneficaryAttachments;
  final List<Attachment>? officeAttachments;
  final List<Attachment>? requestAttachments;
  final List<dynamic>? notes;
  final LocationResponseInfoDto? locationResponseInfoDto;
  final bool? isFawry;
  final List<EmtithalItem>? emtithalItems;
  final OwnershipDocInfoDto? ownershipDocInfoDto;
  final List<dynamic>? requestOwnersDto;
  final dynamic etmamOrderResponseDto;
  final bool? usageDisable;

  ComplianceRequestDetails({
    this.requestId,
    this.requestNote,
    this.creationDate,
    this.emtithalCertNumber,
    this.emtithalCertIssueDate,
    this.currentTabId,
    this.typeId,
    this.typeName,
    this.statusId,
    this.statusName,
    this.submitterThrough,
    this.submitterType,
    this.certificateBaseType,
    this.licenseNumber,
    this.licenseIssueDate,
    this.licenseExpiryDate,
    this.licenseStatusId,
    this.licenseStatusName,
    this.licenseDescription,
    this.oldLicenseNumber,
    this.issuingMunicipalityName,
    this.mainUsageCode,
    this.mainUsageName,
    this.subUsageCode,
    this.subUsageName,
    this.buildArea,
    this.agentType,
    this.agentTypeName,
    this.submitterDto,
    this.ownerDto,
    this.designerOfficeId,
    this.designerOfficeName,
    this.designerOfficeMobile,
    this.designerOfficeMail,
    this.beneficaryAttachments,
    this.officeAttachments,
    this.requestAttachments,
    this.notes,
    this.locationResponseInfoDto,
    this.isFawry,
    this.emtithalItems,
    this.ownershipDocInfoDto,
    this.requestOwnersDto,
    this.etmamOrderResponseDto,
    this.usageDisable,
  });

  factory ComplianceRequestDetails.fromJson(Map<String, dynamic> json) =>
      ComplianceRequestDetails(
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

class Attachment {
  final int? id;
  final String? name;
  final String? allowedFilesExtension;
  final bool? isMandatory;
  final bool? attached;
  final bool? approved;
  final String? attachUrl;
  final dynamic notes;
  final bool? updatable;
  final int? maxSize;
  final String? attachDescription;
  final String? fileName;

  Attachment({
    this.id,
    this.name,
    this.allowedFilesExtension,
    this.isMandatory,
    this.attached,
    this.approved,
    this.attachUrl,
    this.notes,
    this.updatable,
    this.maxSize,
    this.attachDescription,
    this.fileName,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
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
        fileName: json["fileName"],
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
        "maxSize": maxSize,
        "attachDescription": attachDescription,
        "fileName": fileName,
      };
}

class EmtithalItem {
  final int? itemId;
  final String? momItemId;
  final String? itemDesc;
  bool? submitterAnswer;
  final dynamic empAnswer;

  EmtithalItem({
    this.itemId,
    this.momItemId,
    this.itemDesc,
    this.submitterAnswer,
    this.empAnswer,
  });

  factory EmtithalItem.fromJson(Map<String, dynamic> json) => EmtithalItem(
        itemId: json["itemId"],
        momItemId: json["momItemId"],
        itemDesc: json["itemDesc"],
        submitterAnswer: json["submitterAnswer"],
        empAnswer: json["empAnswer"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "momItemId": momItemId,
        "itemDesc": itemDesc,
        "submitterAnswer": submitterAnswer,
        "empAnswer": empAnswer,
      };
}

class LocationResponseInfoDto {
  final String? municipalityId;
  final int? amanahId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final int? baladiaId;
  final String? subMunicipalityName;
  final int? districtId;
  final String? districtName;
  final int? cityId;
  final String? cityName;
  final int? streetId;
  final String? streetName;
  final String? mapNumber;
  final dynamic mapName;
  final String? x;
  final String? y;
  final String? landNumber;
  final String? landArea;
  final dynamic isLocationCorrect;
  final dynamic guid;

  LocationResponseInfoDto({
    this.municipalityId,
    this.amanahId,
    this.municipalityName,
    this.subMunicipalityId,
    this.baladiaId,
    this.subMunicipalityName,
    this.districtId,
    this.districtName,
    this.cityId,
    this.cityName,
    this.streetId,
    this.streetName,
    this.mapNumber,
    this.mapName,
    this.x,
    this.y,
    this.landNumber,
    this.landArea,
    this.isLocationCorrect,
    this.guid,
  });

  factory LocationResponseInfoDto.fromJson(Map<String, dynamic> json) =>
      LocationResponseInfoDto(
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

  Map<String, dynamic> toJson() => {
        "municipalityId": municipalityId,
        "amanahId": amanahId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "baladiaId": baladiaId,
        "subMunicipalityName": subMunicipalityName,
        "districtId": districtId,
        "districtName": districtName,
        "cityId": cityId,
        "cityName": cityName,
        "streetId": streetId,
        "streetName": streetName,
        "mapNumber": mapNumber,
        "mapName": mapName,
        "x": x,
        "y": y,
        "landNumber": landNumber,
        "landArea": landArea,
        "isLocationCorrect": isLocationCorrect,
        "guid": guid,
      };

  String getFullAddress({
    bool includeStreetName = true,
    bool includeDistrictName = true,
    bool includeSubMunicipalityName = true,
    bool includeAdminMunicipalityName = true,
  }) {
    String address = "";
    var streetName = this.streetName;
    var districtName = this.districtName;
    var subMunicipalityName = this.subMunicipalityName;
    var adminMunicipalityName = this.municipalityName;

    if (includeStreetName &&
        streetName != null &&
        streetName.toLowerCase() != "null" &&
        streetName.isNotEmpty) address += "$streetName, ";

    if (includeDistrictName &&
        districtName != null &&
        districtName.toLowerCase() != "null" &&
        districtName.isNotEmpty) address += "$districtName, ";

    if (includeSubMunicipalityName &&
        subMunicipalityName != null &&
        subMunicipalityName.toLowerCase() != "null" &&
        subMunicipalityName.isNotEmpty) address += "$subMunicipalityName, ";

    if (includeAdminMunicipalityName &&
        adminMunicipalityName != null &&
        adminMunicipalityName.isNotEmpty) {
      address += adminMunicipalityName;
    }

    return address;
  }

  double? getX() {
    return x != null ? double.tryParse(x!) : null;
  }

  double? getY() {
    return y != null ? double.tryParse(y!) : null;
  }

  GISParams? gisParams() {
    return getX() != null && getY() != null
        ? GISParams(x: getX()!, y: getY()!)
        : null;
  }
}

class OwnerDto {
  final String? identityNumber;
  final int? identityType;
  final String? identityTypeDec;
  final String? ownerName;
  final dynamic agentType;
  final dynamic agencyDto;
  final bool? specialIqama;

  OwnerDto({
    this.identityNumber,
    this.identityType,
    this.identityTypeDec,
    this.ownerName,
    this.agentType,
    this.agencyDto,
    this.specialIqama,
  });

  factory OwnerDto.fromJson(Map<String, dynamic> json) => OwnerDto(
        identityNumber: json["identityNumber"],
        identityType: json["identityType"],
        identityTypeDec: json["identityTypeDec"],
        ownerName: json["ownerName"],
        agentType: json["agentType"],
        agencyDto: json["agencyDto"],
        specialIqama: json["specialIqama"],
      );

  Map<String, dynamic> toJson() => {
        "identityNumber": identityNumber,
        "identityType": identityType,
        "identityTypeDec": identityTypeDec,
        "ownerName": ownerName,
        "agentType": agentType,
        "agencyDto": agencyDto,
        "specialIqama": specialIqama,
      };
}

class OwnershipDocInfoDto {
  final int? ownershipDocumentType;
  final String? ownerShipDocTypeName;
  final String? ownershipDocumentNo;
  final String? ownershipDocumentDate;
  final dynamic ownersInfo;
  final bool? paper;

  OwnershipDocInfoDto({
    this.ownershipDocumentType,
    this.ownerShipDocTypeName,
    this.ownershipDocumentNo,
    this.ownershipDocumentDate,
    this.ownersInfo,
    this.paper,
  });

  factory OwnershipDocInfoDto.fromJson(Map<String, dynamic> json) =>
      OwnershipDocInfoDto(
        ownershipDocumentType: json["ownershipDocumentType"],
        ownerShipDocTypeName: json["ownerShipDocTypeName"],
        ownershipDocumentNo: json["ownershipDocumentNo"],
        ownershipDocumentDate: json["ownershipDocumentDate"],
        ownersInfo: json["ownersInfo"],
        paper: json["paper"],
      );

  Map<String, dynamic> toJson() => {
        "ownershipDocumentType": ownershipDocumentType,
        "ownerShipDocTypeName": ownerShipDocTypeName,
        "ownershipDocumentNo": ownershipDocumentNo,
        "ownershipDocumentDate": ownershipDocumentDate,
        "ownersInfo": ownersInfo,
        "paper": paper,
      };
}

class SubmitterDto {
  final String? submitterIdNumber;
  final String? submitterBirthDate;
  final String? submitterTypeDesc;
  final String? mobile;
  final String? mail;
  final int? gender;
  final String? genderName;
  final String? submitterName;
  final int? submitterIdentityType;
  final String? submitterIdentityTypeName;

  SubmitterDto({
    this.submitterIdNumber,
    this.submitterBirthDate,
    this.submitterTypeDesc,
    this.mobile,
    this.mail,
    this.gender,
    this.genderName,
    this.submitterName,
    this.submitterIdentityType,
    this.submitterIdentityTypeName,
  });

  factory SubmitterDto.fromJson(Map<String, dynamic> json) => SubmitterDto(
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

  Map<String, dynamic> toJson() => {
        "submitterIdNumber": submitterIdNumber,
        "submitterBirthDate": submitterBirthDate,
        "submitterTypeDesc": submitterTypeDesc,
        "mobile": mobile,
        "mail": mail,
        "gender": gender,
        "genderName": genderName,
        "submitterName": submitterName,
        "submitterIdentityType": submitterIdentityType,
        "submitterIdentityTypeName": submitterIdentityTypeName,
      };
}
