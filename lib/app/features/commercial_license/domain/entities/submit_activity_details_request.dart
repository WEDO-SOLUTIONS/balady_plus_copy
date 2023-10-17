// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SubmitActivityDetailRequest {
  int? requestId;
  int workerTypeId;
  double area;
  int detailedActivityId;
  List<int>? additionalActivities;
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
    List<int>? additionalActivities,
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
      'area': area,
      'detailedActivityId': detailedActivityId,
      'additionalActivities': additionalActivities,
    };
  }

  factory SubmitActivityDetailRequest.fromMap(Map<String, dynamic> map) {
    return SubmitActivityDetailRequest(
      workerTypeId: map['workerTypeId'] as int,
      area: map['area'] as double,
      detailedActivityId: map['detailedActivityId'] as int,
      additionalActivities: map['additionalActivities'] != null
          ? List<int>.from((map['additionalActivities'] as List<int>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmitActivityDetailRequest.fromJson(String source) =>
      SubmitActivityDetailRequest.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubmitActivityDetailRequest(workerTypeId: $workerTypeId, area: $area, detailedActivityId: $detailedActivityId, additionalActivities: $additionalActivities)';
  }

  @override
  bool operator ==(covariant SubmitActivityDetailRequest other) {
    if (identical(this, other)) return true;

    return other.workerTypeId == workerTypeId &&
        other.area == area &&
        other.detailedActivityId == detailedActivityId &&
        listEquals(other.additionalActivities, additionalActivities);
  }

  @override
  int get hashCode {
    return workerTypeId.hashCode ^
        area.hashCode ^
        detailedActivityId.hashCode ^
        additionalActivities.hashCode;
  }
}
