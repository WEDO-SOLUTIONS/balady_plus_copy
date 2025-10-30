import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/car_type.dart';
import '../repositories/dc_repository.dart';

class GetCarTypes extends UseCase<List<CarType>, NoParams> {
  final DCRepository repository;

  GetCarTypes({required this.repository});
  @override
  Future<Either<Failure, List<CarType>>> call(NoParams params) async {
    return await repository.getCarTypes();
  }
}
