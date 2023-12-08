import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/attachment_resposne_model.dart';
import '../entities/permit_required_types_params.dart';
import '../repositores/repository.dart';

class GetAttachmentTypes
    extends UseCase<AttachmentResponseModel, PermitRequiredTypesParams> {
  final PostersRepository repository;
  GetAttachmentTypes({required this.repository});
  @override
  Future<Either<Failure, AttachmentResponseModel>> call(
      PermitRequiredTypesParams params) async {
    return await repository.getAttachmentTypes(params: params);
  }
}
