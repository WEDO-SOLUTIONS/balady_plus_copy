import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show CategoriesResponse, CategoryParams, GISParams, GISResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;

import '../../../_shared_feature_/data/models/response_body_model.dart';

abstract class VDRepository {
  Future<Either<Failure, GISResponse>> getGISData({required GISParams params});
}
