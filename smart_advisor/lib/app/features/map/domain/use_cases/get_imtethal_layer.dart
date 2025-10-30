import '../../data/models/map_requests_params.dart';
import '../../data/models/point_layers_data.dart';
import '/app/features/map/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetImtethalLayer
    extends UseCase<List<PointLayersData>?, MapRequestParams> {
  final SmartAdvisorMapRepository repository;

  GetImtethalLayer({required this.repository});

  @override
  Future<Either<Failure, List<PointLayersData>?>> call(
      MapRequestParams request) async {
    return await repository.getPointsInLayers(request);
  }
}
