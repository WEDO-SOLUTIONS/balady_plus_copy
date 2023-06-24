import '../../../_shared_feature_/data/entities/drop_down_item.dart';

class CarType {
  String? brandName;
  String? originName;
  String? modelName;

  CarType({this.brandName, this.originName, this.modelName});

  DropDownItem? getDropDownItem() {
    return DropDownItem(
        id: brandName,
        name: brandName ?? "",
        code: brandName ?? "",
        value: brandName ?? "");
  }
}
