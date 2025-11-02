import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:dartz/dartz.dart';
import '../../data/model/cv_upload_response.dart';
import '../../domain/repository/volunteer_profile_repository.dart';

class UploadCV extends UseCase<CVUploadResponse, FileDataItem> {
  final VolunteerProfileRepository repository;

  UploadCV({required this.repository});

  @override
  Future<Either<Failure, CVUploadResponse>> call(FileDataItem params) async =>
      repository.uploadCV(params);
}
