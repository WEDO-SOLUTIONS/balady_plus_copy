import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/look_up_item_location_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/look_up_item_location_model.dart';
import '../entities/lookup_item_location.dart';
import '../repositories/ekram_repository.dart';

class GetLaundriesLookup extends UseCase<
    ResponseBodyModel<List<LookUpItemLocationModel>>, List<dynamic>>  {
  final EkramRepository repository;


GetLaundriesLookup({required this.repository});
@override
Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>> call(
List<dynamic> params) async {
return await repository.getLaundriesLookup(params[0], params[1], params[2]);
}
}
