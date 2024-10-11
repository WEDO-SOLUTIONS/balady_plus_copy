import 'dart:io';

import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/details/details_request_model.dart';

import '../model/details/classification_certificate_details_model.dart';
import '../model/lookups/activity_lookups_model.dart';
import '../model/lookups/classification_certificate_lookups_model.dart';
import '../model/search_request/activities_request_model.dart';
import '../model/search_request/lookups_request_model.dart';
import '../model/search_request/search_request_model.dart';

abstract class ClassificationCertificateSearchRemoteDataSource {
  Future<ClassificationCertificateList> searchClassificationCertificate(SearchRequestModel params);
}

abstract class ClassificationCertificateLookupsRemoteDataSource {
  Future<List<ActivityLookupsModel>> getActivitiesBySectors(ActivitiesRequestModel params);
  Future<ClassificationCertificateLookupsModel> getLookups(LookupsRequestModel params);
}

abstract class ClassificationCertificateDetailsRemoteDataSource {
  Future<ClassificationCertificateDetails> getDetailsClassificationCertificate(DetailsRequestModel params);
  Future<File> getAttachedClassificationCertificate(String attachUrl, String path);
}
