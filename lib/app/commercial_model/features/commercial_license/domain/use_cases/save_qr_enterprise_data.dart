import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/qr/apply_commercial_response_model.dart';
import '../../data/models/qr/save_enterprise_data_request.dart';

class SaveQrEnterpriseData extends UseCase<int, SaveEnterprisDataRequest> {
  final CrRepository repository;

  SaveQrEnterpriseData({required this.repository});
  @override
  Future<Either<Failure, int>> call(SaveEnterprisDataRequest params) async {
    return await repository.saveQrEnterpriseData(params: params);
  }
}
