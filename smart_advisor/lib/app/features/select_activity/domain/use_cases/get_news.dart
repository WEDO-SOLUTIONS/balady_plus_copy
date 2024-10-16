import '/app/features/home/home_exports.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetNewsUc extends UseCase<NewsResponse, NewsParams> {
  final SmartAdvisorHomeRepository repository;

  GetNewsUc({required this.repository});

  @override
  Future<Either<Failure, NewsResponse>> call(NewsParams params) async {
    return await repository.getNews(params);
  }
}
