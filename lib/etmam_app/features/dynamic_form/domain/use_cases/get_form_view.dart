import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/form_data_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/get_data_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

class GetFormView extends UseCase<ApigeeResponse<FormDataResponse>, String> {
  final DynamicFormsRepository repository;

  GetFormView({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<FormDataResponse>>> call(
      String params) async {
    return await repository.getFormData(paramas: params);
  }
}
