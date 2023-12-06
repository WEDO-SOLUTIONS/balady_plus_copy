import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/upload_letter_params.dart';
import '../repositories/ekram_repository.dart';

class UploadLetter extends UseCase<ResponseBodyModel, UploadLetterParamas> {
  final EkramRepository repository;
  UploadLetter({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel>> call(
      UploadLetterParamas params) async {
    return await repository.uploadLetter(params);
  }
}
