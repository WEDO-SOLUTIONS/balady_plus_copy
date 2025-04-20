import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/entity/MunicipalityLookUp.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/entity/city_entity.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/entity/register_observer_request.dart';

import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entity/observer_status_entity.dart';

import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class CertifiedObserverRepositoryImplementation implements CertifiedObserverRepository {
  final CertifiedObserverRemoteDataSource remoteDataSource;

  CertifiedObserverRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ObserverStatusEntity>> getObserverStatus(String identityNumber) async {
    try {

      final data = await remoteDataSource.getObserverStatus(identityNumber);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, ResponseBodyModel<List<MunicipalityLookUp>>>> getMuncipalityList() async{
    try {

      final data = await remoteDataSource.getMuncipalityList();
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, ResponseBodyModel<bool>>> checkMuncipalityAcceptance(String id) async{
    try {

      final data = await remoteDataSource.checkMuncipalityAcceptance(id);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<CityEntity>>>> getCityList(String municipalityId)async {
    try {
      final data = await remoteDataSource.getCityList(municipalityId);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, List<DistrictsEntity>>> getDistrictByCityIdList(String cityId) async {
    try {
      final data = await remoteDataSource.getDistrictByCityIdList(cityId);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, bool>> registrationObserver(RegisterObserverRequest request) async {
    try {
      final data = await remoteDataSource.registrationObserver(request);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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


  ////////////////// For Freelancer Certificate //////////////////

  @override
  Future<Either<Failure, Map<String,dynamic>>> createNewFreelancerCertificate() async {
    try {
      final data = await remoteDataSource.createNewFreelancerCertificate();
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, Map<String,dynamic>>> getFreelancerCertificateStatus() async {
    try {
      final data = await remoteDataSource.getFreelancerCertificateStatus();
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, Map<String,dynamic>>> updateFreelancerCertificate(String  certificateNumber) async {
    try {
      final data = await remoteDataSource.updateFreelancerCertificate(certificateNumber);
      return Right(data);
    } on NoDataFoundException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.toString()));
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



}
