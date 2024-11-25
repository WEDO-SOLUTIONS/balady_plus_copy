import 'dart:convert';

import '../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';

class AdditionalActivityResponseModel {
  final List<AddetionalActivityItem>? result;

  AdditionalActivityResponseModel({
    this.result,
  });

  factory AdditionalActivityResponseModel.fromJson(Map<String, dynamic> json) =>
      AdditionalActivityResponseModel(
        result: json["result"] == null
            ? []
            : List<AddetionalActivityItem>.from(
                json["result"]!.map((x) => AddetionalActivityItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class AddetionalActivityItem extends DropDownItem {
  final String? isicCode;
  final String? isicName;

  AddetionalActivityItem({
    this.isicCode,
    this.isicName,
  }) : super(
          id: isicCode ?? '',
          name: isicName ?? '',
        );

  factory AddetionalActivityItem.fromJson(Map<String, dynamic> json) =>
      AddetionalActivityItem(
        isicCode: json["isicCode"],
        isicName: json["isicName"],
      );

  Map<String, dynamic> toJson() => {
        "isicCode": isicCode,
        "isicName": isicName,
      };
}
