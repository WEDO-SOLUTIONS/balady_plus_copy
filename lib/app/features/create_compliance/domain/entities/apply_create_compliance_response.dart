// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class ApplyCreateComplianceResponse extends Equatable {
  final int? result;

  const ApplyCreateComplianceResponse({this.result});

  @override
  List<Object?> get props => [];

  factory ApplyCreateComplianceResponse.fromMap(Map<String, dynamic> map) {
    return ApplyCreateComplianceResponse(
      result: map['result'] != null ? map['result'] as int : null,
    );
  }
}
