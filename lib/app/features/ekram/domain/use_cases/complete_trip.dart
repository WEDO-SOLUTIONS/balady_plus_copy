import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/ekram_repository.dart';
import 'package:dartz/dartz.dart' show Either;

class CompleteTrip extends UseCase<ResponseBodyModel<dynamic>, int> {
  final EkramRepository repository;
  CompleteTrip({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> call(int params) async {
    return await repository.completeTrip(params);
  }
}
