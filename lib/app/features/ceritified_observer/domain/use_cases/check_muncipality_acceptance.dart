import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/MunicipalityLookUp.dart';
import '../entity/observer_status_entity.dart';
import '../repository/repository.dart';

class CheckMuncipalityAcceptance extends UseCase<ResponseBodyModel<bool>, String?> {
  final CertifiedObserverRepository repository;

  CheckMuncipalityAcceptance({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<bool>>> call(String? parm) async {
    return await repository.checkMuncipalityAcceptance(parm!);
  }
}
