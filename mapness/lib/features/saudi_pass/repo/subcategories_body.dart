import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/momra_body.dart';

part 'subcategories_body.g.dart';

@noRenameNoToJson
class SubcategoriesBody
    extends MomraBody<Iterable<SubCategory>, SubcategoriesData> {
  SubcategoriesBody({required super.statusDetails, super.data});

  factory SubcategoriesBody.fromJson(Map<String, dynamic> json) =>
      _$SubcategoriesBodyFromJson(json);
}

@noRenameNoToJson
class SubcategoriesData extends Data<Iterable<SubCategory>> {
  SubcategoriesData({
    required super.responseCode,
    required super.responseMessage,
    required super.responseId,
    required super.result,
  });

  factory SubcategoriesData.fromJson(Map<String, dynamic> json) =>
      _$SubcategoriesDataFromJson(json);
}
