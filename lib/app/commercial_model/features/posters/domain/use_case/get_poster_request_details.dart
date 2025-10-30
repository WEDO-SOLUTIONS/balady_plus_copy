import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/poster_request_details_model.dart';
import '../repositores/repository.dart';

class GetPosterRequestDetails extends UseCase<PosterRequestDetailsModel, int> {
  final PostersRepository repository;
  GetPosterRequestDetails({required this.repository});
  @override
  Future<Either<Failure, PosterRequestDetailsModel>> call(int params) async {
    return await repository.getPosterRequestDetails(params: params);
  }
}
