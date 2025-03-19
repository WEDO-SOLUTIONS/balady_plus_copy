class IssueCommercialConculsionEntity {
  IssueCommercialConculsionEntity({
      this.allowedPermits, 
      this.calculateStandardFees, 
      this.civilDefenseAllowedDocuments, 
      this.cleaningOptions, 
      this.commercialOffices, 
      this.engOffices, 
      this.preDefinedConditionTypes, 
      this.requestFlow,
      this.lstPreDefinedConditionsByType,
      this.supervisingAuthoritiesForActivities,
  this.lstFastFlowConditions,
    this.lstboardContractRequirementMessage});


  List<AllowedPermits>? allowedPermits;
  CalculateStandardFees? calculateStandardFees;
  List<CivilDefenseAllowedDocuments>? civilDefenseAllowedDocuments;
  List<CleaningOptions>? cleaningOptions;
  List<CommercialOffices>? commercialOffices;
  List<EngOffices>? engOffices;
  List<PreDefinedConditionTypes>? preDefinedConditionTypes;
  List<RequestFlow>? requestFlow;
  List<String>? lstPreDefinedConditionsByType;
  List<FastFlowConditions>? lstFastFlowConditions;

  List<SupervisingAuthoritiesForActivities>? supervisingAuthoritiesForActivities;
  List<EngOffices>? lstboardContractRequirementMessage;



IssueCommercialConculsionEntity copyWith({  List<AllowedPermits>? allowedPermits,
  CalculateStandardFees? calculateStandardFees,
  List<CivilDefenseAllowedDocuments>? civilDefenseAllowedDocuments,
  List<CleaningOptions>? cleaningOptions,
  List<CommercialOffices>? commercialOffices,
  List<EngOffices>? engOffices,
  List<PreDefinedConditionTypes>? preDefinedConditionTypes,
  List<RequestFlow>? requestFlow,
  List<String>? lstPreDefinedConditionsByType,
  List<FastFlowConditions>? lstFastFlowConditions,
  List<SupervisingAuthoritiesForActivities>? supervisingAuthoritiesForActivities,
  List<EngOffices>? lstboardContractRequirementMessage,
}) => IssueCommercialConculsionEntity( allowedPermits: allowedPermits ?? this.allowedPermits,
  calculateStandardFees: calculateStandardFees ?? this.calculateStandardFees,
  civilDefenseAllowedDocuments: civilDefenseAllowedDocuments ?? this.civilDefenseAllowedDocuments,
  cleaningOptions: cleaningOptions ?? this.cleaningOptions,
  commercialOffices: commercialOffices ?? this.commercialOffices,
  engOffices: engOffices ?? this.engOffices,
  preDefinedConditionTypes: preDefinedConditionTypes ?? this.preDefinedConditionTypes,
  requestFlow: requestFlow ?? this.requestFlow,
  lstPreDefinedConditionsByType:lstPreDefinedConditionsByType??this.lstPreDefinedConditionsByType,
  lstFastFlowConditions:lstFastFlowConditions??this.lstFastFlowConditions,
  supervisingAuthoritiesForActivities: supervisingAuthoritiesForActivities ?? this.supervisingAuthoritiesForActivities,
    lstboardContractRequirementMessage:lstboardContractRequirementMessage??this.lstboardContractRequirementMessage
);



  IssueCommercialConculsionEntity.fromJson(dynamic json) {
    if (json['allowedPermits'] != null) {
      allowedPermits = [];
      json['allowedPermits'].forEach((v) {
        allowedPermits?.add(AllowedPermits.fromJson(v));
      });
    }
    calculateStandardFees = json['calculateStandardFees'] != null ? CalculateStandardFees.fromJson(json['calculateStandardFees']) : null;
    if (json['civilDefenseAllowedDocuments'] != null) {
      civilDefenseAllowedDocuments = [];
      json['civilDefenseAllowedDocuments'].forEach((v) {
        civilDefenseAllowedDocuments?.add(CivilDefenseAllowedDocuments.fromJson(v));
      });
    }
    if (json['cleaningOptions'] != null) {
      cleaningOptions = [];
      json['cleaningOptions'].forEach((v) {
        cleaningOptions?.add(CleaningOptions.fromJson(v));
      });
    }
    if (json['commercialOffices'] != null) {
      commercialOffices = [];
      json['commercialOffices'].forEach((v) {
        commercialOffices?.add(CommercialOffices.fromJson(v));
      });
    }
    if (json['engOffices'] != null) {
      engOffices = [];
      json['engOffices'].forEach((v) {
        engOffices?.add(EngOffices.fromJson(v));
      });
    }
    if (json['preDefinedConditionTypes'] != null) {
      preDefinedConditionTypes = [];
      json['preDefinedConditionTypes'].forEach((v) {
        preDefinedConditionTypes?.add(PreDefinedConditionTypes.fromJson(v));
      });
    }

    if (json['fastFlowConditions'] != null) {
      lstFastFlowConditions = [];
      json['fastFlowConditions'].forEach((v) {
        lstFastFlowConditions?.add(FastFlowConditions.fromJson(v));
      });
    }

    if (json['requestFlow'] != null) {
      requestFlow = [];
      json['requestFlow'].forEach((v) {
        requestFlow?.add(RequestFlow.fromJson(v));
      });
    }

    if (json['boardContractRequirementMessage'] != null) {
      lstboardContractRequirementMessage = [];
      json['boardContractRequirementMessage'].forEach((v) {
        lstboardContractRequirementMessage?.add(EngOffices.fromJson(v));
      });
    }

     // lstboardContractRequirementMessage = json['boardContractRequirementMessage'] != null ? json['boardContractRequirementMessage'].cast<String>() : [];

    // if (json['preDefinedConditionsByType'] != null) {
    //   lstPreDefinedConditionsByType = [];
    //   json['preDefinedConditionsByType'].forEach((v) {
    //     lstPreDefinedConditionsByType?.add(PreDefinedConditionsByType.fromJson(v));
    //   });
    // }

    lstPreDefinedConditionsByType = json['preDefinedConditionsByType'] != null ? json['preDefinedConditionsByType'].cast<String>() : [];


    if (json['supervisingAuthoritiesForActivities'] != null) {
      supervisingAuthoritiesForActivities = [];
      json['supervisingAuthoritiesForActivities'].forEach((v) {
        supervisingAuthoritiesForActivities?.add(SupervisingAuthoritiesForActivities.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allowedPermits != null) {
      map['allowedPermits'] = allowedPermits?.map((v) => v.toJson()).toList();
    }
    if (calculateStandardFees != null) {
      map['calculateStandardFees'] = calculateStandardFees?.toJson();
    }
    if (civilDefenseAllowedDocuments != null) {
      map['civilDefenseAllowedDocuments'] = civilDefenseAllowedDocuments?.map((v) => v.toJson()).toList();
    }
    if (cleaningOptions != null) {
      map['cleaningOptions'] = cleaningOptions?.map((v) => v.toJson()).toList();
    }
    if (commercialOffices != null) {
      map['commercialOffices'] = commercialOffices?.map((v) => v.toJson()).toList();
    }
    if (engOffices != null) {
      map['engOffices'] = engOffices?.map((v) => v.toJson()).toList();
    }
    if (preDefinedConditionTypes != null) {
      map['preDefinedConditionTypes'] = preDefinedConditionTypes?.map((v) => v.toJson()).toList();
    }
    if (requestFlow != null) {
      map['requestFlow'] = requestFlow?.map((v) => v.toJson()).toList();
    }
    if (supervisingAuthoritiesForActivities != null) {
      map['supervisingAuthoritiesForActivities'] = supervisingAuthoritiesForActivities?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SupervisingAuthoritiesForActivities {
  SupervisingAuthoritiesForActivities({
      this.activityId, 
      this.activityName, 
      this.supervisions,});

  SupervisingAuthoritiesForActivities.fromJson(dynamic json) {
    activityId = json['activityId'];
    activityName = json['activityName'];
    if (json['supervisions'] != null) {
      supervisions = [];
      json['supervisions'].forEach((v) {
        supervisions?.add(Supervisions.fromJson(v));
      });
    }
  }
  int? activityId;
  String? activityName;
  List<Supervisions>? supervisions;
SupervisingAuthoritiesForActivities copyWith({  int? activityId,
  String? activityName,
  List<Supervisions>? supervisions,
}) => SupervisingAuthoritiesForActivities(  activityId: activityId ?? this.activityId,
  activityName: activityName ?? this.activityName,
  supervisions: supervisions ?? this.supervisions,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['activityId'] = activityId;
    map['activityName'] = activityName;
    if (supervisions != null) {
      map['supervisions'] = supervisions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Supervisions {
  Supervisions({
      this.agencyId, 
      this.agencyName, 
      this.approvalTypeId, 
      this.approvalTypeName,});

  Supervisions.fromJson(dynamic json) {
    agencyId = json['agencyId'];
    agencyName = json['agencyName'];
    approvalTypeId = json['approvalTypeId'];
    approvalTypeName = json['approvalTypeName'];
  }
  int? agencyId;
  String? agencyName;
  int? approvalTypeId;
  String? approvalTypeName;
Supervisions copyWith({  int? agencyId,
  String? agencyName,
  int? approvalTypeId,
  String? approvalTypeName,
}) => Supervisions(  agencyId: agencyId ?? this.agencyId,
  agencyName: agencyName ?? this.agencyName,
  approvalTypeId: approvalTypeId ?? this.approvalTypeId,
  approvalTypeName: approvalTypeName ?? this.approvalTypeName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['agencyId'] = agencyId;
    map['agencyName'] = agencyName;
    map['approvalTypeId'] = approvalTypeId;
    map['approvalTypeName'] = approvalTypeName;
    return map;
  }

}

class RequestFlow {
  RequestFlow({
      this.index, 
      this.sequenceId, 
      this.stepId, 
      this.stepName,});

  RequestFlow.fromJson(dynamic json) {
    index = json['index'];
    sequenceId = json['sequenceId'];
    stepId = json['stepId'];
    stepName = json['stepName'];
  }
  int? index;
  int? sequenceId;
  String? stepId;
  String? stepName;
RequestFlow copyWith({  int? index,
  int? sequenceId,
  String? stepId,
  String? stepName,
}) => RequestFlow(  index: index ?? this.index,
  sequenceId: sequenceId ?? this.sequenceId,
  stepId: stepId ?? this.stepId,
  stepName: stepName ?? this.stepName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['index'] = index;
    map['sequenceId'] = sequenceId;
    map['stepId'] = stepId;
    map['stepName'] = stepName;
    return map;
  }

}

class PreDefinedConditionTypes {
  PreDefinedConditionTypes({
      this.id, 
      this.name,});

  PreDefinedConditionTypes.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
PreDefinedConditionTypes copyWith({  String? id,
  String? name,
}) => PreDefinedConditionTypes(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class EngOffices {
  EngOffices({
      this.cityName, 
      this.officeMobile, 
      this.officeName,});

  EngOffices.fromJson(dynamic json) {
    cityName = json['cityName'];
    officeMobile = json['officeMobile'];
    officeName = json['officeName'];
  }
  String? cityName;
  String? officeMobile;
  String? officeName;
EngOffices copyWith({  String? cityName,
  String? officeMobile,
  String? officeName,
}) => EngOffices(  cityName: cityName ?? this.cityName,
  officeMobile: officeMobile ?? this.officeMobile,
  officeName: officeName ?? this.officeName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cityName'] = cityName;
    map['officeMobile'] = officeMobile;
    map['officeName'] = officeName;
    return map;
  }

}

class CommercialOffices {
  CommercialOffices({
      this.cityName, 
      this.officeMobile, 
      this.officeName,});

  CommercialOffices.fromJson(dynamic json) {
    cityName = json['cityName'];
    officeMobile = json['officeMobile'];
    officeName = json['officeName'];
  }
  String? cityName;
  String? officeMobile;
  String? officeName;
CommercialOffices copyWith({  String? cityName,
  String? officeMobile,
  String? officeName,
}) => CommercialOffices(  cityName: cityName ?? this.cityName,
  officeMobile: officeMobile ?? this.officeMobile,
  officeName: officeName ?? this.officeName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cityName'] = cityName;
    map['officeMobile'] = officeMobile;
    map['officeName'] = officeName;
    return map;
  }

}

class CleaningOptions {
  CleaningOptions({
      this.id, 
      this.name,});

  CleaningOptions.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
CleaningOptions copyWith({  String? id,
  String? name,
}) => CleaningOptions(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class CivilDefenseAllowedDocuments {
  CivilDefenseAllowedDocuments({
      this.id, 
      this.name,});

  CivilDefenseAllowedDocuments.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
CivilDefenseAllowedDocuments copyWith({  String? id,
  String? name,
}) => CivilDefenseAllowedDocuments(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class CalculateStandardFees {
  CalculateStandardFees({
      this.activitiesCostDetailes, 
      this.costsInfo, 
      this.detailedCostList, 
      this.paymentYearsCount, 
      this.renewYearsCount, 
      this.totalCost,});

  CalculateStandardFees.fromJson(dynamic json) {
    if (json['ActivitiesCostDetailes'] != null) {
      activitiesCostDetailes = [];
      json['ActivitiesCostDetailes'].forEach((v) {
        activitiesCostDetailes?.add(ActivitiesCostDetailes.fromJson(v));
      });
    }
    if (json['CostsInfo'] != null) {
      costsInfo = [];
      json['CostsInfo'].forEach((v) {
        costsInfo?.add(CostsInfo.fromJson(v));
      });
    }
    detailedCostList = json['DetailedCostList'];
    paymentYearsCount = json['PaymentYearsCount'];
    renewYearsCount = json['RenewYearsCount'];
    totalCost = json['TotalCost'];
  }
  List<ActivitiesCostDetailes>? activitiesCostDetailes;
  List<CostsInfo>? costsInfo;
  dynamic detailedCostList;
  int? paymentYearsCount;
  int? renewYearsCount;
  int? totalCost;
CalculateStandardFees copyWith({  List<ActivitiesCostDetailes>? activitiesCostDetailes,
  List<CostsInfo>? costsInfo,
  dynamic detailedCostList,
  int? paymentYearsCount,
  int? renewYearsCount,
  int? totalCost,
}) => CalculateStandardFees(  activitiesCostDetailes: activitiesCostDetailes ?? this.activitiesCostDetailes,
  costsInfo: costsInfo ?? this.costsInfo,
  detailedCostList: detailedCostList ?? this.detailedCostList,
  paymentYearsCount: paymentYearsCount ?? this.paymentYearsCount,
  renewYearsCount: renewYearsCount ?? this.renewYearsCount,
  totalCost: totalCost ?? this.totalCost,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (activitiesCostDetailes != null) {
      map['ActivitiesCostDetailes'] = activitiesCostDetailes?.map((v) => v.toJson()).toList();
    }
    if (costsInfo != null) {
      map['CostsInfo'] = costsInfo?.map((v) => v.toJson()).toList();
    }
    map['DetailedCostList'] = detailedCostList;
    map['PaymentYearsCount'] = paymentYearsCount;
    map['RenewYearsCount'] = renewYearsCount;
    map['TotalCost'] = totalCost;
    return map;
  }

}

class CostsInfo {
  CostsInfo({
      this.costItemDescription, 
      this.costItemTypeId, 
      this.costItemValue, 
      this.serviceTypeId,});

  CostsInfo.fromJson(dynamic json) {
    costItemDescription = json['CostItemDescription'];
    costItemTypeId = json['CostItemTypeId'];
    costItemValue = json['CostItemValue'];
    serviceTypeId = json['ServiceTypeId'];
  }
  String? costItemDescription;
  int? costItemTypeId;
  int? costItemValue;
  dynamic serviceTypeId;
CostsInfo copyWith({  String? costItemDescription,
  int? costItemTypeId,
  int? costItemValue,
  dynamic serviceTypeId,
}) => CostsInfo(  costItemDescription: costItemDescription ?? this.costItemDescription,
  costItemTypeId: costItemTypeId ?? this.costItemTypeId,
  costItemValue: costItemValue ?? this.costItemValue,
  serviceTypeId: serviceTypeId ?? this.serviceTypeId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CostItemDescription'] = costItemDescription;
    map['CostItemTypeId'] = costItemTypeId;
    map['CostItemValue'] = costItemValue;
    map['ServiceTypeId'] = serviceTypeId;
    return map;
  }

}

class ActivitiesCostDetailes {
  ActivitiesCostDetailes({
      this.activtyCost, 
      this.cleaningCost, 
      this.refrence,});

  ActivitiesCostDetailes.fromJson(dynamic json) {
    activtyCost = json['ActivtyCost'];
    cleaningCost = json['CleaningCost'];
    refrence = json['Refrence'];
  }
  int? activtyCost;
  int? cleaningCost;
  dynamic refrence;
ActivitiesCostDetailes copyWith({  int? activtyCost,
  int? cleaningCost,
  dynamic refrence,
}) => ActivitiesCostDetailes(  activtyCost: activtyCost ?? this.activtyCost,
  cleaningCost: cleaningCost ?? this.cleaningCost,
  refrence: refrence ?? this.refrence,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ActivtyCost'] = activtyCost;
    map['CleaningCost'] = cleaningCost;
    map['Refrence'] = refrence;
    return map;
  }

}

class AllowedPermits {
  AllowedPermits({
      this.id, 
      this.name,});

  AllowedPermits.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
AllowedPermits copyWith({  int? id,
  String? name,
}) => AllowedPermits(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class PreDefinedConditionsByType {
  PreDefinedConditionsByType({
    this.id,
    this.name,});

  PreDefinedConditionsByType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
  PreDefinedConditionsByType copyWith({  String? id,
    String? name,
  }) => PreDefinedConditionsByType(  id: id ?? this.id,
    name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class FastFlowConditions {
  FastFlowConditions({
    this.conditionName,
    this.required,});

  FastFlowConditions.fromJson(dynamic json) {
    conditionName = json['conditionName'];
    required = json['required'];
  }
  String? conditionName;
  bool? required;
  FastFlowConditions copyWith({  String? conditionName,
    bool? required,
  }) => FastFlowConditions(  conditionName: conditionName ?? this.conditionName,
    required: required ?? this.required,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conditionName'] = conditionName;
    map['required'] = required;
    return map;
  }

}