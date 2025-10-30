// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class DeedInfoRequest extends Equatable {
  final int requestId;
  final String? deedNumber;
  final String? ownershipType;

  const DeedInfoRequest(
      {this.deedNumber, this.ownershipType, required this.requestId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "deedNumber": deedNumber,
      "ownershipType": ownershipType
    };
  }

  @override
  List<Object?> get props => [ownershipType, deedNumber, requestId];

  DeedInfoRequest copyWith({
    int? requestId,
    String? deedNumber,
    String? ownershipType,
  }) {
    return DeedInfoRequest(
        deedNumber: deedNumber ?? this.deedNumber,
        ownershipType: ownershipType ?? this.ownershipType,
        requestId: requestId ?? this.requestId);
  }
}
