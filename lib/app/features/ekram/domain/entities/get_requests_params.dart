class GetRequestsParams {
  int page;
  int size;
  String? text;
  int? deceasedTransportRequestStatusId;
  int? transportLocationStatusId;
  bool? isMultiCity;
  GetRequestsParams(
      {required this.page,
      required this.size,
      this.text,
      this.deceasedTransportRequestStatusId,
      this.transportLocationStatusId,
      this.isMultiCity});
}
