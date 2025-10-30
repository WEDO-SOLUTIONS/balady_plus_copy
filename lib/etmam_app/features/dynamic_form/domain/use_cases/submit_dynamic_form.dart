import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class SubmitDynamicForm
    extends UseCase<ApigeeResponse<SubmitFormResponse>, SubmitFormParams> {
  final DynamicFormsRepository repository;

  SubmitDynamicForm({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<SubmitFormResponse>>> call(
      SubmitFormParams params) async {
    return await repository.submitForm(params: params);
  }
}
