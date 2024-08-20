import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../repositores/repository.dart';

class SubmitPermit24 extends UseCase<PermitSubmitResponseModel, int> {
  final Permits24Repository repository;
  SubmitPermit24({required this.repository});
  @override
  Future<Either<Failure, PermitSubmitResponseModel>> call(int params) async {
    return await repository.submit(params: params);
  }
}
