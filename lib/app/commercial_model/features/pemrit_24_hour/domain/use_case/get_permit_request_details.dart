import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_request_details_model.dart';
import '../repositores/repository.dart';

class GetPermitRequestDetails
    extends UseCase<Permit24RequestDetailsModel, int> {
  final Permits24Repository repository;
  GetPermitRequestDetails({required this.repository});
  @override
  Future<Either<Failure, Permit24RequestDetailsModel>> call(int params) async {
    return await repository.getPermitRequestDetails(params: params);
  }
}
