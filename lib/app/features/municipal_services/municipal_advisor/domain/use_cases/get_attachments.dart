import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../municipal_advisor_exports.dart'
    show AttachmentEntity, AttachmentParamsModel, MunicipalAdvisorRepository;

class GetConsultationAttachments
    extends UseCase<List<AttachmentEntity>, AttachmentParamsModel> {
  final MunicipalAdvisorRepository repository;

  GetConsultationAttachments(this.repository);

  @override
  Future<Either<Failure, List<AttachmentEntity>>> call(
      AttachmentParamsModel params) async {
    return await repository.getConsultationAttachments(params);
  }
}
