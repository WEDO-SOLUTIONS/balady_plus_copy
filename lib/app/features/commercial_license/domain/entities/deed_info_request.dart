// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class DeedInfoRequest extends Equatable {
  final String? deedNumber;
  final String? ownershipType;

  const DeedInfoRequest({
    this.deedNumber,
    this.ownershipType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }

  @override
  List<Object?> get props => [ownershipType, deedNumber];
}
