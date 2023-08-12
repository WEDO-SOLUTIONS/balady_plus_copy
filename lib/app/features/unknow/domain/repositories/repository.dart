import 'dart:async';
import 'dart:core';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../profile_features/incidents/domain/entities/download_file_params.dart';
import '../../../transaction_inquiry/presentation/core/models/download_file_result.dart';

abstract class InvestmentRepository {
  Future<Either<Failure, DownloadIMSFileResult?>> downloadFile(
      DownLoadFileParams params);
}
