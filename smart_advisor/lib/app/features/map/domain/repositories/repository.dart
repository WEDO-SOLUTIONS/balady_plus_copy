import '../../data/models/map_requests_params.dart';
import '../../data/models/point_layers_data.dart';
import '/app/features/map/domain/entities/get_zones_request.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/gis_data_response.dart';
import '/app/features/map/domain/entities/validate_point_request.dart';
import '/app/features/map/domain/entities/validate_point_response.dart';
import '/app/features/map/domain/entities/zone_item.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;

abstract class SmartAdvisorMapRepository {
  Future<Either<Failure, List<ZoneItem>>> getZones(GetZonesRequest params);

  Future<Either<Failure, List<ValidatePointResponse>>> validatePoint(
      ValidatePointRequest params);

  Future<Either<Failure, GisDataResponse>> getGISData(GISDataRequest params);
  Future<Either<Failure, List<PointLayersData>?>> getPointsInLayers(
      MapRequestParams params);
}
