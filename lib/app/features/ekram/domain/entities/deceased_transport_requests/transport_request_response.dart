import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/transport_request_item.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/driver/request_item_model.dart';

class TransportRequestResponse extends Equatable {
  List<RequestItemModel>? items;
  int? totalItemCount;
  int? totalPageCount;

  TransportRequestResponse(
      {this.items, this.totalItemCount, this.totalPageCount});

  @override
  List<Object?> get props => [totalItemCount, totalPageCount];
}
