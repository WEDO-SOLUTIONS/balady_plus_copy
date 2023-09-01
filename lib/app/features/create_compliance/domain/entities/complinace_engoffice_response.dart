// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ComplinaecEngOfficeReponse extends Equatable {
  final List<ComplinaecEngOfficeItem>? items;

  const ComplinaecEngOfficeReponse({this.items});

  @override
  List<Object?> get props => [items];
}

class ComplinaecEngOfficeItem extends Equatable {
  final String? engOfficeNo;
  final String? engOfficeName;
  final String? cityCode;
  final String? cityName;

  ComplinaecEngOfficeItem({
    this.engOfficeNo,
    this.engOfficeName,
    this.cityCode,
    this.cityName,
  });

  @override
  List<Object?> get props => [engOfficeNo, engOfficeName];
}
