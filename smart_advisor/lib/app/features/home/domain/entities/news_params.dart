class NewsParams {
  String? title;
  DateTime? dateFrom;
  DateTime? dateTo;
  int? pageIndex;
  int? pageSize;

  NewsParams(
      {this.dateFrom, this.dateTo, this.pageIndex, this.pageSize, this.title});

  Map<String, dynamic> toMap() => {
        "Title": title,
        "PageInfo.PageSize": pageSize,
        "PageInfo.PageIndex": pageIndex,
        "DateFrom": dateFrom,
        "DateTo": dateTo,
      };
}
