import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchResponse, SearchItem, SearchItemModel;

class SearchResponseModel extends SearchResponse {
  SearchResponseModel(
      {super.items, super.totalItemCount, super.totalPageCount});

  factory SearchResponseModel.fromMap(Map<String, dynamic> json) =>
      SearchResponseModel(
          totalItemCount: json["totalItemCount"],
          totalPageCount: json["totalPageCount"],
          items: json["items"] != null
              ? List<SearchItem>.from(
                  json["items"].map((x) => SearchItemModel.fromMap(x)))
              : null);
}
