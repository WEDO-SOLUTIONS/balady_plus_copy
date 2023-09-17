import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class CreateBiddingForm extends UseCase<
    ApigeeResponse<List<CreateFormItemResponse>>, CreateFormParams> {
  final DynamicFormsRepository repository;

  CreateBiddingForm({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<List<CreateFormItemResponse>>>> call(
      CreateFormParams params) async {
    return await repository.createBiddingForm(params: params);
  }
}
