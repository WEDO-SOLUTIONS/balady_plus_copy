import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';

class EventsCountInMonthsParams extends EventsCommonParams {
  //////////////////////////////////////
  int year;

  EventsCountInMonthsParams({
    super.loginIdentityId,
    super.loginIdentityType,
    super.unifiedNationalNumber,
    super.relationTypeeId,
    super.filterationEntity,
    super.agencyInRequestDto,
    super.hijri,
    required this.year,
  });

  @override
  EventsCountInMonthsParams copyWith({
    String? loginIdentityId,
    String? loginIdentityType,
    String? unifiedNationalNumber,
    int? relationTypeeId,
    List<String>? filterationEntity,
    AgencyInRequestDto? agencyInRequestDto,
    bool? hijri,
    int? year,
  }) =>
      EventsCountInMonthsParams(
        loginIdentityId: loginIdentityId ?? super.loginIdentityId,
        loginIdentityType: loginIdentityType ?? super.loginIdentityType,
        unifiedNationalNumber:
            unifiedNationalNumber ?? super.unifiedNationalNumber,
        relationTypeeId: relationTypeeId ?? super.relationTypeeId,
        filterationEntity: filterationEntity ?? super.filterationEntity,
        agencyInRequestDto: agencyInRequestDto ?? super.agencyInRequestDto,
        hijri: hijri ?? super.hijri,
        year: year ?? this.year,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data["years"] = year;
    return data;
  }
}
