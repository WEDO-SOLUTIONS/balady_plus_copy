import 'package:balady_plus/app/features/vd/data/model/spl_details/value_item_model.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show ValueItem, AddetionalDetailsItem;
import 'package:flutter/material.dart';

class AddetionalDetailsItemModel extends AddetionalDetailsItem {
  AddetionalDetailsItemModel(
      {super.valuesList,
      super.fieldLength,
      super.fieldName,
      super.fieldType,
      super.mandatory,
      super.key});

  factory AddetionalDetailsItemModel.fromJson(Map<String, dynamic> json) {
    AddetionalDetailsItemModel list = AddetionalDetailsItemModel(
        valuesList: json["ValueList"] != null
            ? List<ValueItem>.from(
                json["ValueList"].map((x) => ValueItemModel.fromMap(x)))
            : null,
        fieldLength: json["FieldLength"],
        fieldName: json["FieldName"],
        fieldType: json["FieldType"],
        mandatory: json["Mandatory"],
        key: UniqueKey());

    /*list.valueList = list.valueList?.mapIndexed((index, e) {
      e.id = index.toString();
      return e;
    }).toList();*/

    return list;
  }

  Map<String, dynamic> toJson() => {
        "ValueList": valuesList != null
            ? List<dynamic>.from(valuesList!.map((x) => x.toModel.toJson()))
            : null,
        "FieldLength": fieldLength,
        "FieldName": fieldName,
        "FieldType": fieldType,
        "Mandatory": mandatory,
      };
}

extension AddetionalDetailsItemModelFromEntity on AddetionalDetailsItem {
  AddetionalDetailsItemModel get toModel => AddetionalDetailsItemModel(
      fieldLength: fieldLength,
      fieldName: fieldName,
      fieldType: fieldType,
      mandatory: mandatory,
      valuesList: valuesList);
}
