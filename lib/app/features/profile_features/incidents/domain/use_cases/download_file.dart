import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart'
    show NoParams, UseCase;
import '../../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../repositories/repository.dart';

class DownloadFile extends UseCase<DownloadFileResult?, String> {
  final RequestsRepository repository;

  DownloadFile({required this.repository});

  @override
  Future<Either<Failure, DownloadFileResult?>> call(String params) async {
    return await repository.downloadFile(params);
  }
}
