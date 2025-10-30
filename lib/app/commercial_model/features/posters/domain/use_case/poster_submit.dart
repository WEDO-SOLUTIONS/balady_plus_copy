import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../repositores/repository.dart';

class PosterSubmit extends UseCase<PostersSubmitResponseModel, int> {
  final PostersRepository repository;
  PosterSubmit({required this.repository});
  @override
  Future<Either<Failure, PostersSubmitResponseModel>> call(int params) async {
    return await repository.submit(params: params);
  }
}
