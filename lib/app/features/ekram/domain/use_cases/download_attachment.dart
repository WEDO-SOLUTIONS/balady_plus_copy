import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/ekram_attachment_response.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class DownloadAttachment extends UseCase<EkramAttachmentResponse, int> {
  final EkramRepository repository;
  DownloadAttachment({required this.repository});
  @override
  Future<Either<Failure, EkramAttachmentResponse>> call(int params) async {
    return await repository.downLoadAttachment(params);
  }
}
