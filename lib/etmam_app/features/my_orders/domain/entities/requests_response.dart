import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show RequestItem;

class RequestsResponse extends Equatable {
  RequestsResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  int? totalPageCount;
  int? totalItemCount;
  List<RequestItem>? items;

  @override
  List<Object?> get props => [];
}
