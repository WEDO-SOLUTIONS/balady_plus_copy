import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/apply_deceased/apply_deceased_params.dart';
import '../entities/apply_deceased_response.dart';
import '../entities/get_requests_params.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import 'package:dartz/dartz.dart' show Either;

import '../entities/cemetry_requests/cemetry_request_response.dart';

class GetCemetryRequests extends UseCase<
    ResponseBodyModel<CemetryRequestResponse>, GetRequestsParams> {
  final EkramRepository repository;

  GetCemetryRequests({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CemetryRequestResponse>>> call(
      GetRequestsParams params) async {
    return await repository.getCemetryRequests(params);
  }
}
