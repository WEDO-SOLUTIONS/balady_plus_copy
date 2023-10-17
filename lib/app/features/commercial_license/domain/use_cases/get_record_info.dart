import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';

class GetRecordInfo
    extends UseCase<ResponseBodyModel<RecordInfo>, (String, String)> {
  final CrRepository repository;

  GetRecordInfo({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<RecordInfo>>> call(
      (String, String) params) async {
    return await repository.getRecordInfo(crNumber: params.$1, role: params.$2);
  }
}
