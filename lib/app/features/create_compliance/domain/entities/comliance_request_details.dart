import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../vd/domain/entities/gis/gis_params.dart';
import 'dart:convert' as c;

import '../../data/models/comliance_request_details_model.dart';

class ComplianceRequestDetails extends Equatable {
  final int? requestId;
  final String? requestNote;
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
  final List<Note>? notes;
  final LocationResponseInfoDto? locationResponseInfoDto;
  final bool? isFawry;
  List<EmtithalItem>? emtithalItems;
  final OwnershipDocInfoDto? ownershipDocInfoDto;
  final List<dynamic>? requestOwnersDto;
  final dynamic etmamOrderResponseDto;
  final bool? usageDisable;
  final bool? isRequestReturnedFromMunicipality;
  final List<MainEmtithalItemsDto>? mainEmtithalItemsDto;
  final List<ApplicantNote>? applicantNotes;
   bool? isReadOnly;
   bool? showMomtathelVisitSection;

  ComplianceRequestDetails(
      {this.requestId,
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
      this.mainEmtithalItemsDto,
      this.isRequestReturnedFromMunicipality,
      this.applicantNotes,
      this.isReadOnly,
      this.showMomtathelVisitSection});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ApplicantNote {
  final String? note;
  final String? date;
  final String? statusName;
  final String? author;
  final AttachmentDto? noteAttachment;

  ApplicantNote({
    this.note,
    this.date,
    this.statusName,
    this.author,
    this.noteAttachment,
  });
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
}

class EmtithalItem {
  final String? itemId;
  final String? momItemId;
  final String? itemDesc;
  int? submitterAnswer;
  final int? empAnswer;
  String? notes;

  final List<ItemData>? itemData;
  final bool? showNotApplicable;
  final bool? mandToAttach;
  final AttachmentDto? attachmentDto;
  FileDataItem? file;
  bool? edit;

  EmtithalItem(
      {this.itemId,
      this.momItemId,
      this.itemDesc,
      this.submitterAnswer,
      this.empAnswer,
      this.itemData,
      this.showNotApplicable,
      this.mandToAttach,
      this.attachmentDto,
      this.file,
      this.notes,
      this.edit});

  String? getCurrentAnswer() {
    int? ans;
    if (submitterAnswer == null && empAnswer != null) {
      ans = empAnswer;
    } else {
      ans = submitterAnswer;
    }

    switch (ans) {
      case 0:
        return "nonـcompliance".tr();
      case 1:
        return "compliance".tr();
      case 2:
        return "Not_Applicable".tr();
    }
  }

  bool isAttachmentRequired(bool isReturned) {
    if (isReturned) {
      if (submitterAnswer == 1) {
        return true;
      } else if (submitterAnswer == 2) {
        return false;
      }
    } else {
      return false;
    }
    return false;
  }

  bool isNoteRequired(bool isReturned) {
    if (isReturned) {
      if (submitterAnswer == 1 || submitterAnswer == 2) {
        return true;
      }
    } else {
      if (submitterAnswer == 2) return true;
    }
    return false;
  }

  bool showNoteAndAttachments(bool isReturned) {
    if (isReturned) {
      if ((submitterAnswer == 1 && (empAnswer != null && empAnswer != 1)) ||
          submitterAnswer == 2 ||
          (empAnswer == 1 && submitterAnswer == 1)) {
        return true;
      }
    } else {
      if (submitterAnswer == 2) return true;
    }
    return false;
  }

  bool showEdit(bool isReturned) {
    if (isReturned && empAnswer == 1) return true;
    return false;
  }
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
  //final String? landNumber;
  //final String? landArea;
  final dynamic isLocationCorrect;
  final dynamic guid;
  final LandsInfo? landsInfo;
  final bool? emtithalMand;

  LocationResponseInfoDto(
      {this.municipalityId,
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
      // this.landNumber,
      //  this.landArea,
      this.isLocationCorrect,
      this.guid,
      this.landsInfo,
      this.emtithalMand});

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

class Note {
  final String? note;
  final String? date;
  final String? statusName;
  final String? author;

