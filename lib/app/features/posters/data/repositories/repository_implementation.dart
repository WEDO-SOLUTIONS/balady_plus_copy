import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:balady_plus/app/features/posters/data/models/attachment_resposne_model.dart';
import 'package:balady_plus/app/features/posters/data/models/group_item_response_model.dart';
import 'package:balady_plus/app/features/posters/data/models/permit_apply_group_response_model.dart';
import 'package:balady_plus/app/features/posters/data/models/permit_license_response_model.dart';
import 'package:balady_plus/app/features/posters/data/models/permit_poster_types_response.dart';
import 'package:balady_plus/app/features/posters/domain/entities/permit_apply_group_request_params.dart';
import 'package:balady_plus/app/features/posters/domain/entities/permit_licenses_requests_params.dart';
import 'package:balady_plus/app/features/posters/domain/entities/permit_required_types_params.dart';
import 'package:balady_plus/app/features/posters/domain/entities/save_poster_request_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart'
    show
        Failure,
        NoDataFoundException,
        NoDataFoundFailure,
        ServerException,
        ServerFailure;
import '../../domain/repositores/repository.dart';
import '../data_sources/remote_data_source.dart';

class PostersRepositoryImplementation implements PostersRepository {
  final PostersRemoteDataSource remoteDataSource;

  PostersRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, PermitApplyGroupResponse>> applyPermitLicenseGroup(
      {required PermitApplyGroupRequestParams params}) async {
    try {
      final data =
          await remoteDataSource.applyPermitLicenseGroup(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, AttachmentResponseModel>> getAttachmentTypes(
      {required PermitRequiredTypesParams params}) async {
    try {
      final data = await remoteDataSource.getAttachmentTypes(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, GroupItemResponseModel>> getGroupItems() async {
    try {
      final data = await remoteDataSource.getGroupItems();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PermitsLicensesResponse>> getLicensePermits(
      {required PermitLicenseRequestParams params}) async {
    try {
      final data = await remoteDataSource.getLicensePermits(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PermitPosterTypeResponse>>
      getPErmitPosterTypes() async {
    try {
      final data = await remoteDataSource.getPErmitPosterTypes();
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }

  @override
  Future<Either<Failure, dynamic>> savePoster(
      {required SavePosterRequestParams params}) async {
    try {
      final data = await remoteDataSource.savePoster(params: params);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
