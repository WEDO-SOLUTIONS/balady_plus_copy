import 'package:balady_plus/app/features/classification_certificate/domain/repository/classification_certificate_repository.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

import '../entity/classification_certificate_details_entity.dart';

class SearchClassificationCertificateUseCases extends UseCase<ClassificationCertificateDetailsEntity, (int, String)> {
  final ClassificationCertificateSearchRepository repository;

  SearchClassificationCertificateUseCases({required this.repository});
  @override
  Future<Either<Failure, ClassificationCertificateDetailsEntity>> call(
      (int, String) params) async {
    return await repository.searchClassificationCertificate(params.$1, params.$2);
  }
}
