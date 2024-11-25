// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'addetional_activity_request.dart';

class SubmitActivityDetailRequest {
  int? requestId;
  int workerTypeId;
  double area;
  int detailedActivityId;
  int? accommodationTypeId;
  int? unitCount;
  List<AddetionalActivityRequest>? additionalActivities;
  bool? atmFeesPaid;
  SubmitActivityDetailRequest(
      {this.requestId,
      required this.workerTypeId,
      required this.area,
      required this.detailedActivityId,
      this.additionalActivities,
      this.accommodationTypeId,
      this.unitCount,
      this.atmFeesPaid});

  SubmitActivityDetailRequest copyWith(
      {int? requestId,
      int? workerTypeId,
      double? area,
      int? detailedActivityId,
      List<AddetionalActivityRequest>? additionalActivities,
      int? accommodationTypeId,
      int? unitCount,
      bool? atmFeesPaid}) {
    return SubmitActivityDetailRequest(
        requestId: requestId ?? this.requestId,
        workerTypeId: workerTypeId ?? this.workerTypeId,
        area: area ?? this.area,
        detailedActivityId: detailedActivityId ?? this.detailedActivityId,
        additionalActivities: additionalActivities ?? this.additionalActivities,
        accommodationTypeId: accommodationTypeId ?? this.accommodationTypeId,
        unitCount: unitCount ?? this.unitCount,
        atmFeesPaid: atmFeesPaid ?? this.atmFeesPaid);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workerTypeId': workerTypeId,
      if (atmFeesPaid != null) 'atmFeesPaid': atmFeesPaid,
      "mainActivity": {
        'area': area,
        'detailedActivityId': detailedActivityId,
        if (accommodationTypeId != null)
          "accommodationTypeId": accommodationTypeId,
        if (unitCount != null) "unitCount": unitCount
      },
      'additionalActivities': additionalActivities != null
          ? additionalActivities
              ?.map((e) => {
                    "detailedActivityId": e.detailsItem?.activityId,
                    "area": e.area
                  })
              .toList()
          : [],
    };
  }

  @override
  int get hashCode {
    return workerTypeId.hashCode ^
        area.hashCode ^
        detailedActivityId.hashCode ^
        additionalActivities.hashCode;
  }
}
