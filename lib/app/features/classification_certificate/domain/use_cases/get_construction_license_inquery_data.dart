import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';
import 'package:balady_plus/app/features/classification_certificate/domain/repository/classification_certificate_repository.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

import '../../data/model/search_request/search_request_model.dart';
import '../entity/classification_certificate_details_entity.dart';
import '../entity/classification_certificate_list_entity.dart';

class SearchClassificationCertificateUseCases extends UseCase<ClassificationCertificateListEntity, SearchRequestModel> {
  final ClassificationCertificateSearchRepository repository;

  SearchClassificationCertificateUseCases({required this.repository});
  @override
  Future<Either<Failure, ClassificationCertificateListEntity>> call(SearchRequestModel params) async {
    return await repository.searchClassificationCertificate(params);
  }
}
