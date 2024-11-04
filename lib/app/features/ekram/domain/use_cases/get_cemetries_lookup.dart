import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import 'package:dartz/dartz.dart' show Either;

import '../entities/get_cemetries_params.dart';

class GetCemetriesLookUp
    extends UseCase<ResponseBodyModel<List<LookUpItem>>, List<dynamic>> {
  final EkramRepository repository;

  GetCemetriesLookUp({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> call(List<dynamic> params) async {
    return await repository.getCemetriesLookUp(params[0],params[1]);
  }
}