  Note({
    this.note,
    this.date,
    this.statusName,
    this.author,
  });

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

class OwnerDto {
  final String? identityNumber;
  final int? identityType;
  final String? identityTypeDec;
  final String? ownerName;
  final dynamic agentType;
  final dynamic agencyDto;
  final dynamic specialIqama;

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
  final int? receiptTypeId;
  final String? receiptTypeDesc;

  OwnershipDocInfoDto(
      {this.ownershipDocumentType,
      this.ownerShipDocTypeName,
      this.ownershipDocumentNo,
      this.ownershipDocumentDate,
      this.ownersInfo,
      this.paper,
      this.receiptTypeId,
      this.receiptTypeDesc});

  factory OwnershipDocInfoDto.fromJson(Map<String, dynamic> json) =>
      OwnershipDocInfoDto(
          ownershipDocumentType: json["ownershipDocumentType"],
          ownerShipDocTypeName: json["ownerShipDocTypeName"],
          ownershipDocumentNo: json["ownershipDocumentNo"],
          ownershipDocumentDate: json["ownershipDocumentDate"],
          ownersInfo: json["ownersInfo"],
          paper: json["paper"],
          receiptTypeId: json["receiptTypeId"],
          receiptTypeDesc: json["receiptTypeDesc"]);

  Map<String, dynamic> toJson() => {
        "ownershipDocumentType": ownershipDocumentType,
        "ownerShipDocTypeName": ownerShipDocTypeName,
        "ownershipDocumentNo": ownershipDocumentNo,
        "ownershipDocumentDate": ownershipDocumentDate,
        "ownersInfo": ownersInfo,
        "paper": paper,
        "receiptTypeId": receiptTypeId,
        "receiptTypeDesc": receiptTypeDesc
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

class MainEmtithalItemsDto {
  final String? mainItemId;
  final String? mainItemDesc;
  final List<SubEmtithalItem>? subEmtithalItems;

  MainEmtithalItemsDto({
    this.mainItemId,
    this.mainItemDesc,
    this.subEmtithalItems,
  });
}

class SubEmtithalItem {
  final String? itemId;
  final String? momItemId;
  final String? itemDesc;
  final int? submitterAnswer;
  final int? empAnswer;
  final List<ItemData>? itemData;
  final bool? showNotApplicable;
  final bool? mandToAttach;
  final AttachmentDto? attachmentDto;

  SubEmtithalItem(
      {this.itemId,
      this.momItemId,
      this.itemDesc,
      this.submitterAnswer,
      this.empAnswer,
      this.itemData,
      this.showNotApplicable,
      this.mandToAttach,
      this.attachmentDto});
}

class AttachmentDto {
  final dynamic id;
  final dynamic name;
  final String? allowedFilesExtension;
  final bool? isMandatory;
  final bool? attached;
  final bool? approved;
  final dynamic attachUrl;
  final dynamic notes;
  final bool? updatable;
  final int? maxSize;
  final dynamic attachDescription;
  final dynamic fileName;
  final String? fileKey;
  final String? downloadPath;

  AttachmentDto(
      {this.id,
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
      this.fileKey,
      this.downloadPath});
}

class ItemData {
  final String? note;
  final bool? isLastNote;
  final int? answer;
  final int? statusId;
  final String? statusName;
  final bool? isBaladiaSource;
  final String? date;
  final ItemDataAttachment? attachment;

  ItemData({
    this.note,
    this.isLastNote,
    this.answer,
    this.statusId,
    this.statusName,
    this.isBaladiaSource,
    this.date,
    this.attachment,
  });

  String? getCurrentAnswer() {
    switch (answer) {
      case 0:
        return "nonـcompliance".tr();
      case 1:
        return "compliance".tr();
      case 2:
        return "Not_Applicable".tr();
    }
  }
}

class LandsInfo {
  final List<LandInfo>? landsInfo;

  LandsInfo({
    this.landsInfo,
  });
}

class LandInfo {
  final String? landNumber;
  final String? landArea;

  LandInfo({
    this.landNumber,
    this.landArea,
  });
}
