import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_poster_types_response.dart';
import '../repositores/repository.dart';

class GetPermitPosterTypes extends UseCase<PermitPosterTypeResponse, NoParams> {
  final PostersRepository repository;
  GetPermitPosterTypes({required this.repository});
  @override
  Future<Either<Failure, PermitPosterTypeResponse>> call(
      NoParams params) async {
    return await repository.getPErmitPosterTypes();
  }
}
