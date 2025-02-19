import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';

import '../../data/models/calculate_fees_response_model.dart';
import '../../data/models/initialApproval/fees_request.dart';

class GetSPLNotification
    extends UseCase<String, List<String>> {
  final Repository repository;

  GetSPLNotification({required this.repository});
  @override
  Future<Either<Failure, String>> call(
      List<String> params) async {
    return await repository.getSPLNotification(requestId: params[0],mencipiltyId:  params[1]);
  }
}
