import 'package:smart_advisor/app/features/select_activity/data/models/work_flow_model.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/work_flow_request_params.dart';

import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class GetWorkFlowUc
    extends UseCase<List<WorkFlowModel>, WorkFlowRequestParams> {
  final ActivitesRepository repository;

  GetWorkFlowUc({required this.repository});

  @override
  Future<Either<Failure, List<WorkFlowModel>>> call(
      WorkFlowRequestParams params) async {
    return await repository.getWorkFlow(params);
  }
}
