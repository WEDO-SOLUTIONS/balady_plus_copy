/*import 'package:balady_plus/shared/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/shared/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/shared/features/authorization/auth_exports.dart'
    show AuthRepository;
import 'package:balady_plus/shared/features/authorization/domain/entities/create_profile_params.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class CreateProfile
    extends UseCase<ApigeeResponse<String>, CraeteProfileParams> {
  final AuthRepository repository;

  CreateProfile({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<String>>> call(
      CraeteProfileParams params) async {
    return await repository.createProfile(params);
  }
}
*/
