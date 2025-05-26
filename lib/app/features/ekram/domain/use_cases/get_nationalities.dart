import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../repositories/ekram_repository.dart';

class GetNationalities
    extends UseCase<ResponseBodyModel<List<LookUpItem>>, int?> {
  final EkramRepository repository;

  GetNationalities({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> call(int? identityTypeId) async {
    return await repository.getNationalities(identityTypeId);
  }
}
