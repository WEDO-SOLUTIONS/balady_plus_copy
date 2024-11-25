import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/qr/submit_commercial_response_model.dart';

class ApplyCommercialRequest
    extends UseCase<SubmitCommercialResponseModel, int> {
  final CrRepository repository;

  ApplyCommercialRequest({required this.repository});
  @override
  Future<Either<Failure, SubmitCommercialResponseModel>> call(int params) async {
    return await repository.applyCommercialRequest(params: params);
  }
}
