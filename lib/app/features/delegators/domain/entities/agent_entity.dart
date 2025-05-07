import 'package:equatable/equatable.dart';

class AgentEntity extends Equatable {
  final String? requestId;
  final String? agencyNumber;
  final String? agencyTypeId;
  final String? agencyTypeName;
  final String? agentNumber;
  final String? agentTypeId;
  final String? agentTypeName;
  final String? agentName;
  final String? grantorName;
  final String? grantorNumber;
  final String? grantorTypeId;
  final String? grantorTypeName;
  final String? ownerNumber;
  final String? ownerTypeId;
  final String? correlationId;
  final String? active;
  final bool? isActive;

  const AgentEntity(
      {this.agencyNumber,
      this.agencyTypeId,
      this.agencyTypeName,
      this.agentNumber,
      this.agentTypeId,
      this.agentTypeName,
      this.agentName,
      this.grantorName,
      this.grantorNumber,
      this.grantorTypeId,
      this.grantorTypeName,
      this.ownerNumber,
      this.ownerTypeId,
      this.correlationId,
      this.active,
      this.isActive,
      this.requestId});

  String? get id => agentNumber;
  String? get type => agentTypeId;

  @override
  List<Object?> get props => [agencyNumber, agencyTypeId, requestId];
}
