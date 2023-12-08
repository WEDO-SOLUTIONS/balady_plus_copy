import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        CategoriesResponse,
        CategoryParams,
        SplParams,
        SplResponse,
        GISParams,
        GISResponse,
        SPLDetailsResponse,
        SPLDetailsParams,
        UploadFileResponse,
        UploadFileParams,
        OTPParams,
        OTPResponse,
        CreateIncidentParams,
        CreateIncidentResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;

import '../../../_shared_feature_/data/models/response_body_model.dart';

abstract class VDRepository {
  Future<Either<Failure, CategoriesResponse>> getCategories(
      {required CategoryParams params});

  Future<Either<Failure, SplResponse>> getSpecialClassifications(
      {required SplParams params});

  Future<Either<Failure, GISResponse>> getGISData({required GISParams params});

  Future<Either<Failure, SPLDetailsResponse>> getSPLDetails(
      {required SPLDetailsParams params});
  Future<Either<Failure, UploadFileResponse>> uploadFile(
      {required UploadFileParams params});
  Future<Either<Failure, OTPResponse>> getOTP({required OTPParams params});

  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createIncidentUnRegistered({required CreateIncidentParams params});
  Future<Either<Failure, ResponseBodyModel<CreateIncidentResponse>>>
      createIncidentRegistered({required CreateIncidentParams params});

  Future<Either<Failure, bool>> checkCr({required String params});
}
