import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/ekram/data/data_sources/ekram_remote_data_source.dart';
import 'package:balady_plus/app/features/ekram/data/model/add_trip_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/apply_deceased/apply_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/deceased_transport_requests/transport_request_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_attachment_response.dart';
import 'package:balady_plus/app/features/ekram/data/model/look_up_item_location_model.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/apply_deceased_response.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_request_details/deceased_request_details.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_location_response.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/update_driver_location_params.dart';
import 'package:balady_plus/app/features/ekram/domain/repositories/ekram_repository.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/upload_letter_params.dart';

class EkramRepositoryImpl implements EkramRepository {
  final EkramRemoteDataSource remoteDataSource;

  EkramRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getCities() async {
    try {
      final data = await remoteDataSource.getCities();

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getHospitals(
      int cityId) async {
    try {
      final data = await remoteDataSource.getHospitals(cityId);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getNationalities() async {
    try {
      final data = await remoteDataSource.getNationalities();
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<ApplyDeceasedResponse>>>
      applyDeceasedTransport(ApplyDeceasedParams params) async {
    try {
      final data = await remoteDataSource.applyDeceasedTransport(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>> getLookUp(
      int id) async {
    try {
      final data = await remoteDataSource.getLookup(id);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<TransportRequestResponseModel>>>
      getDeceasedTransportRequests(GetRequestsParams params) async {
    try {
      final data = await remoteDataSource.getDeceasedTransportRequests(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>>
      getDeceasedTransportRequestDetails(int params) async {
    try {
      final data = await remoteDataSource.getTransportRequestDetails(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedRequestDetails>>>
      getDeceasedDriverRequestDetails(int params) async {
    try {
      final data = await remoteDataSource.getDriverRequestDetails(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<TripDetails>>>> getTrips(
      int params) async {
    try {
      final data = await remoteDataSource.getTrips(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> addTrip(
      AddTripParams params) async {
    try {
      final data = await remoteDataSource.addTrip(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>>
      getLaundries(int cityId) async {
    try {
      final data = await remoteDataSource.getLaundries(cityId);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItemLocationModel>>>>
      getMosques(int cityId) async {
    try {
      final data = await remoteDataSource.getMosques(cityId);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> completeTrip(
      int params) async {
    try {
      final data = await remoteDataSource.completeTrip(params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> deleteTrip(
      int params) async {
    try {
      final data = await remoteDataSource.deleteTrip(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> uploadLetter(
      UploadLetterParamas params) async {
    try {
      final data = await remoteDataSource.uploadLetter(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel>> upadateDriverLocation(
      UpdateDriverLocationParams params) async {
    try {
      final data = await remoteDataSource.upadateDriverLocation(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<TripLocationsResponse>>>
      getTripsLocation(int params) async {
    try {
      final data = await remoteDataSource.getTripsLocation(params);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getLocations() async {
    try {
      final data = await remoteDataSource.getLocations();
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ResponseBodyModel<List<LookUpItem>>>>
      getStatus() async {
    try {
      final data = await remoteDataSource.getStatus();
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, EkramAttachmentResponse>> downLoadAttachment(
      int id) async {
    try {
      final data = await remoteDataSource.downLoadAttachment(id);
      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
