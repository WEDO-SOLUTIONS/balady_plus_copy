import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/model/details/details_request_model.dart';
import '../../data/model/lookups/activity_lookups_model.dart';
import '../../data/model/lookups/classification_certificate_lookups_model.dart';
import '../../data/model/search_request/activities_request_model.dart';
import '../../data/model/search_request/lookups_request_model.dart';
import '../../data/model/search_request/search_request_model.dart';
import '../entity/classification_certificate_details_entity.dart';
import '../entity/classification_certificate_list_entity.dart';

abstract class ClassificationCertificateSearchRepository {
  Future<Either<Failure, ClassificationCertificateListEntity>>
      searchClassificationCertificate(SearchRequestModel params);
}

abstract class ClassificationCertificateLookupsRepository {
  Future<Either<Failure, ClassificationCertificateLookupsModel>> getLookups(
      LookupsRequestModel params);

  Future<Either<Failure, List<ActivityLookupsModel>>> getActivitiesBySectors(
      ActivitiesRequestModel params);
}

abstract class DetailsClassificationCertificateRepository {
  Future<Either<Failure, ClassificationCertificateDetailsEentity>>
      getDetailsClassificationCertificate(DetailsRequestModel params);

  Future<Either<Failure, File>> getAttachedClassificationCertificate(
      String url, String fileName);
}
