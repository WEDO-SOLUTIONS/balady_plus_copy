import 'package:equatable/equatable.dart';

class BuildingComplianceEntity extends Equatable {
  final String? streetname;
  final String? municipalityname;
  final String? amananame;
  final String? stageno;
  final String? targetbuildingtype;
  final String? startdate;
  final String? priorityarea;

  BuildingComplianceEntity({
    this.streetname,
    this.municipalityname,
    this.amananame,
    this.stageno,
    this.targetbuildingtype,
    this.startdate,
    this.priorityarea,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
