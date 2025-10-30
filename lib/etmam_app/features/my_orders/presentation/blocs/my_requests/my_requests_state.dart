part of 'my_requests_bloc.dart';

class MyRequestsState extends Equatable {
  BlocStatus status;
  List<RequestItem>? items;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  String? errorMessage;
  bool? closed;

  MyRequestsState(
      {this.status = BlocStatus.initial,
      this.items,
      this.errorMessage,
      this.nextPageIndex = 1,
      this.totalItemCount,
      this.closed,
      this.totalPageCount});

  MyRequestsState copyWith(
      {BlocStatus? status,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      List<RequestItem>? items,
      bool? closed,
      bool? clearClose,
      String? subServiceId,
      String? errorMessage}) {
    return MyRequestsState(
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
