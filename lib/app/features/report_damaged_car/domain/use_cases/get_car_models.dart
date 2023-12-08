import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/car_model.dart';
import '../repositories/dc_repository.dart';

class GetCarModels extends UseCase<List<CarModel>, String> {
  final DCRepository repository;

  GetCarModels({required this.repository});
  @override
  Future<Either<Failure, List<CarModel>>> call(String params) async {
    return await repository.getCarModels(params: params);
  }
}
