import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';

import '../../data/models/calculate_fees_response_model.dart';
import '../../data/models/initialApproval/fees_request.dart';

class CaluclateFeesInteractively
    extends UseCase<CalculateFeesResponseModel, FeesRequest> {
  final Repository repository;

  CaluclateFeesInteractively({required this.repository});
  @override
  Future<Either<Failure, CalculateFeesResponseModel>> call(
      FeesRequest params) async {
    return await repository.CalculateFeesInteractively(params: params);
  }
}
