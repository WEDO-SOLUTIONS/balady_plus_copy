/*import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../services_exports.dart' show ServiceEntity, ServicesRepository;

class NewServices extends UseCase<List<ServiceEntity>, NoParams> {
  final ServicesRepository repository;

  NewServices(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(NoParams params) async {
    return await repository.getNewServices();
  }
}
*/
