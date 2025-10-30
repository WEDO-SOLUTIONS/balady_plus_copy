part of 'my_orders_bloc.dart';

class MyOrdersState extends Equatable {
  BlocStatus status;
  List<OrderItem>? items;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  String? errorMessage;
  bool? closed;

  MyOrdersState(
      {this.status = BlocStatus.initial,
      this.items,
      this.errorMessage,
      this.nextPageIndex = 1,
      this.totalItemCount,
      this.closed,
      this.totalPageCount});

  MyOrdersState copyWith(
      {BlocStatus? status,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      List<OrderItem>? items,
      bool? closed,
      bool? clearClose,
      String? subServiceId,
      String? errorMessage}) {
    return MyOrdersState(
        status: status ?? this.status,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        items: items ?? this.items,
        closed: clearClose == true ? null : closed ?? this.closed,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  int gettCurrenttTabIndex() {
    if (closed == null) return 0;
    if (closed == false) return 1;
    if (closed == true) return 2;
    return 0;
  }

  @override
  List<Object> get props => [status];
}
