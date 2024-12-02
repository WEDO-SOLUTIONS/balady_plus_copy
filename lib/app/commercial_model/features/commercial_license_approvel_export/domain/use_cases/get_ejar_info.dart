import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart'
    show Repository, EjarInfoRequest, EjarInfoResponse, EjarInfoResponseModel;

class GetEjarInfo extends UseCase<EjarInfoResponseModel, EjarInfoRequest> {
  final Repository repository;

  GetEjarInfo({required this.repository});
  @override
  Future<Either<Failure, EjarInfoResponseModel>> call(EjarInfoRequest params) async {
    return await repository.getEjarInfo(params);
  }
}
