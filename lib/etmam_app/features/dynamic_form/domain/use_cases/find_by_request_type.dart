import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class FindByRequestType
    extends UseCase<ApigeeResponse<List<BiddingTypeResponse>>, NoParams> {
  final DynamicFormsRepository repository;

  FindByRequestType({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<List<BiddingTypeResponse>>>> call(
      NoParams params) async {
    return await repository.findByRequestType();
  }
}
