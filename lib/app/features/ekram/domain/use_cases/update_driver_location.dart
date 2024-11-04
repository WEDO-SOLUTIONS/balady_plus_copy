import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/update_driver_location_params.dart';
import '../repositories/ekram_repository.dart';

class UpadateDriverLocation extends UseCase<ResponseBodyModel, UpdateDriverLocationParams> {
  final EkramRepository repository;
  UpadateDriverLocation({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel>> call(
      UpdateDriverLocationParams params) async {
    return await repository.upadateDriverLocation(params);
  }
}
