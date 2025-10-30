import '../../../_shared_feature_/data/entities/drop_down_item.dart';

class CarModel {
  String? id;
  String? carName;

  CarModel({this.id, this.carName});

  DropDownItem? getDropDownItem() {
    return DropDownItem(
        id: id, name: carName ?? "", value: carName ?? "", code: carName ?? "");
  }
}
