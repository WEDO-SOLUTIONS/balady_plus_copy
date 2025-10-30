import 'package:balady_plus/app/features/vd/vd_exports.dart' show ValueItem;

class ValueItemModel extends ValueItem {
  ValueItemModel({super.addlFeildValue, super.fieldId, super.id});

  factory ValueItemModel.fromMap(Map<String, dynamic> json) => ValueItemModel(
        addlFeildValue: json["AddlFeildValue"],
        fieldId: json["FieldID"],
      );

  Map<String, dynamic> toJson() => {
        "AddlFeildValue": addlFeildValue,
        "FieldID": fieldId,
      };
}

extension ValueItemModelFromEntity on ValueItem {
  ValueItemModel get toModel =>
      ValueItemModel(addlFeildValue: addlFeildValue, fieldId: fieldId, id: id);
}
