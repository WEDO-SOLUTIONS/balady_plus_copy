import 'dart:convert';

import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';

String eventsParamsToJson(EventsDetailsParams data) =>
    json.encode(data.toJson());

class EventsDetailsParams extends EventsCountInMonthsParams {
  int page;
  int size;

  EventsDetailsParams({
    super.loginIdentityId,
    super.loginIdentityType,
    super.unifiedNationalNumber,
    super.relationTypeeId,
    super.filterationEntity,
    super.agencyInRequestDto,
    super.hijri,
    required super.year,
    this.page = 0,
    this.size = 12,
  });

  @override
  EventsDetailsParams copyWith({
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
      EventsDetailsParams(
        loginIdentityId: loginIdentityId ?? super.loginIdentityId,
        loginIdentityType: loginIdentityType ?? super.loginIdentityType,
        unifiedNationalNumber:
            unifiedNationalNumber ?? super.unifiedNationalNumber,
        relationTypeeId: relationTypeeId ?? super.relationTypeeId,
        filterationEntity: filterationEntity ?? super.filterationEntity,
        agencyInRequestDto: agencyInRequestDto ?? super.agencyInRequestDto,
        hijri: hijri ?? super.hijri,
        year: year ?? super.year,
        page: page ?? this.page,
        size: size ?? this.size,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data["page"] = page;
    data["size"] = size;
    return data;
  }
}
