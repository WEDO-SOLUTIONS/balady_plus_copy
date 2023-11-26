import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/transport_request_item.dart';
import 'package:equatable/equatable.dart';

class TransportRequestResponse extends Equatable {
  List<TransportRequestItem>? items;
  int? totalItemCount;
  int? totalPageCount;

  TransportRequestResponse(
      {this.items, this.totalItemCount, this.totalPageCount});

  @override
  List<Object?> get props => [totalItemCount, totalPageCount];
}
