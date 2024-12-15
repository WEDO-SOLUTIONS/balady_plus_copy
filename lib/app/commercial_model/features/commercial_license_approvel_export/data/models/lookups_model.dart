import '../../commercial_license_exports.dart';
import '../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';
class LookupsModel extends DropDownItem {
  final int lookupId;
  final String lookupMame;
  const LookupsModel({
   required this.lookupId,
    required this.lookupMame,
  }) : super(name: lookupMame, id: lookupId);

  String? get text => lookupMame;

  factory LookupsModel.fromJson(Map<String, dynamic> json) => LookupsModel(
    lookupId: json["id"],
    lookupMame: json["name"],
      );
}
