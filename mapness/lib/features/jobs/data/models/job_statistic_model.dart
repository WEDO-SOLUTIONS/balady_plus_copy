import 'package:flutter/foundation.dart';

//TODO(Scroollocker): change to equatable
@immutable
class JobStatisticModel {
  const JobStatisticModel({
    this.jobsCount,
    this.providersCount,
  });

  factory JobStatisticModel.fromJson(Map<String, dynamic> json) => JobStatisticModel(
        jobsCount: json['jobsCount'] as int?,
        providersCount: json['providersCount'] as int?,
      );
  final int? jobsCount;
  final int? providersCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is JobStatisticModel && other.jobsCount == jobsCount && other.providersCount == providersCount;
  }

  @override
  int get hashCode => jobsCount.hashCode ^ providersCount.hashCode;
}
