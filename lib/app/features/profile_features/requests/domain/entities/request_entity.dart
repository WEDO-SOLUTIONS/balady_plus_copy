import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  final int requestNumber;
  final String requestNumberAsText;
  final int requestStatusId;
  final String requestStatusName;
  final String requestTypeName;
  final String licenseTypeName;
  final String municipalityName;
  final String subMunicipalityName;
  final DateTime creationDate;
  final DateTime lastUpdateDate;

  const RequestEntity({
    required this.requestNumber,
    required this.requestNumberAsText,
    required this.requestStatusId,
    required this.requestStatusName,
    required this.requestTypeName,
    required this.licenseTypeName,
    required this.municipalityName,
    required this.subMunicipalityName,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  @override
  List<Object?> get props => [
        requestNumber,
        requestNumberAsText,
        requestStatusId,
        requestStatusName,
        requestTypeName,
        licenseTypeName,
        municipalityName,
        subMunicipalityName,
        creationDate,
        lastUpdateDate,
      ];
}
