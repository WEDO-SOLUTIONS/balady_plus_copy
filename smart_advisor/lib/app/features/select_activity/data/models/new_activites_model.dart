import 'dart:convert';

import 'package:flutter/services.dart';

List<RegulationsDataItem> allRegulationsData = [];

void loadRegulationsData() async {
  final String isicsDetails = await rootBundle.loadString(
      'packages/smart_advisor/smart_advisor_assets/files/new_isics_data.json');
  var data1 = await json.decode(isicsDetails);
  for (var item in data1) {
    allRegulationsData.add(RegulationsDataItem.fromJson(item));
  }
}

class RegulationsDataItem {
  final String categoryRegulationName;
  final int categoryId;
  final String categoryName;
  final int subCategoryId;
  final String subCategory;
  final String isicName;
  final int isicBaladyCode;
  final int dActivitiesId;
  final String dActivitiesName;
  final int activitiesSum;
  final int categorySum;
  final int subCategorySum;

  RegulationsDataItem({
    required this.categoryRegulationName,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryId,
    required this.subCategory,
    required this.isicName,
    required this.isicBaladyCode,
    required this.dActivitiesId,
    required this.dActivitiesName,
    required this.activitiesSum,
    required this.categorySum,
    required this.subCategorySum,
  });

  factory RegulationsDataItem.fromJson(Map<String, dynamic> json) {
    return RegulationsDataItem(
      categoryRegulationName: json['CATEGORY_REGULATION_NAME'],
      categoryId: json['CATEGORY_ID'],
      categoryName: json['CATEGORY_NAME'],
      subCategoryId: json['SUB_CATEGORY_ID'],
      subCategory: json['SUB_CATEGORY'],
      isicName: json['ISIC_NAME'],
      isicBaladyCode: json['ISIC_BALADY_CODE'],
      dActivitiesId: json['D_ACTIVITIES_ID'],
      dActivitiesName: json['D_ACTIVITIES_NAME'],
      activitiesSum: json['Activites_SUM'],
      categorySum: json['Category_SUM'],
      subCategorySum: json['Sub-category_SUM'],
    );
  }
}
