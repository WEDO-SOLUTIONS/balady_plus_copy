import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchItem;

class SearchResponse {
  SearchResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  int? totalPageCount;
  int? totalItemCount;
  List<SearchItem>? items;
}
