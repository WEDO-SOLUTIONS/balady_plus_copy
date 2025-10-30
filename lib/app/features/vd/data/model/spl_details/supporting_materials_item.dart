import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show SupportingMaterialsItem;

class SupportingMaterialsItemModel extends SupportingMaterialsItem {
  SupportingMaterialsItemModel({super.auxillaryMaterialType, super.dmsUri});

  factory SupportingMaterialsItemModel.fromJson(Map<String, dynamic> json) {
    SupportingMaterialsItemModel item = SupportingMaterialsItemModel(
        auxillaryMaterialType: json["AuxillaryMaterialType"],
        dmsUri: json["DMSURI"]);

    return item;
  }
}
