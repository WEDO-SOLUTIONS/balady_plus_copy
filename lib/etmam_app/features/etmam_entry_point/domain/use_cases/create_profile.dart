import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show EtmamEntryPointRepository;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/create_profile_params.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class CreateProfile
    extends UseCase<ApigeeResponse<String>, CraeteProfileParams> {
  final EtmamEntryPointRepository repository;

  CreateProfile({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<String>>> call(
      CraeteProfileParams params) async {
    return await repository.createProfile(params);
  }
}
