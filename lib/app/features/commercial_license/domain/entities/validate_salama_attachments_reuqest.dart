// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class ValidateSalamaAttachmentsRequest extends Equatable {
  final int? requestId;
  final int? salamaApprovedCenterId;
  final String? salamaIssueDate;
  final String? salamaIssueNo;
  const ValidateSalamaAttachmentsRequest(
      {this.salamaApprovedCenterId,
      this.salamaIssueDate,
      this.salamaIssueNo,
      this.requestId});

  @override
  List<Object?> get props =>
      [salamaApprovedCenterId, salamaIssueDate, salamaIssueNo, requestId];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salamaApprovedCenterId': salamaApprovedCenterId,
      'salamaIssueDate': salamaIssueDate,
      'salamaIssueNo': salamaIssueNo,
    };
  }

  ValidateSalamaAttachmentsRequest copyWith({
    int? salamaApprovedCenterId,
    String? salamaIssueDate,
    String? salamaIssueNo,
  }) {
    return ValidateSalamaAttachmentsRequest(
      salamaApprovedCenterId:
          salamaApprovedCenterId ?? this.salamaApprovedCenterId,
      salamaIssueDate: salamaIssueDate ?? this.salamaIssueDate,
      salamaIssueNo: salamaIssueNo ?? this.salamaIssueNo,
    );
  }
}
