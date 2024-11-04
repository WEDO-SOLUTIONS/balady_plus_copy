import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/lookup_item_location.dart';
import '../repositories/ekram_repository.dart';

class GetMosquesLookup extends UseCase<
    ResponseBodyModel<List<LookUpItemLocation>>, List<dynamic>> {
  final EkramRepository repository;

  GetMosquesLookup({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocation>>>> call(
      List<dynamic> params) async {
    return await repository.getMosquesLookUp(params[0], params[1]);
  }
}
