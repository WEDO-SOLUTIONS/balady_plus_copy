/*
class TopRatedProviderResponseModel extends TopRatedProviderResponse {
  TopRatedProviderResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory TopRatedProviderResponseModel.fromMap(Map<String, dynamic> json) =>
      TopRatedProviderResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<TopRatedProviderItem>.from(json["items"]
                  .map((x) => TopRatedProviderItemModel.fromMap(x)))
              : null);
}
*/
