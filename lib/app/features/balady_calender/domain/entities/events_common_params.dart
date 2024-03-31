import 'dart:convert';

String eventsCountInyearsParamsToJson(EventsCommonParams data) =>
    json.encode(data.toJson());

enum UserType { owner, delegator, agency }

class EventsCommonParams {
  UserType typeUser;
  //////////////////////////////////////
  // Use This When User Selected
  String? ownerNumber;
  String? ownerTypeId;

  // Use This When Selecteded Delegator
  String? unifiedNationalNumber;
  int? relationTypeeId;

  //////////////////////////////////////
  // Use This When User Selected Agency
  AgencyInRequestDto? agencyInRequestDto;

  //////////////////////////////////////
  // This For Filter Opation
  List<String>? filterationEntity;
  bool hijri;

  EventsCommonParams({
    required this.typeUser,
    this.ownerNumber,
    this.ownerTypeId,
    this.unifiedNationalNumber,
    this.relationTypeeId,
    this.filterationEntity,
    this.agencyInRequestDto,
    this.hijri = false,
  });

  EventsCommonParams copyWith({
    String? loginIdentityId,
    String? loginIdentityType,
    String? unifiedNationalNumber,
    int? relationTypeeId,
    List<String>? filterationEntity,
    AgencyInRequestDto? agencyInRequestDto,
    bool? hijri,
    UserType? typeUser,
  }) =>
      EventsCommonParams(
        ownerNumber: loginIdentityId ?? this.ownerNumber,
        ownerTypeId: loginIdentityType ?? this.ownerTypeId,
        unifiedNationalNumber:
            unifiedNationalNumber ?? this.unifiedNationalNumber,
        relationTypeeId: relationTypeeId ?? this.relationTypeeId,
        filterationEntity: filterationEntity ?? this.filterationEntity,
        agencyInRequestDto: agencyInRequestDto ?? this.agencyInRequestDto,
        hijri: hijri ?? this.hijri,
        typeUser: typeUser ?? this.typeUser,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "hijri": hijri,
      "type": typeUser.index,
    };
    if (filterationEntity?.isNotEmpty ?? false) {
      data["filterationEntity"] = List<dynamic>.from(
        filterationEntity!.map((x) => x),
      );
    }
    if (agencyInRequestDto != null) {
      data["agencyNumber"] = agencyInRequestDto!.agencyNumber;
      data["ownerNumber"] = agencyInRequestDto!.ownerNumber;
      data["ownerTypeId"] = agencyInRequestDto!.ownerTypeId;
    } else {
      if (ownerNumber != null) {
        data["ownerNumber"] = ownerNumber;
      }
      if (ownerTypeId != null) {
        data["ownerTypeId"] = ownerTypeId;
      }
      if (unifiedNationalNumber != null) {
        data["unifiedNationalNumber"] = unifiedNationalNumber;
      }
      if (relationTypeeId != null) {
        data["relationTypeId"] = relationTypeeId;
      }
    }
    return data;
  }
}

class AgencyInRequestDto {
  String agencyNumber;
  String ownerNumber;
  String ownerTypeId;

  AgencyInRequestDto({
    required this.agencyNumber,
    required this.ownerNumber,
    required this.ownerTypeId,
  });

  AgencyInRequestDto copyWith({
    String? agencyNumber,
    String? ownerNumber,
    String? ownerTypeId,
  }) =>
      AgencyInRequestDto(
        agencyNumber: agencyNumber ?? this.agencyNumber,
        ownerNumber: ownerNumber ?? this.ownerNumber,
        ownerTypeId: ownerTypeId ?? this.ownerTypeId,
      );

  Map<String, dynamic> toJson() => {
        "agencyNumber": agencyNumber,
        "ownerNumber": ownerNumber,
        "ownerTypeId": ownerTypeId,
      };
}
