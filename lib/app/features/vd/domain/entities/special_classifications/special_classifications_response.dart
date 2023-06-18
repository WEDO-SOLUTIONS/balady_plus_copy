import 'package:balady_plus/app/features/vd/vd_exports.dart' show SplItem;

class SplResponse {
  SplResponse({
    // this.totalPageCount,
    // this.totalItemCount,
    this.items,
  });

  //int? totalPageCount;
  //int? totalItemCount;
  List<SplItem>? items;
}
