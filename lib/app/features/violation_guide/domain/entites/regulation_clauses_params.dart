// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class RegulationClausesParams extends Equatable {
  final String violatorTypeID;
  final String classificationID;
  final String? establishmentSizeID;

  @override
  List<Object?> get props =>
      [violatorTypeID, classificationID, establishmentSizeID];
  RegulationClausesParams({
    required this.violatorTypeID,
    required this.classificationID,
    this.establishmentSizeID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ViolatorTypeID': violatorTypeID,
      'ClassificationID': classificationID,
      'EstablishmentSizeID': establishmentSizeID,
    };
  }
}
