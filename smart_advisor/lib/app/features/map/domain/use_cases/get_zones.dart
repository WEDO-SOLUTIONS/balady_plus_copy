import '/app/features/map/domain/entities/get_zones_request.dart';
import '/app/features/map/domain/entities/zone_item.dart';
import '/app/features/map/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class GetZonesUC extends UseCase<List<ZoneItem>, GetZonesRequest> {
  final SmartAdvisorMapRepository repository;

  GetZonesUC({required this.repository});

  @override
  Future<Either<Failure, List<ZoneItem>>> call(GetZonesRequest request) async {
    return await repository.getZones(request);
  }
}
