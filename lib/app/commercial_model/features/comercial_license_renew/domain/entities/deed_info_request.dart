import 'package:equatable/equatable.dart';

class DeedInfoRequest extends Equatable {
  final String? deedNumber;
  final String? ownerId;
  final String? ownerIdType;

  const DeedInfoRequest({this.deedNumber, this.ownerId, this.ownerIdType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "DeedNumber": deedNumber,
      "OwnerId": ownerId,
      "ownerIdType": ownerIdType
    };
  }

  @override
  List<Object?> get props => [ownerIdType, deedNumber, ownerId];

  DeedInfoRequest copyWith({
    String? deedNumber,
    String? ownerId,
    String? ownerIdType,
  }) {
    return DeedInfoRequest(
      deedNumber: deedNumber ?? this.deedNumber,
      ownerId: ownerId ?? this.ownerId,
      ownerIdType: ownerIdType ?? this.ownerIdType,
    );
  }
}
