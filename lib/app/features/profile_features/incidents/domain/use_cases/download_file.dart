import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../entities/download_file_params.dart';
import '../repositories/repository.dart';

class DownloadFile extends UseCase<DownloadFileResult?, DownLoadFileParams> {
  final RequestsRepository repository;

  DownloadFile({required this.repository});

  @override
  Future<Either<Failure, DownloadFileResult?>> call(
      DownLoadFileParams params) async {
    return await repository.downloadFile(params);
  }
}
