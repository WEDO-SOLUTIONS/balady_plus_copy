// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'addetional_activity_request.dart';

class SubmitActivityDetailRequest {
  int? requestId;
  int workerTypeId;
  double area;
  int detailedActivityId;
  List<AddetionalActivityRequest>? additionalActivities;
  SubmitActivityDetailRequest({
    this.requestId,
    required this.workerTypeId,
    required this.area,
    required this.detailedActivityId,
    this.additionalActivities,
  });

  SubmitActivityDetailRequest copyWith({
    int? requestId,
    int? workerTypeId,
    double? area,
    int? detailedActivityId,
    List<AddetionalActivityRequest>? additionalActivities,
  }) {
    return SubmitActivityDetailRequest(
      requestId: requestId ?? this.requestId,
      workerTypeId: workerTypeId ?? this.workerTypeId,
      area: area ?? this.area,
      detailedActivityId: detailedActivityId ?? this.detailedActivityId,
      additionalActivities: additionalActivities ?? this.additionalActivities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workerTypeId': workerTypeId,
      "mainActivity": {
        'area': area,
        'detailedActivityId': detailedActivityId,
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
