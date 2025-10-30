import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../entities/save_poster_request_params.dart';
import '../repositores/repository.dart';

class SavePoster extends UseCase<dynamic, SavePosterRequestParams> {
  final PostersRepository repository;
  SavePoster({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(SavePosterRequestParams params) async {
    return await repository.savePoster(params: params);
  }
}
