import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/model/details/details_request_model.dart';
import '../../data/model/search_request/search_request_model.dart';
import '../entity/classification_certificate_details_entity.dart';
import '../entity/classification_certificate_list_entity.dart';

abstract class ClassificationCertificateSearchRepository {
  Future<Either<Failure, ClassificationCertificateListEntity>>
      searchClassificationCertificate(SearchRequestModel params);
}

abstract class DetailsClassificationCertificateRepository {
  Future<Either<Failure, ClassificationCertificateDetailsEentity>>
      getDetailsClassificationCertificate(DetailsRequestModel params);
}
