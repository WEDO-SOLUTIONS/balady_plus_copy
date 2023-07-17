import 'package:equatable/equatable.dart';

class SupervisingAuthorityEntity extends Equatable {
  final int agencyId;
  final String agencyName;
  final String approvalTypeId;
  final String approvalTypeName;

  const SupervisingAuthorityEntity({
    required this.agencyId,
    required this.agencyName,
    required this.approvalTypeId,
    required this.approvalTypeName,
  });

  @override
  List<Object?> get props => [
        agencyId,
        agencyName,
        approvalTypeId,
        approvalTypeName,
      ];
}
