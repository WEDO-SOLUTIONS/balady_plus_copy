import 'package:balady_plus/app/core/errors/errors_exports.dart';

import 'package:dartz/dartz.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../../domain/entity/construction_license_inquery_data_entity.dart';
import '../../domain/repository/repository.dart';
import '../data_source/remote_data_source.dart';

class ConstructionLicenseInqueryRepositoryImplementation
    implements ConstructionLicenseInqueryRepository {
  final ConstructionLicenseInqueryRemoteDataSource remoteDataSource;

  ConstructionLicenseInqueryRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ResponseBodyModel<ConstructionLicenseData>>>
      getLicenseData(int licenseNumber, String date) async {
    try {
      final data = await remoteDataSource.getLicenseData(licenseNumber, date);
      return Right(data);
    } on NoDataFoundException {
      return Left(NoDataFoundFailure());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.errorMessage));
    }
  }
}
