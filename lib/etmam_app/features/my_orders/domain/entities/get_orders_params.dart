class GetOrdersParams {
  bool? closed;
  bool? hasPendingCancelRequest;
  String pageIndex;

  GetOrdersParams(
      {this.closed, this.hasPendingCancelRequest, required this.pageIndex});
}
