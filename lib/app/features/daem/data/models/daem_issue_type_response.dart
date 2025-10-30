import '../../../transaction_inquiry/presentation/core/models/error_result.dart';
import 'daem_item.dart';

class DaemIssueTypeResponse {
  DaemIssueTypeResponse({
    this.categoryTypeList,
    this.errors,
  });

  List<IssueTypeList>? categoryTypeList;
  List<ErrorResult>? errors;

  factory DaemIssueTypeResponse.fromJson(Map<String, dynamic> json) =>
      DaemIssueTypeResponse(
        categoryTypeList: json["IssueTypeList"] != null
            ? List<IssueTypeList>.from(
                json["IssueTypeList"].map((x) => IssueTypeList.fromJson(x)))
            : null,
        errors: json["errors"] != null
            ? List<ErrorResult>.from(
                json["errors"].map((x) => ErrorResult.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "IssueTypeList":
            List<dynamic>.from(categoryTypeList!.map((x) => x.toJson())),
        "errors": List<dynamic>.from(errors!.map((x) => x)),
      };
  List<DaemItem> getList() {
    return categoryTypeList
            ?.map((e) => DaemItem(id: e.issueType, name: e.issueType))
            .toList() ??
        [];
  }
}

class IssueTypeList {
  IssueTypeList({
    this.issueType,
  });

  String? issueType;

  factory IssueTypeList.fromJson(Map<String, dynamic> json) => IssueTypeList(
        issueType: json["IssueType"],
      );

  Map<String, dynamic> toJson() => {
        "IssueType": issueType,
      };
  /*@override
  String? getName() {
    return issueType;
  }*/

  @override
  List<Object> get props => issueType != null ? [issueType!] : [];
}
