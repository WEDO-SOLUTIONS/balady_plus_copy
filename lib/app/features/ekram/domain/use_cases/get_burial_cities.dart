import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class GetBurialCities
    extends UseCase<ResponseBodyModel<List<LookUpItem>>, NoParams> {
  final EkramRepository repository;

  GetBurialCities({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> call(
      NoParams params) async {
    return await repository.getBurialCities();
  }
}
