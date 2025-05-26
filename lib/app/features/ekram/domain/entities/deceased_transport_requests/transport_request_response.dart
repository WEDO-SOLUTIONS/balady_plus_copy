import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/transport_request_item.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/driver/transport_request_item_model.dart';

class TransportRequestResponse extends Equatable {
  List<TransportRequestItemModel>? items;
  int? totalItemCount;
  int? totalPageCount;

  TransportRequestResponse(
      {this.items, this.totalItemCount, this.totalPageCount});

  @override
  List<Object?> get props => [totalItemCount, totalPageCount];
}
