import 'package:balady_plus/app/features/profile_features/violations/domain/entities/violation_details_entity.dart';
import 'package:balady_plus/app/features/profile_features/violations/domain/entities/violations_entity.dart';

class CreateViolationObjectionPageParams {
  ViolationsEntity? item;
  ViolationDetailsEntity? details;

  CreateViolationObjectionPageParams({this.details, this.item});
}
