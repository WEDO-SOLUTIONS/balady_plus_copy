import '../../../domain/entities/cemetry_requests/cemetry_request_item.dart';
import '../../../domain/entities/cemetry_requests/cemetry_request_response.dart';
import 'cemetry_request_item_model.dart';

class CemetryRequestResponseModel extends CemetryRequestResponse {
  CemetryRequestResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory CemetryRequestResponseModel.fromMap(Map<String, dynamic> json) =>
      CemetryRequestResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<CemetryRequestItem>.from(
                  json["items"].map((x) => CemetryRequestItemModel.fromJson(x)))
              : null);
}
