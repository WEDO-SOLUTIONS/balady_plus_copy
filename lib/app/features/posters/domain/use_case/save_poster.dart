import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
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
