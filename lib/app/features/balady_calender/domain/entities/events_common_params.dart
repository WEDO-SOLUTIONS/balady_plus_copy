import 'dart:convert';

String eventsCountInyearsParamsToJson(EventsCommonParams data) =>
    json.encode(data.toJson());

class EventsCommonParams {
  //////////////////////////////////////
  // Use This When User Delegators Selected
  String? loginIdentityId;
  String? loginIdentityType;
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
    this.loginIdentityId,
    this.loginIdentityType,
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
  }) =>
      EventsCommonParams(
        loginIdentityId: loginIdentityId ?? this.loginIdentityId,
        loginIdentityType: loginIdentityType ?? this.loginIdentityType,
        unifiedNationalNumber:
            unifiedNationalNumber ?? this.unifiedNationalNumber,
        relationTypeeId: relationTypeeId ?? this.relationTypeeId,
        filterationEntity: filterationEntity ?? this.filterationEntity,
        agencyInRequestDto: agencyInRequestDto ?? this.agencyInRequestDto,
        hijri: hijri ?? this.hijri,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "hijri": hijri,
    };
    if (filterationEntity?.isNotEmpty ?? false) {
      data["filterationEntity"] = List<dynamic>.from(
        filterationEntity!.map((x) => x),
      );
    }
    if (agencyInRequestDto != null) {
      data["agencyInRequestDto"] = agencyInRequestDto!.toJson();
    } else {
      if (loginIdentityId != null) {
        data["loginIdentityId"] = loginIdentityId;
      }
      if (loginIdentityType != null) {
        data["loginIdentityType"] = loginIdentityType;
      }
      if (unifiedNationalNumber != null) {
        data["unifiedNationalNumber"] = unifiedNationalNumber;
      }
      if (relationTypeeId != null) {
        data["relationTypeeId"] = relationTypeeId;
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
