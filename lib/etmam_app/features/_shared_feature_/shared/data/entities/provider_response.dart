import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ProviderItem;

class ProviderResponse {
  ProviderResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  int? totalPageCount;
  int? totalItemCount;
  List<ProviderItem>? items;
}
