import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../entities/deceased_transport_requests/get_orgnizations_params.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import 'package:dartz/dartz.dart' show Either;

import '../entities/get_cemetries_params.dart';

class GetEkramOrgnizations extends UseCase<ResponseBodyModel<List<LookUpItem>>,
    GetOrgnizationsParams> {
  final EkramRepository repository;

  GetEkramOrgnizations({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> call(
      GetOrgnizationsParams params) async {
    return await repository.getEkramOrgnizations(params);
  }
}
