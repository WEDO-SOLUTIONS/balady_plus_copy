import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart' show UseCase;
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/repositories/vd_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class GetGISData extends UseCase<GISResponse, GISParams> {
  final VDRepository repository;

  GetGISData({required this.repository});
  @override
  Future<Either<Failure, GISResponse>> call(GISParams params) async {
    return await repository.getGISData(params: params);
  }
}
