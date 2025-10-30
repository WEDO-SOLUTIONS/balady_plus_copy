// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ComplianceDeedInfoRequest extends Equatable {
  final String? ownerId;

  final String? ownerIdType;

  final String? deedNumber;
  const ComplianceDeedInfoRequest({
    this.ownerId,
    this.ownerIdType,
    this.deedNumber,
  });

  @override
  List<Object?> get props => [ownerId, ownerIdType, deedNumber];

  ComplianceDeedInfoRequest copyWith({
    String? ownerId,
    String? ownerIdType,
    String? deedNumber,
  }) {
    return ComplianceDeedInfoRequest(
      ownerId: ownerId ?? this.ownerId,
      ownerIdType: ownerIdType ?? this.ownerIdType,
      deedNumber: deedNumber ?? this.deedNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (ownerId != null) 'ownerId': ownerId,
      if (ownerIdType != null) 'ownerIdType': ownerIdType,
      'deedNumber': deedNumber,
    };
  }
}
