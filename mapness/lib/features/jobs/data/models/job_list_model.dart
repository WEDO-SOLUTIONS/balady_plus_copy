import 'package:flutter/foundation.dart';
import 'package:mapness/features/jobs/data/models/job_model.dart';

//TODO(Scroollocker): change to equatable
@immutable
class JobListModel {
  const JobListModel({
    this.records,
    this.totalRecordsCount,
    this.pagesCount,
  });

  factory JobListModel.fromJson(Map<String, dynamic> json) => JobListModel(
        records: json['records'] != null
            ? List<JobModel>.from(
                (json['records'] as List<dynamic>).map(
                  (x) => JobModel.fromJson(x as Map<String, dynamic>),
                ),
              )
            : null,
        totalRecordsCount: json['totalRecordsCount'] as int?,
        pagesCount: json['pagesCount'] as int?,
      );
  final List<JobModel>? records;
  final int? totalRecordsCount;
  final int? pagesCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is JobListModel &&
        listEquals(other.records, records) &&
        other.totalRecordsCount == totalRecordsCount &&
        other.pagesCount == pagesCount;
  }

  @override
  int get hashCode => records.hashCode ^ totalRecordsCount.hashCode ^ pagesCount.hashCode;

  JobListModel copyWith({
    List<JobModel>? records,
    int? totalRecordsCount,
    int? pagesCount,
  }) =>
      JobListModel(
        records: records ?? this.records,
        totalRecordsCount: totalRecordsCount ?? this.totalRecordsCount,
        pagesCount: pagesCount ?? this.pagesCount,
      );
}
