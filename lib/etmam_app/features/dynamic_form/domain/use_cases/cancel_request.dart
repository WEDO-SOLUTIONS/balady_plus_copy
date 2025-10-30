import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/get_offers_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class CancelRequest extends UseCase<ApigeeResponse<dynamic>, String> {
  final DynamicFormsRepository repository;

  CancelRequest({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<dynamic>>> call(String params) async {
    return await repository.cancelRequest(paramas: params);
  }
}
