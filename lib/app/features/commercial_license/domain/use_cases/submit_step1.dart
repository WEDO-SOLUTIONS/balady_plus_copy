import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/save_com_submitter_and_owner_request_model.dart';

class SaveComSubmitterAndOwner
    extends UseCase<int, SaveComSubmitterAndOwnerRequestModel> {
  final CrRepository repository;

  SaveComSubmitterAndOwner({required this.repository});
  @override
  Future<Either<Failure, int>> call(
      SaveComSubmitterAndOwnerRequestModel params) async {
    return await repository.saveComSubmitterAndOwner(params);
  }
}
