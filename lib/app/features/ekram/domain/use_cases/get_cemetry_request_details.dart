import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/apply_deceased/apply_deceased_params.dart';
import '../entities/apply_deceased_response.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import 'package:dartz/dartz.dart' show Either;

import '../entities/cemetry_request_details/cemetry_request_details.dart';

class GetCemetryRequestDetails
    extends UseCase<ResponseBodyModel<CemetryRequestDetails>, String> {
  final EkramRepository repository;

  GetCemetryRequestDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CemetryRequestDetails>>> call(
      String params) async {
    return await repository.getCemetryRequestDetails(params);
  }
}
