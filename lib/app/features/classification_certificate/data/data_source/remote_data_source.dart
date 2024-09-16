

import '../model/classification_certificate_details_model.dart';

abstract class ClassificationCertificateSearchRemoteDataSource {
  Future<ClassificationCertificateDetailsModel> searchClassificationCertificate(int licenseNumber, String date);
}

abstract class ClassificationCertificateDetailsRemoteDataSource {
  Future<ClassificationCertificateDetailsModel> getDetailsClassificationCertificate(
      int licenseNumber, String date);
}
