import '/app/features/map/data/models/gis_data_response_model.dart';
import '/app/features/map/domain/entities/gis_data_request.dart';
import '/app/features/map/domain/entities/gis_data_response.dart';
import '/app/features/map/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetGISDataUC extends UseCase<GisDataResponse, GISDataRequest> {
  final SmartAdvisorMapRepository repository;

  GetGISDataUC({required this.repository});

  @override
  Future<Either<Failure, GisDataResponse>> call(GISDataRequest request) async {
    return await repository.getGISData(request);
  }
}
