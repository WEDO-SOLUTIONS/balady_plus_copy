import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/providers/domain/entities/provider_details_params.dart';
import 'package:balady_plus/etmam_app/features/providers/domain/entities/provider_details_response.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProvidersRepository;

import '../../../../core/errors/errors_exports.dart' show Failure;

class GetProviderDetails extends UseCase<
    ApigeeResponse<ProviderDetailsResponse>, ProviderDetailsParams> {
  final ProvidersRepository repository;

  GetProviderDetails({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<ProviderDetailsResponse>>> call(
      ProviderDetailsParams params) async {
    return await repository.getProviderDetails(params: params);
  }
}
