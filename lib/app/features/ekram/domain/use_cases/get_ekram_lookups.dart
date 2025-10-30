import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../ekram_exports.dart';
import '../entities/get_requests_params.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class GetEkramLookUp
    extends UseCase<ResponseBodyModel<List<LookUpItem>>, String> {
  final EkramRepository repository;

  GetEkramLookUp({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> call(
      String params) async {
    return await repository.getEkramLookUp(params);
  }
}
