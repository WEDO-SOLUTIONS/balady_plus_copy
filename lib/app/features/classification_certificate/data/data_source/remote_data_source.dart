import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/details/details_request_model.dart';

import '../model/details/classification_certificate_details_model.dart';
import '../model/search_request/search_request_model.dart';

abstract class ClassificationCertificateSearchRemoteDataSource {
  Future<ClassificationCertificateList> searchClassificationCertificate(SearchRequestModel params);
}

abstract class ClassificationCertificateDetailsRemoteDataSource {
  Future<ClassificationCertificateDetails> getDetailsClassificationCertificate(DetailsRequestModel params);
}
