import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show CreateIncidentResponse;
import 'package:equatable/equatable.dart';

class CreateIncidentResponseModel extends CreateIncidentResponse {
  CreateIncidentResponseModel({super.incidentId});

  factory CreateIncidentResponseModel.fromMap(Map<String, dynamic> json) =>
      CreateIncidentResponseModel(
        incidentId: json["incidentId"],
      );
}
