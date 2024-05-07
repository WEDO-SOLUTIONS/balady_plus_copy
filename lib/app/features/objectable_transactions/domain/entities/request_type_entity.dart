import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';

class RequestTypeEntity extends Equatable {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  const RequestTypeEntity({this.id, this.nameAr, this.nameEn});

  String? get name => CommonFunctions.isAppAR ? nameAr : nameEn;

  @override
  List<Object?> get props => [id, nameEn, nameAr];
}
