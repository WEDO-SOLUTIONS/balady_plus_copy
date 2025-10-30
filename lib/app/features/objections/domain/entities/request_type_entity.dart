import 'package:equatable/equatable.dart';

import '../../../../core/utils/common_functions.dart';

class RequestTypeEntity extends Equatable {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  const RequestTypeEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  String? get name => CommonFunctions.isAppAR ? nameAr : nameEn;
  @override
  List<Object?> get props => [id, nameAr, nameEn];
}
