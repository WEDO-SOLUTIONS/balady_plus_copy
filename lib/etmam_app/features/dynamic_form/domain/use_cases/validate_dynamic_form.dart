import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class ValidateDynamicForm
    extends UseCase<ApigeeResponse<ValidateFormResponse>, ValidateFormParams> {
  final DynamicFormsRepository repository;
  ValidateDynamicForm({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<ValidateFormResponse>>> call(
      ValidateFormParams params) async {
    return await repository.validateForm(params: params);
  }
}
