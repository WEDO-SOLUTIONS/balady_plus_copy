import 'dart:convert';

import '../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';

class AddetionalActivityResponse {
  final List<AddetionalActivityItem>? result;

  AddetionalActivityResponse({
    this.result,
  });

  factory AddetionalActivityResponse.fromJson(Map<String, dynamic> json) =>
      AddetionalActivityResponse(
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
