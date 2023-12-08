import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ObjectionEntity extends Equatable {
  final DateTime? lastUpdatedDate;
  final String? requestStatusId;
  final String? serviceGroupName;
  final String? serviceGroupId;
  final String? municipalityName;
  final String? serviceId;
  final String? objectionRequestNumber;
  final String? objectionTypeName;
  final String? serviceName;
  final String? subMunicipalityName;
  final DateTime? requestCreationDate;
  final String? objectionTypeId;
  final String? requestStatusName;
  final String? hashingRequestNumber;
  final String? serviceTypeId;

  const ObjectionEntity(
      {this.lastUpdatedDate,
      this.requestStatusId,
      this.serviceGroupName,
      this.serviceGroupId,
      this.municipalityName,
      this.serviceId,
      this.objectionRequestNumber,
      this.objectionTypeName,
      this.serviceName,
      this.subMunicipalityName,
      this.requestCreationDate,
      this.objectionTypeId,
      this.requestStatusName,
      this.hashingRequestNumber,
      this.serviceTypeId});

  String get createDateStr => requestCreationDate != null
      ? DateFormat.yMd().format(requestCreationDate!)
      : "";

  String get lastUpdateStr =>
      lastUpdatedDate != null ? DateFormat.yMd().format(lastUpdatedDate!) : "";

  @override
  List<Object?> get props => [
        requestStatusId,
        requestStatusName,
        municipalityName,
        subMunicipalityName,
      ];
}
