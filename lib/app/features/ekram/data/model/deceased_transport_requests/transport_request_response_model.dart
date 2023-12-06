import 'package:balady_plus/app/features/ekram/data/model/deceased_transport_requests/transport_request_item_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/transport_request_response.dart';

class TransportRequestResponseModel extends TransportRequestResponse {
  TransportRequestResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory TransportRequestResponseModel.fromMap(Map<String, dynamic> json) =>
      TransportRequestResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<TransportRequestItemModel>.from(json["items"]
                  .map((x) => TransportRequestItemModel.fromJson(x)))
              : null);
}
