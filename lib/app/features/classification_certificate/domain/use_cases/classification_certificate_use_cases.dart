import 'dart:io';

import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';
import 'package:balady_plus/app/features/classification_certificate/domain/repository/classification_certificate_repository.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

import '../../data/model/details/details_request_model.dart';
import '../../data/model/lookups/activity_lookups_model.dart';
import '../../data/model/lookups/classification_certificate_lookups_model.dart';
import '../../data/model/search_request/activities_request_model.dart';
import '../../data/model/search_request/lookups_request_model.dart';
import '../../data/model/search_request/search_request_model.dart';
import '../entity/classification_certificate_details_entity.dart';
import '../entity/classification_certificate_list_entity.dart';

class GetLookupsClassificationCertificateUseCases
    extends UseCase<ClassificationCertificateLookupsModel, LookupsRequestModel> {
  final ClassificationCertificateLookupsRepository repository;

  GetLookupsClassificationCertificateUseCases({required this.repository});

  @override
  Future<Either<Failure, ClassificationCertificateLookupsModel>> call(
      LookupsRequestModel params) async {
    return await repository.getLookups(params);
  }
}

class GetActivitiesClassificationCertificateUseCases
    extends UseCase<List<ActivityLookupsModel>, ActivitiesRequestModel> {
  final ClassificationCertificateLookupsRepository repository;

  GetActivitiesClassificationCertificateUseCases({required this.repository});

  @override
  Future<Either<Failure, List<ActivityLookupsModel>>> call(
      ActivitiesRequestModel params) async {
    return await repository.getActivitiesBySectors(params);
  }
}


/////////////////////////////////////////////////////////////////
class SearchClassificationCertificateUseCases
    extends UseCase<ClassificationCertificateListEntity, SearchRequestModel> {
  final ClassificationCertificateSearchRepository repository;

  SearchClassificationCertificateUseCases({required this.repository});

  @override
  Future<Either<Failure, ClassificationCertificateListEntity>> call(
      SearchRequestModel params) async {
    return await repository.searchClassificationCertificate(params);
  }
}
/////////////////////////////////////////////////////////////////
class GetDetailsClassificationCertificateUseCases extends UseCase<
    ClassificationCertificateDetailsEentity, DetailsRequestModel> {
  final DetailsClassificationCertificateRepository repository;

  GetDetailsClassificationCertificateUseCases({required this.repository});

  @override
  Future<Either<Failure, ClassificationCertificateDetailsEentity>> call(
      DetailsRequestModel params) async {
    return await repository.getDetailsClassificationCertificate(params);
  }
}

class GetAttachedClassificationCertificateUseCases extends UseCase<File, (String url, String fileName)> {
  final DetailsClassificationCertificateRepository repository;

  GetAttachedClassificationCertificateUseCases({required this.repository});

  @override
  Future<Either<Failure, File>> call(params) async {
    return await repository.getAttachedClassificationCertificate(params.$1,params.$2);
  }
}
