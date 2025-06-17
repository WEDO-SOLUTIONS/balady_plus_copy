import 'package:balady_plus/super_app_js_bridge/camera/special_classifications/special_classifications_item.dart';

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
