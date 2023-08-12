import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../profile_features/incidents/domain/entities/download_file_params.dart';
import '../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../repositories/repository.dart';

class DownloadFile extends UseCase<DownloadIMSFileResult?, DownLoadFileParams> {
  final InvestmentRepository repository;

  DownloadFile({required this.repository});

  @override
  Future<Either<Failure, DownloadIMSFileResult?>> call(
      DownLoadFileParams params) async {
    return await repository.downloadFile(params);
  }
}
