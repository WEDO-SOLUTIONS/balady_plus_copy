import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/apply_deceased/apply_deceased_params.dart';
import '../entities/apply_deceased_response.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import 'package:dartz/dartz.dart' show Either;

import '../entities/get_cemetries_params.dart';

class GetCemetries
    extends UseCase<ResponseBodyModel<List<LookUpItem>>, GetCemetriesParams> {
  final EkramRepository repository;

  GetCemetries({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> call(
      GetCemetriesParams params) async {
    return await repository.getCemetries(params);
  }
}
