import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/ekram_repository.dart';

class VerifyDeceased extends UseCase<ResponseBodyModel, VerifyDeceasedParams> {
  final EkramRepository repository;
  VerifyDeceased({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel>> call(
      VerifyDeceasedParams params) async {
    return await repository.verifyDeceased(params);
  }
}
