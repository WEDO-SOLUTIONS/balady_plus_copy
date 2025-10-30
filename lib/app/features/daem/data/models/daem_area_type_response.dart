import '../../../transaction_inquiry/presentation/core/models/error_result.dart';
import 'daem_item.dart';

class DaemAreaTypeResponse {
  DaemAreaTypeResponse({
    this.areaList,
    this.errors,
  });

  List<AreaList>? areaList;
  List<ErrorResult>? errors;

  factory DaemAreaTypeResponse.fromJson(Map<String, dynamic> json) =>
      DaemAreaTypeResponse(
        areaList: json["AreaList"] != null
            ? List<AreaList>.from(
                json["AreaList"].map((x) => AreaList.fromJson(x)))
            : null,
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "AreaList": List<dynamic>.from(areaList!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };

  List<DaemItem> getList() {
    return areaList
            ?.map((e) => DaemItem(id: e.area ?? "", name: e.area ?? ""))
            .toList() ??
        [];
  }
}

class AreaList {
  AreaList({
    this.area,
  });

  String? area;

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
        area: json["Area"],
      );

  Map<String, dynamic> toJson() => {
        "Area": area,
      };

  /*DropDownItem getDropDownItem() {
    return DropDownItem(id: area, name: area);
  }

  @override
  String? getName() {
    return area;
  }*/

  @override
  List<Object> get props => area != null ? [area!] : [];
}
