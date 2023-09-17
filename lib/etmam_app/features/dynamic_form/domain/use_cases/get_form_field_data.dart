import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/get_data_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetFormFieldData
    extends UseCase<ApigeeResponse<List<DropDownItem>>, GetDataParams> {
  final DynamicFormsRepository repository;

  GetFormFieldData({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<List<DropDownItem>>>> call(
      GetDataParams params) async {
    return await repository.getFormFieldData(params: params);
  }
}
