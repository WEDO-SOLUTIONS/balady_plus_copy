import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;


abstract class VDRepository {
  Future<Either<Failure, GISResponse>> getGISData({required GISParams params});
}
