import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_response.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show HomeRepository;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetAds extends UseCase<ApigeeResponse<AdsResponse>, NoParams> {
  final HomeRepository repository;

  GetAds({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<AdsResponse>>> call(
      NoParams params) async {
    return await repository.getAds();
  }
}
