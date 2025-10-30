import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/active_location_params.dart';
import '../repositories/dc_repository.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';

class CheckActiveLocation extends UseCase<bool, ActiveLocationParams> {
  final DCRepository repository;

  CheckActiveLocation({required this.repository});
  @override
  Future<Either<Failure, bool>> call(ActiveLocationParams params) async {
    return await repository.checkActiveLocation(params: params);
  }
}
