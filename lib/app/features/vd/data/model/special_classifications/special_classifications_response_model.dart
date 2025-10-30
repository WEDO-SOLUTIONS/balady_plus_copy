import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show SplItem, SplResponse, SplItemModel;

class SplResponseModel extends SplResponse {
  SplResponseModel({
    super.items,
  });

  factory SplResponseModel.fromMap(Map<String, dynamic> json) =>
      SplResponseModel(
          //totalItemCount: json["totalItemCount"],
          // totalPageCount: json["totalPageCount"],
          items: json["result"] != null
              ? List<SplItem>.from(
                  json["result"].map((x) => SplItemModel.fromMap(x)))
              : null);
}
