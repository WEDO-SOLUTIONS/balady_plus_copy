import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/driver/deceased_attachment.dart';
import '../../data/model/upload_letter_params.dart';
import '../repositories/ekram_repository.dart';

class UploadAttachment extends UseCase<ResponseBodyModel<DeceasedAttachment>, List<dynamic>> {
  final EkramRepository repository;
  UploadAttachment({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<DeceasedAttachment>>> call(
      List<dynamic> params) async {
    return await repository.uploadAttachment( params[0], params[1]);
  }
}
