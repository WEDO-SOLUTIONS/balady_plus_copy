import 'package:balady_plus/app/features/municipal_services/municipal_advisor/domain/entities/building_compliance_entity.dart';
import 'package:equatable/equatable.dart';

class BuildingComplianceModel extends BuildingComplianceEntity {
  BuildingComplianceModel({
    super.streetname,
    super.municipalityname,
    super.amananame,
    super.stageno,
    super.targetbuildingtype,
    super.startdate,
    super.priorityarea,
  });

  factory BuildingComplianceModel.fromJson(Map<String, dynamic> json) =>
      BuildingComplianceModel(
        streetname: json["STREETNAME"],
        municipalityname: json["MUNICIPALITYNAME"],
        amananame: json["AMANANAME"],
        stageno: json["STAGENO"],
        targetbuildingtype: json["TARGETBUILDINGTYPE"],
        startdate: json["STARTDATE"],
        priorityarea: json["PRIORITYAREA"],
      );
}
