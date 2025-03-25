import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

import '../repository/repository.dart';

class GetFreelancerCertificateStatus extends UseCase<Map<String,dynamic>, String> {
  final CertifiedObserverRepository repository;

  GetFreelancerCertificateStatus({required this.repository});

  @override
  Future<Either<Failure, Map<String,dynamic>>> call(
      String params) async {
    return await repository.getFreelancerCertificateStatus(params);
  }
}


