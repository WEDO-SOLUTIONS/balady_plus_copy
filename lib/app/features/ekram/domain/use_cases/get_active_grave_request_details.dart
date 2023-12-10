import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/apply_deceased/grave_active_request_details.dart';
import '../entities/active_grave_request_params.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class GetActiveGraveRequestDetails extends UseCase<
    ResponseBodyModel<GraveActiveRequestDetails>, ActiveGraveRequestParams> {
  final EkramRepository repository;

  GetActiveGraveRequestDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<GraveActiveRequestDetails>>> call(
      ActiveGraveRequestParams params) async {
    return await repository.getActiveGraveRequestDetails(params);
  }
}
