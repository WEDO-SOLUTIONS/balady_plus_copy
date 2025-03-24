import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/observer_status_entity.dart';
import '../repository/repository.dart';

class GetRegisteredObserverStatus extends UseCase<ObserverStatusEntity, String> {
  final CertifiedObserverRepository repository;

  GetRegisteredObserverStatus({required this.repository});
  @override
  Future<Either<Failure, ObserverStatusEntity>> call(
      String identityNumber) async {
    return await repository.getObserverStatus(identityNumber);
  }
}
