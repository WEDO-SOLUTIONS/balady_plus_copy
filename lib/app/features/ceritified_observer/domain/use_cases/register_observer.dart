import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/MunicipalityLookUp.dart';
import '../entity/city_entity.dart';
import '../entity/observer_status_entity.dart';
import '../entity/register_observer_request.dart';
import '../repository/repository.dart';

class RegisterObserver extends UseCase<bool, RegisterObserverRequest> {
  final CertifiedObserverRepository repository;

  RegisterObserver({required this.repository});

  @override
  Future<Either<Failure, bool>> call(
      RegisterObserverRequest parm) async {
    return await repository.registrationObserver(parm);
  }
}


