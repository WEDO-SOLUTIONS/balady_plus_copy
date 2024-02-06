import 'dart:convert';

String eventsParamsToJson(EventsDetailsParams data) => json.encode(data.toJson());

class EventsDetailsParams {
  // String loginIdentityId;
  // String loginIdentityType;
  // String unifiedNationalNumber;
  // int relationTypeeId;
  List<String>? filterationEntity;
  // AgencyInRequestDto agencyInRequestDto;
  bool hijri;
  int year;
  int page;
  int size;

  EventsDetailsParams({
    // required this.loginIdentityId,
    // required this.loginIdentityType,
    // required this.unifiedNationalNumber,
    // required this.relationTypeeId,
    this.filterationEntity,
    // required this.agencyInRequestDto,
    required this.year,
    this.hijri = false,
    this.page = 0,
    this.size = 12,
  });

  EventsDetailsParams copyWith({
    String? loginIdentityId,
    String? loginIdentityType,
    String? unifiedNationalNumber,
    int? relationTypeeId,
    List<String>? filterationEntity,
    // AgencyInRequestDto? agencyInRequestDto,
    bool? hijri,
    int? year,
    int? page,
    int? size,
  }) =>
      EventsDetailsParams(
        // loginIdentityId: loginIdentityId ?? this.loginIdentityId,
        // loginIdentityType: loginIdentityType ?? this.loginIdentityType,
        // unifiedNationalNumber:
        //     unifiedNationalNumber ?? this.unifiedNationalNumber,
        // relationTypeeId: relationTypeeId ?? this.relationTypeeId,
        // filterationEntity: filterationEntity ?? this.filterationEntity,
        // agencyInRequestDto: agencyInRequestDto ?? this.agencyInRequestDto,
        hijri: hijri ?? this.hijri,
        year: year ?? this.year,
        page: page ?? this.page,
        size: size ?? this.size,
      );

  Map<String, dynamic> toJson() => {
        // "loginIdentityId": loginIdentityId,
        // "loginIdentityType": loginIdentityType,
        // "unifiedNationalNumber": unifiedNationalNumber,
        // "relationTypeeId": relationTypeeId,
        // "filterationEntity":
        //     List<dynamic>.from(filterationEntity.map((x) => x)),
        // "agencyInRequestDto": agencyInRequestDto.toJson(),
        "hijri": hijri,
        "year": year,
        "page": page,
        "size": size,
      };
}

// class AgencyInRequestDto {
//   String agencyNumber;
//   String ownerNumber;
//   String ownerTypeId;
//
//   AgencyInRequestDto({
//     required this.agencyNumber,
//     required this.ownerNumber,
//     required this.ownerTypeId,
//   });
//
//   AgencyInRequestDto copyWith({
//     String? agencyNumber,
//     String? ownerNumber,
//     String? ownerTypeId,
//   }) =>
//       AgencyInRequestDto(
//         agencyNumber: agencyNumber ?? this.agencyNumber,
//         ownerNumber: ownerNumber ?? this.ownerNumber,
//         ownerTypeId: ownerTypeId ?? this.ownerTypeId,
//       );
//
//   Map<String, dynamic> toJson() => {
//         "agencyNumber": agencyNumber,
//         "ownerNumber": ownerNumber,
//         "ownerTypeId": ownerTypeId,
//       };
// }
