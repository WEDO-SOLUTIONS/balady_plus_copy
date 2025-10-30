// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/complinace_engoffice_response.dart';

class ComplinaecEngOfficeReponseModel extends ComplinaecEngOfficeReponse {
  const ComplinaecEngOfficeReponseModel({super.items});

  factory ComplinaecEngOfficeReponseModel.fromJson(dynamic json) =>
      ComplinaecEngOfficeReponseModel(
        items: json == null
            ? []
            : List<ComplinaecEngOfficeItemModel>.from(
                json!.map((x) => ComplinaecEngOfficeItemModel.fromJson(x))),
      );
  @override
  List<Object?> get props => [items];
}

class ComplinaecEngOfficeItemModel extends ComplinaecEngOfficeItem {
  ComplinaecEngOfficeItemModel({
    super.cityCode,
    super.cityName,
    super.engOfficeName,
    super.engOfficeNo,
  });

  factory ComplinaecEngOfficeItemModel.fromJson(Map<String, dynamic> json) =>
      ComplinaecEngOfficeItemModel(
        engOfficeNo: json["EngOfficeNO"],
        engOfficeName: json["EngOfficeName"],
        cityCode: json["CityCode"],
        cityName: json["CityName"],
      );

  @override
  List<Object?> get props => [engOfficeNo, engOfficeName];
}
