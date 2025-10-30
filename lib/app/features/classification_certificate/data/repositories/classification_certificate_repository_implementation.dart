import 'dart:io';

import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/classification_certificate/data/data_source/remote_data_source_implementation.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/classification_certificate_list.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/details/details_request_model.dart';
import 'package:balady_plus/app/features/classification_certificate/domain/entity/classification_certificate_details_entity.dart';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/repository/classification_certificate_repository.dart';
import '../model/lookups/activity_lookups_model.dart';
import '../model/lookups/classification_certificate_lookups_model.dart';
import '../model/search_request/activities_request_model.dart';
import '../model/search_request/lookups_request_model.dart';
import '../model/search_request/search_request_model.dart';

class ClassificationCertificateRepositoryImplementation
    implements
        ClassificationCertificateSearchRepository,
        DetailsClassificationCertificateRepository,
        ClassificationCertificateLookupsRepository {
  final ClassificationCertificateRemoteDataSource remoteDataSource;

  ClassificationCertificateRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ClassificationCertificateLookupsModel>> getLookups(
      LookupsRequestModel params) async {
    try {
      final data = await remoteDataSource.getLookups(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ActivityLookupsModel>>> getActivitiesBySectors(
      ActivitiesRequestModel params) async {
    try {
      final data = await remoteDataSource.getActivitiesBySectors(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ClassificationCertificateList>>
      searchClassificationCertificate(SearchRequestModel params) async {
    try {
      final data =
          await remoteDataSource.searchClassificationCertificate(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      if (error.errorCode == "204") {
        return Left(NoDataFoundFailure());
      }
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ClassificationCertificateDetailsEentity>>
      getDetailsClassificationCertificate(DetailsRequestModel params) async {
    try {
      final data =
          await remoteDataSource.getDetailsClassificationCertificate(params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, File>> getAttachedClassificationCertificate(
      String url, String fileName) async {
    try {
      var tempDir = await getTemporaryDirectory();
      String path = "${tempDir.path}/$fileName";
      File file = File(path);
      bool isExists = await file.exists();
      // if(isExists) {
      //   return Right(file);
      // } else {
        final data = await remoteDataSource.getAttachedClassificationCertificate(
          url,
          path,
        );
        return Right(data);
      // }
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error, stackTrace) {
      if (error.errorCode == "204") {
        return Left(NoDataFoundFailure());
      }
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
