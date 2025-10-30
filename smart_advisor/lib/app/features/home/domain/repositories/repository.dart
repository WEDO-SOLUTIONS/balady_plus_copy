import '/app/features/home/home_exports.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class SmartAdvisorHomeRepository {
  Future<Either<Failure, NewsResponse>> getNews(NewsParams params);
}
