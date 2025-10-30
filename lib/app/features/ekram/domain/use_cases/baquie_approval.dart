import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/baqie_approval_response.dart';
import '../entities/active_grave_request_params.dart';
import '../repositories/ekram_repository.dart';

class BaquieApproval
    extends UseCase<BaqieApprovalResponse, ActiveGraveRequestParams> {
  final EkramRepository repository;
  BaquieApproval({required this.repository});
  @override
  Future<Either<Failure, BaqieApprovalResponse>> call(
      ActiveGraveRequestParams params) async {
    return await repository.baqieApproval(params);
  }
}
