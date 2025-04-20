import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';

import '../repository/repository.dart';

class GetFreelancerCertificateStatus
    extends UseCase<Map<String, dynamic>, NoParams> {
  final CertifiedObserverRepository repository;

  GetFreelancerCertificateStatus({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.getFreelancerCertificateStatus();
  }
}

class CreateNewFreelancerCertificate
    extends UseCase<Map<String, dynamic>, NoParams> {
  final CertifiedObserverRepository repository;

  CreateNewFreelancerCertificate({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.createNewFreelancerCertificate();
  }
}

class UpdateFreelancerCertificate
    extends UseCase<Map<String, dynamic>, String> {
  final CertifiedObserverRepository repository;

  UpdateFreelancerCertificate({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String params) async {
    return await repository.updateFreelancerCertificate(params);
  }
}
