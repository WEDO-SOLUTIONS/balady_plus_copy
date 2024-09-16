import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entity/classification_certificate_details_entity.dart';

abstract class ClassificationCertificateSearchRepository {
  Future<Either<Failure, ClassificationCertificateDetailsEntity>>
      searchClassificationCertificate(int licenseNumber, String date);
}
