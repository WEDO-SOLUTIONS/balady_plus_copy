import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../entities/submit_tobacco_request.dart';
import '../repositores/repository.dart';

class SubmitPermitTobacco
    extends UseCase<PermitTobaccoSubmitResponseModel, SubmitTobaccoRequest> {
  final PermitsTobaccoRepository repository;
  SubmitPermitTobacco({required this.repository});
  @override
  Future<Either<Failure, PermitTobaccoSubmitResponseModel>> call(
      SubmitTobaccoRequest params) async {
    return await repository.submit(params: params);
  }
}
