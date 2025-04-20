

import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/sub_activity_details_data.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';

import '../../../../../../features/objectable_transactions/domain/entities/objectable_transaction_entity.dart';
import '../../../presentation/request_details/domain/entity/request_note_info.dart';
import '../lookups_model.dart';

class RequestDetailsModel {
  RequestDetailsModel({
    this.requestId,
    this.requestKey,
    this.requestStatus,
    this.requestType,
    this.submitterType,
    this.creationDate,
    this.municipalityApprovalDate,
    this.owner,
    this.commercialService,
    this.submitter,
    this.license,
    this.location,
    this.activities,
    this.allowedActions,
    this.notifications,
    this.rejectionInfo,
    this.notes,
    this.currentTab,
    this.initialApprovalExpiryDate,
    this.configuredShopMaximumArea,
    this.siteConfigInfo,
    this.isRelatedToCommercialRequest,
    this.relatedCommercialRequestId,
    this.validityPeriod,
    this.remainingValidityPeriod,
    this.workFlow,
    this.objectionMessage,
    this.payUrl,
    this.rejected,
    this.approved,
    this.expired,
    this.cancelled,});

  RequestDetailsModel.fromJson(dynamic json) {
    requestId = json['requestId'];
    requestKey = json['requestKey'];
    requestStatus = json['requestStatus'] != null ? RequestStatus.fromJson(json['requestStatus']) : null;
    requestType = json['requestType'] != null ? RequestType.fromJson(json['requestType']) : null;
    submitterType = json['submitterType'] != null ? SubmitterType.fromJson(json['submitterType']) : null;
    creationDate = json['creationDate'];
    municipalityApprovalDate = json['municipalityApprovalDate'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    commercialService = json['commercialService'] != null ? CommercialService.fromJson(json['commercialService']) : null;
    submitter = json['submitter'] != null ? Submitter.fromJson(json['submitter']) : null;
    license = json['license'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    activities = json['activities'] != null ? Activities.fromJson(json['activities']) : null;
    if (json['allowedActions'] != null) {
      allowedActions = [];
      json['allowedActions'].forEach((v) {
        allowedActions?.add(AllowedActions.fromJson(v));
      });
    }
    notifications = json['notifications'];
    rejectionInfo = json['rejectionInfo'] != null ? RejectionInfo.fromJson(json['rejectionInfo']) : null;
    if (json['notes'] != null) {
      notes = [];
      json['notes'].forEach((v) {
        notes?.add(RequestNoteInfo.fromJson(v));
      });
    }
    currentTab = json['currentTab'];
    initialApprovalExpiryDate = json['initialApprovalExpiryDate'];
    configuredShopMaximumArea = json['configuredShopMaximumArea'];
    siteConfigInfo = json['siteConfigInfo'] != null ? SiteConfigInfo.fromJson(json['siteConfigInfo']) : null;
    isRelatedToCommercialRequest = json['isRelatedToCommercialRequest'];
    relatedCommercialRequestId = json['relatedCommercialRequestId'];
    validityPeriod = json['validityPeriod'];
    remainingValidityPeriod = json['remainingValidityPeriod'];
    workFlow = json['workFlow'] != null ? WorkFlow.fromJson(json['workFlow']) : null;
    objectionMessage = json['objectionMessage'];
    payUrl = json['payUrl'];
    rejected = json['rejected'];
    approved = json['approved'];
    expired = json['expired'];
    cancelled = json['cancelled'];
  }
  int? requestId;
  String? requestKey;
  RequestStatus? requestStatus;
  RequestType? requestType;
  SubmitterType? submitterType;
  String? creationDate;
  dynamic municipalityApprovalDate;
  Owner? owner;
  CommercialService? commercialService;
  Submitter? submitter;
  dynamic license;
  Location? location;
  Activities? activities;
  List<AllowedActions>? allowedActions;
  dynamic notifications;
  RejectionInfo? rejectionInfo;
  List<RequestNoteInfo>? notes;
  int? currentTab;
  dynamic initialApprovalExpiryDate;
  double? configuredShopMaximumArea;
  SiteConfigInfo? siteConfigInfo;
  bool? isRelatedToCommercialRequest;
  dynamic relatedCommercialRequestId;
  dynamic validityPeriod;
  dynamic remainingValidityPeriod;
  WorkFlow? workFlow;
  dynamic objectionMessage;
  dynamic payUrl;
  bool? rejected;
  bool? approved;
  bool? expired;
  bool? cancelled;
  RequestDetailsModel copyWith({  int? requestId,
    String? requestKey,
    RequestStatus? requestStatus,
    RequestType? requestType,
    SubmitterType? submitterType,
    String? creationDate,
    dynamic municipalityApprovalDate,
    Owner? owner,
    CommercialService? commercialService,
    Submitter? submitter,
    dynamic license,
    Location? location,
    Activities? activities,
    List<AllowedActions>? allowedActions,
    dynamic notifications,
    RejectionInfo? rejectionInfo,
    List<RequestNoteInfo> ?notes,
    int? currentTab,
    dynamic initialApprovalExpiryDate,
    double? configuredShopMaximumArea,
    SiteConfigInfo? siteConfigInfo,
    bool? isRelatedToCommercialRequest,
    dynamic relatedCommercialRequestId,
    dynamic validityPeriod,
    dynamic remainingValidityPeriod,
    WorkFlow? workFlow,
    dynamic objectionMessage,
    dynamic payUrl,
    bool? rejected,
    bool? approved,
    bool? expired,
    bool? cancelled,
  }) => RequestDetailsModel(  requestId: requestId ?? this.requestId,
    requestKey: requestKey ?? this.requestKey,
    requestStatus: requestStatus ?? this.requestStatus,
    requestType: requestType ?? this.requestType,
    submitterType: submitterType ?? this.submitterType,
    creationDate: creationDate ?? this.creationDate,
    municipalityApprovalDate: municipalityApprovalDate ?? this.municipalityApprovalDate,
    owner: owner ?? this.owner,
    commercialService: commercialService ?? this.commercialService,
    submitter: submitter ?? this.submitter,
    license: license ?? this.license,
    location: location ?? this.location,
    activities: activities ?? this.activities,
    allowedActions: allowedActions ?? this.allowedActions,
    notifications: notifications ?? this.notifications,
    rejectionInfo: rejectionInfo ?? this.rejectionInfo,
    notes: notes ?? this.notes,
    currentTab: currentTab ?? this.currentTab,
    initialApprovalExpiryDate: initialApprovalExpiryDate ?? this.initialApprovalExpiryDate,
    configuredShopMaximumArea: configuredShopMaximumArea ?? this.configuredShopMaximumArea,
    siteConfigInfo: siteConfigInfo ?? this.siteConfigInfo,
    isRelatedToCommercialRequest: isRelatedToCommercialRequest ?? this.isRelatedToCommercialRequest,
    relatedCommercialRequestId: relatedCommercialRequestId ?? this.relatedCommercialRequestId,
    validityPeriod: validityPeriod ?? this.validityPeriod,
    remainingValidityPeriod: remainingValidityPeriod ?? this.remainingValidityPeriod,
    workFlow: workFlow ?? this.workFlow,
    objectionMessage: objectionMessage ?? this.objectionMessage,
    payUrl: payUrl ?? this.payUrl,
    rejected: rejected ?? this.rejected,
    approved: approved ?? this.approved,
    expired: expired ?? this.expired,
    cancelled: cancelled ?? this.cancelled,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestId'] = requestId;
    map['requestKey'] = requestKey;
    if (requestStatus != null) {
      map['requestStatus'] = requestStatus?.toJson();
    }
    if (requestType != null) {
      map['requestType'] = requestType?.toJson();
    }
    if (submitterType != null) {
      map['submitterType'] = submitterType?.toJson();
    }
    map['creationDate'] = creationDate;
    map['municipalityApprovalDate'] = municipalityApprovalDate;
    if (owner != null) {
      map['owner'] = owner?.toJson();
    }
    if (commercialService != null) {
      map['commercialService'] = commercialService?.toJson();
    }
    if (submitter != null) {
      map['submitter'] = submitter?.toJson();
    }
    map['license'] = license;
    if (location != null) {
      map['location'] = location?.toJson();
    }

    if (allowedActions != null) {
      map['allowedActions'] = allowedActions?.map((v) => v.toJson()).toList();
    }
    map['notifications'] = notifications;
    if (rejectionInfo != null) {
      map['rejectionInfo'] = rejectionInfo?.toJson();
    }
    map['notes'] = notes;
    map['currentTab'] = currentTab;
    map['initialApprovalExpiryDate'] = initialApprovalExpiryDate;
    map['configuredShopMaximumArea'] = configuredShopMaximumArea;
    if (siteConfigInfo != null) {
      map['siteConfigInfo'] = siteConfigInfo?.toJson();
    }
    map['isRelatedToCommercialRequest'] = isRelatedToCommercialRequest;
    map['relatedCommercialRequestId'] = relatedCommercialRequestId;
    map['validityPeriod'] = validityPeriod;
    map['remainingValidityPeriod'] = remainingValidityPeriod;
    if (workFlow != null) {
      map['workFlow'] = workFlow?.toJson();
    }
    map['objectionMessage'] = objectionMessage;
    map['payUrl'] = payUrl;
    map['rejected'] = rejected;
    map['approved'] = approved;
    map['expired'] = expired;
    map['cancelled'] = cancelled;
    return map;
  }


  // ObjectableTransactionsEntity getObjectableTransactionsEntity() {
  //   return ObjectableTransactionsEntity(
  //
  //     serviceTypeId: 1,
  //     transactionId: "${requestId}",
  //     violationStatusName: requestStatus?.name,
  //     violationStatusId: requestStatus?.id,
  //
  //     isAllowedObjection: true,
  //
  //     municipalityId: "${location?.municipality?.id}",
  //     municipalityName: location?.municipality?.name,
  //     subMunicipalityId: "${location?.subMunicipality?.id}",
  //     subMunicipalityName: location?.subMunicipality?.name,
  //     ownerIdentityNo: "${submitter?.identityNumber}",
  //     ownerName: submitter?.name,
  //     ownerIdentityTypeId: "1",
  //     ownerIdentityTypeName: "هوية وطنية",
  //     objectionTypeId: "",
  //     objectionTypeName: null,
  //     applicationId: applicationId,
  //     applicationName: applicationName,
  //     serviceId: serviceId,
  //     serviceName: serviceName,
  //     transactionNumber: violationNumber,
  //
  //     originalOwnerIdentityTypeId: null,
  //     originalMunicipalityId: "${location?.municipality?.id}",
  //     originalSubMunicipalityId: "${location?.subMunicipality?.id}",
  //   );
  // }



}

class WorkFlow {
  WorkFlow({
    this.id,
    this.name,});

  WorkFlow.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
  WorkFlow copyWith({  String? id,
    String? name,
  }) => WorkFlow(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class SiteConfigInfo {
  SiteConfigInfo({
    this.gisProviderType,});

  SiteConfigInfo.fromJson(dynamic json) {
    gisProviderType = json['gisProviderType'];
  }
  String? gisProviderType;
  SiteConfigInfo copyWith({  String? gisProviderType,
  }) => SiteConfigInfo(  gisProviderType: gisProviderType ?? this.gisProviderType,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gisProviderType'] = gisProviderType;
    return map;
  }

}

class RejectionInfo {
  RejectionInfo({
    this.rejectionReason,
    this.rejectionDate,
    this.rejectedBy,});

  RejectionInfo.fromJson(dynamic json) {
    rejectionReason = json['rejectionReason'];
    rejectionDate = json['rejectionDate'];
    rejectedBy = json['rejectedBy'];
  }
  dynamic rejectionReason;
  String? rejectionDate;
  String? rejectedBy;
  RejectionInfo copyWith({  dynamic rejectionReason,
    String? rejectionDate,
    String? rejectedBy,
  }) => RejectionInfo(  rejectionReason: rejectionReason ?? this.rejectionReason,
    rejectionDate: rejectionDate ?? this.rejectionDate,
    rejectedBy: rejectedBy ?? this.rejectedBy,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rejectionReason'] = rejectionReason;
    map['rejectionDate'] = rejectionDate;
    map['rejectedBy'] = rejectedBy;
    return map;
  }

}

class AllowedActions {
  AllowedActions({
    this.id,
    this.name,});

  AllowedActions.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
  AllowedActions copyWith({  String? id,
    String? name,
  }) => AllowedActions(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class Activities {
  Activities({
    this.shopArea,
    this.unitCount,
    this.accommodationType,
    this.workerType,
    this.isAtmPaid,
    this.mainActivity,
    this.addedActivities,
    this.facility,});

  Activities.fromJson(dynamic json) {
    shopArea = json['shopArea'];
    unitCount = json['unitCount'];
    accommodationType = json['accommodationType'] != null ? LookupsModel.fromJson(json['accommodationType']) : null;
    workerType = json['workerType'] != null ? WorkerTypes.fromJson(json['workerType']) : null;
    isAtmPaid = json['isAtmPaid'];
    mainActivity = json['mainActivity'] != null ? MainActivity.fromJson(json['mainActivity']) : null;
    if (json['addedActivities'] != null) {
      addedActivities = [];
      json['addedActivities'].forEach((v) {
        addedActivities?.add(AddedActivities.fromJson(v));
      });
    }
    facility = json['facility'] != null ? Facility.fromJson(json['facility']) : null;
  }
  double? shopArea;
  int? unitCount;
  LookupsModel? accommodationType;
  WorkerTypes? workerType;
  bool? isAtmPaid;
  MainActivity? mainActivity;
  List<AddedActivities>? addedActivities;
  Facility? facility;

  Activities copyWith({  double? shopArea,
    int? unitCount,
    LookupsModel? accommodationType,
    WorkerTypes? workerType,
    bool? isAtmPaid,
    MainActivity? mainActivity,
    List<AddedActivities>? addedActivities,
    Facility? facility,
  }) => Activities(  shopArea: shopArea ?? this.shopArea,
    unitCount: unitCount ?? this.unitCount,
    accommodationType: accommodationType ?? this.accommodationType,
    workerType: workerType ?? this.workerType,
    isAtmPaid: isAtmPaid ?? this.isAtmPaid,
    mainActivity: mainActivity ?? this.mainActivity,
    addedActivities: addedActivities ?? this.addedActivities,
    facility: facility ?? this.facility,
  );


}

class Facility {
  Facility({
    this.id,
    this.name,});

  Facility.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  Facility copyWith({  int? id,
    String? name,
  }) => Facility(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class AddedActivities {
  AddedActivities({
    this.detailedActivityId,
    this.detailedActivityName,
    this.isicId,
    this.isicName,
    this.area,
    this.maxYears,
    this.showAtmSection,
    this.showAreaSection,
    this.showHotelSection,});

  AddedActivities.fromJson(dynamic json) {
    detailedActivityId = json['detailedActivityId'];
    detailedActivityName = json['detailedActivityName'];
    isicId = json['isicId'];
    isicName = json['isicName'];
    area = json['area'];
    maxYears = json['maxYears'];
    showAtmSection = json['showAtmSection'];
    showAreaSection = json['showAreaSection'];
    showHotelSection = json['showHotelSection'];
  }
  int? detailedActivityId;
  String? detailedActivityName;
  String? isicId;
  String? isicName;
  double? area;
  int? maxYears;
  bool? showAtmSection;
  bool? showAreaSection;
  bool? showHotelSection;
  AddedActivities copyWith({  int? detailedActivityId,
    String? detailedActivityName,
    String? isicId,
    String? isicName,
    double? area,
    int? maxYears,
    bool? showAtmSection,
    bool? showAreaSection,
    bool? showHotelSection,
  }) => AddedActivities(  detailedActivityId: detailedActivityId ?? this.detailedActivityId,
    detailedActivityName: detailedActivityName ?? this.detailedActivityName,
    isicId: isicId ?? this.isicId,
    isicName: isicName ?? this.isicName,
    area: area ?? this.area,
    maxYears: maxYears ?? this.maxYears,
    showAtmSection: showAtmSection ?? this.showAtmSection,
    showAreaSection: showAreaSection ?? this.showAreaSection,
    showHotelSection: showHotelSection ?? this.showHotelSection,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['detailedActivityId'] = detailedActivityId;
    map['detailedActivityName'] = detailedActivityName;
    map['isicId'] = isicId;
    map['isicName'] = isicName;
    map['area'] = area;
    map['maxYears'] = maxYears;
    map['showAtmSection'] = showAtmSection;
    map['showAreaSection'] = showAreaSection;
    map['showHotelSection'] = showHotelSection;
    return map;
  }

}

class MainActivity {
  MainActivity({
    this.detailedActivityId,
    this.detailedActivityName,
    this.isicId,
    this.isicName,
    this.area,
    this.maxYears,
    this.showAtmSection,
    this.showAreaSection,
    this.showHotelSection,});

  MainActivity.fromJson(dynamic json) {
    detailedActivityId = json['detailedActivityId'];
    detailedActivityName = json['detailedActivityName'];
    isicId = json['isicId'];
    isicName = json['isicName'];
    area = json['area'];
    maxYears = json['maxYears'];
    showAtmSection = json['showAtmSection'];
    showAreaSection = json['showAreaSection'];
    showHotelSection = json['showHotelSection'];
  }
  int? detailedActivityId;
  String? detailedActivityName;
  String? isicId;
  String? isicName;
  double? area;
  int? maxYears;
  bool? showAtmSection;
  bool? showAreaSection;
  bool? showHotelSection;
  MainActivity copyWith({  int? detailedActivityId,
    String? detailedActivityName,
    String? isicId,
    String? isicName,
    double? area,
    int? maxYears,
    bool? showAtmSection,
    bool? showAreaSection,
    bool? showHotelSection,
  }) => MainActivity(  detailedActivityId: detailedActivityId ?? this.detailedActivityId,
    detailedActivityName: detailedActivityName ?? this.detailedActivityName,
    isicId: isicId ?? this.isicId,
    isicName: isicName ?? this.isicName,
    area: area ?? this.area,
    maxYears: maxYears ?? this.maxYears,
    showAtmSection: showAtmSection ?? this.showAtmSection,
    showAreaSection: showAreaSection ?? this.showAreaSection,
    showHotelSection: showHotelSection ?? this.showHotelSection,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['detailedActivityId'] = detailedActivityId;
    map['detailedActivityName'] = detailedActivityName;
    map['isicId'] = isicId;
    map['isicName'] = isicName;
    map['area'] = area;
    map['maxYears'] = maxYears;
    map['showAtmSection'] = showAtmSection;
    map['showAreaSection'] = showAreaSection;
    map['showHotelSection'] = showHotelSection;
    return map;
  }

}


class Location {
  Location({
    this.longitude,
    this.latitude,
    this.landNumber,
    this.mapNumber,
    this.krokiUrl,
    this.planNumber,
    this.city,
    this.municipality,
    this.issuingMunicipality,
    this.subMunicipality,
    this.district,
    this.street,});

  Location.fromJson(dynamic json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    landNumber = json['landNumber'];
    mapNumber = json['mapNumber'];
    krokiUrl = json['krokiUrl'];
    planNumber = json['planNumber'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    municipality = json['municipality'] != null ? Municipality.fromJson(json['municipality']) : null;
    issuingMunicipality = json['issuingMunicipality'];
    subMunicipality = json['subMunicipality'] != null ? SubMunicipality.fromJson(json['subMunicipality']) : null;
    district = json['district'] != null ? District.fromJson(json['district']) : null;
    street = json['street'] != null ? Street.fromJson(json['street']) : null;
  }
  String? longitude;
  String? latitude;
  String? landNumber;
  String? mapNumber;
  String? krokiUrl;
  String? planNumber;
  City? city;
  Municipality? municipality;
  dynamic issuingMunicipality;
  SubMunicipality? subMunicipality;
  District? district;
  Street? street;
  Location copyWith({  String? longitude,
    String? latitude,
    String? landNumber,
    String? mapNumber,
    String? krokiUrl,
    String? planNumber,
    City? city,
    Municipality? municipality,
    dynamic issuingMunicipality,
    SubMunicipality? subMunicipality,
    District? district,
    Street? street,
  }) => Location(  longitude: longitude ?? this.longitude,
    latitude: latitude ?? this.latitude,
    landNumber: landNumber ?? this.landNumber,
    mapNumber: mapNumber ?? this.mapNumber,
    krokiUrl: krokiUrl ?? this.krokiUrl,
    planNumber: planNumber ?? this.planNumber,
    city: city ?? this.city,
    municipality: municipality ?? this.municipality,
    issuingMunicipality: issuingMunicipality ?? this.issuingMunicipality,
    subMunicipality: subMunicipality ?? this.subMunicipality,
    district: district ?? this.district,
    street: street ?? this.street,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['landNumber'] = landNumber;
    map['mapNumber'] = mapNumber;
    map['krokiUrl'] = krokiUrl;
    map['planNumber'] = planNumber;
    if (city != null) {
      map['city'] = city?.toJson();
    }
    if (municipality != null) {
      map['municipality'] = municipality?.toJson();
    }
    map['issuingMunicipality'] = issuingMunicipality;
    if (subMunicipality != null) {
      map['subMunicipality'] = subMunicipality?.toJson();
    }
    if (district != null) {
      map['district'] = district?.toJson();
    }
    if (street != null) {
      map['street'] = street?.toJson();
    }
    return map;
  }

}

class Street {
  Street({
    this.id,
    this.name,});

  Street.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  Street copyWith({  int? id,
    String? name,
  }) => Street(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class District {
  District({
    this.id,
    this.name,});

  District.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  District copyWith({  int? id,
    String? name,
  }) => District(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class SubMunicipality {
  SubMunicipality({
    this.id,
    this.name,});

  SubMunicipality.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  SubMunicipality copyWith({  int? id,
    String? name,
  }) => SubMunicipality(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class Municipality {
  Municipality({
    this.id,
    this.name,});

  Municipality.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  Municipality copyWith({  int? id,
    String? name,
  }) => Municipality(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class City {
  City({
    this.id,
    this.name,});

  City.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  City copyWith({  int? id,
    String? name,
  }) => City(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class Submitter {
  Submitter({
    this.identityNumber,
    this.birthDate,
    this.mobileNumber,
    this.name,
    this.nationality,});

  Submitter.fromJson(dynamic json) {
    identityNumber = json['identityNumber'];
    birthDate = json['birthDate'];
    mobileNumber = json['mobileNumber'];
    name = json['name'];
    nationality = json['nationality'] != null ? Nationality.fromJson(json['nationality']) : null;
  }
  int? identityNumber;
  String? birthDate;
  String? mobileNumber;
  String? name;
  Nationality? nationality;
  Submitter copyWith({  int? identityNumber,
    String? birthDate,
    String? mobileNumber,
    String? name,
    Nationality? nationality,
  }) => Submitter(  identityNumber: identityNumber ?? this.identityNumber,
    birthDate: birthDate ?? this.birthDate,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    name: name ?? this.name,
    nationality: nationality ?? this.nationality,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identityNumber'] = identityNumber;
    map['birthDate'] = birthDate;
    map['mobileNumber'] = mobileNumber;
    map['name'] = name;
    if (nationality != null) {
      map['nationality'] = nationality?.toJson();
    }
    return map;
  }

}

class Nationality {
  Nationality({
    this.id,
    this.name,});

  Nationality.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  Nationality copyWith({  int? id,
    String? name,
  }) => Nationality(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class CommercialService {
  CommercialService({
    this.id,
    this.name,});

  CommercialService.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  CommercialService copyWith({  int? id,
    String? name,
  }) => CommercialService(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class Owner {
  Owner({
    this.crNumber,
    this.crType,
    this.ownerName,
    this.mobileNumber,
    this.type,
    this.email,});

  Owner.fromJson(dynamic json) {
    crNumber = json['crNumber'];
    crType = json['crType'];
    ownerName = json['ownerName'];
    mobileNumber = json['mobileNumber'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    email = json['email'];
  }
  String? crNumber;
  int? crType;
  String? ownerName;
  String? mobileNumber;
  Type? type;
  String? email;
  Owner copyWith({  String? crNumber,
    int? crType,
    String? ownerName,
    String? mobileNumber,
    Type? type,
    String? email,
  }) => Owner(  crNumber: crNumber ?? this.crNumber,
    crType: crType ?? this.crType,
    ownerName: ownerName ?? this.ownerName,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    type: type ?? this.type,
    email: email ?? this.email,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['crNumber'] = crNumber;
    map['crType'] = crType;
    map['ownerName'] = ownerName;
    map['mobileNumber'] = mobileNumber;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    map['email'] = email;
    return map;
  }

}

class Type {
  Type({
    this.id,
    this.name,});

  Type.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  Type copyWith({  int? id,
    String? name,
  }) => Type(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class SubmitterType {
  SubmitterType({
    this.id,
    this.name,});

  SubmitterType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
  SubmitterType copyWith({  String? id,
    String? name,
  }) => SubmitterType(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class RequestType {
  RequestType({
    this.id,
    this.name,});

  RequestType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  RequestType copyWith({  int? id,
    String? name,
  }) => RequestType(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class RequestStatus {
  RequestStatus({
    this.id,
    this.name,});

  RequestStatus.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
  RequestStatus copyWith({  int? id,
    String? name,
  }) => RequestStatus(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class StatusDetails {
  StatusDetails({
    this.code,
    this.message,});

  StatusDetails.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
  }
  int? code;
  String? message;
  StatusDetails copyWith({  int? code,
    String? message,
  }) => StatusDetails(  code: code ?? this.code,
    message: message ?? this.message,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    return map;
  }

}