import 'package:equatable/equatable.dart';

import '../../domain/entities/crm_request_entity.dart';
import 'crm_request_item_model.dart';

class CRMRequestModel extends CRMRequestEntity {
  CRMRequestModel({
    super.totalRecordCount,
    super.incidentRequestList,
  });

  factory CRMRequestModel.fromJson(Map<String, dynamic> json) =>
      CRMRequestModel(
        totalRecordCount: json["TotalRecordCount"],
        incidentRequestList: json["IncidentRequestList"] == null
            ? []
            : List<CRMRequestItemModel>.from(json["IncidentRequestList"]!
                .map((x) => CRMRequestItemModel.fromJson(x))),
      );

  @override
  List<Object?> get props => [];
}
