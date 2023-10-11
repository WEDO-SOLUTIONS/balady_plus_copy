import 'package:balady_plus/app/features/vd/domain/entities/categories/category_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/categories/category_params.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';

import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, VDRemoteDataSource, VDLocalDataSource, SplParams;

import 'package:dartz/dartz.dart' show Either, Left, Right;

import 'package:balady_plus/app/core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;

import '../../../_shared_feature_/data/models/response_body_model.dart';

class VDRepositoryImpl implements VDRepository {
  final VDRemoteDataSource remoteDataSource;
  final VDLocalDataSource localDataSource;

  VDRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, GISResponse>> getGISData(
      {required GISParams params}) async {
    try {
      final data = await remoteDataSource.getGISData(params: params);

      return Right(data);
    } on ServerException catch (error) {
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
