import 'dart:convert';

String eventsCountInyearsParamsToJson(EventsCountInyearsParams data) =>
    json.encode(data.toJson());

class EventsCountInyearsParams {
  String loginIdentityId;
  String loginIdentityType;
  String unifiedNationalNumber;
  int relationTypeeId;
  List<String> filterationEntity;
  AgencyInRequestDto agencyInRequestDto;
  bool hijri;
  int year;
  int page;
  int size;

  EventsCountInyearsParams({
    required this.loginIdentityId,
    required this.loginIdentityType,
    required this.unifiedNationalNumber,
    required this.relationTypeeId,
    required this.filterationEntity,
    required this.agencyInRequestDto,
    required this.hijri,
    required this.year,
    required this.page,
    required this.size,
  });

  EventsCountInyearsParams copyWith({
    String? loginIdentityId,
    String? loginIdentityType,
    String? unifiedNationalNumber,
    int? relationTypeeId,
    List<String>? filterationEntity,
    AgencyInRequestDto? agencyInRequestDto,
    bool? hijri,
    int? year,
    int? page,
    int? size,
  }) =>
      EventsCountInyearsParams(
        loginIdentityId: loginIdentityId ?? this.loginIdentityId,
        loginIdentityType: loginIdentityType ?? this.loginIdentityType,
        unifiedNationalNumber:
            unifiedNationalNumber ?? this.unifiedNationalNumber,
        relationTypeeId: relationTypeeId ?? this.relationTypeeId,
        filterationEntity: filterationEntity ?? this.filterationEntity,
        agencyInRequestDto: agencyInRequestDto ?? this.agencyInRequestDto,
        hijri: hijri ?? this.hijri,
        year: year ?? this.year,
        page: page ?? this.page,
        size: size ?? this.size,
      );

  Map<String, dynamic> toJson() => {
        "loginIdentityId": loginIdentityId,
        "loginIdentityType": loginIdentityType,
        "unifiedNationalNumber": unifiedNationalNumber,
        "relationTypeeId": relationTypeeId,
        "filterationEntity":
            List<dynamic>.from(filterationEntity.map((x) => x)),
        "agencyInRequestDto": agencyInRequestDto.toJson(),
        "hijri": hijri,
        "year": year,
        "page": page,
        "size": size,
      };
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
