import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/citizen_info_model.dart';
import '../entities/citizen_info_params.dart';

class GetCommercailEndorsements extends UseCase<List<dynamic>, int> {
  final CrRepository repository;

  GetCommercailEndorsements({required this.repository});
  @override
  Future<Either<Failure, List<dynamic>>> call(
      int requestId) async {
    return await repository.getCommercialEndorsements(requestID: requestId);
  }
}
