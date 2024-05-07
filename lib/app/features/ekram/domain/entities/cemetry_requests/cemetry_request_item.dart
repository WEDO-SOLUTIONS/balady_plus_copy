import 'package:equatable/equatable.dart';

class CemetryRequestItem extends Equatable {
  CemetryRequestItem(
      {this.entryModeId,
      this.deceasedIdentityNumber,
      this.deceasedName,
      this.requestNumber,
      this.requestUniqueKey,
      this.cemeteryId,
      this.cemeteryName,
      this.burialDate,
      this.burialTimeId,
      this.burialTimeName,
      this.burialTimeOther,
      this.requestStatusId,
      this.requestStatusName});

  final dynamic entryModeId;
  final String? deceasedIdentityNumber;
  final String? deceasedName;
  final int? requestNumber;
  final String? requestUniqueKey;
  final int? cemeteryId;
  final String? cemeteryName;
  final String? burialDate;
  final int? burialTimeId;
  final String? burialTimeName;
  final String? burialTimeOther;
  final int? requestStatusId;
  final String? requestStatusName;

  String? get burialTime =>
      burialTimeId == 30976 ? burialTimeOther : burialTimeName;

  @override
  List<Object?> get props => [];
}
