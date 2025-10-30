import 'package:equatable/equatable.dart';

import 'crm_request_item.dart';

class CRMRequestEntity extends Equatable {
  final String? totalRecordCount;
  final List<CRMRequestItem>? incidentRequestList;

  CRMRequestEntity({
    this.totalRecordCount,
    this.incidentRequestList,
  });

  factory CRMRequestEntity.fromJson(Map<String, dynamic> json) =>
      CRMRequestEntity(
        totalRecordCount: json["TotalRecordCount"],
        incidentRequestList: json["IncidentRequestList"] == null
            ? []
            : List<CRMRequestItem>.from(json["IncidentRequestList"]!
                .map((x) => CRMRequestItem.fromJson(x))),
      );

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
