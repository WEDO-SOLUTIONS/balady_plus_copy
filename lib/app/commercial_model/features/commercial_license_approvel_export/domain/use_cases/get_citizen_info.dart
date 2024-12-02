import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/citizen_info.dart';
import '../entities/citizen_info_params.dart';

class GetCitizenInfo extends UseCase<CitizenInfo, CitizenInfoParams> {
  final Repository repository;

  GetCitizenInfo({required this.repository});
  @override
  Future<Either<Failure, CitizenInfo>> call(
      CitizenInfoParams params) async {
    return await repository.getCizenInfo(params: params);
  }
}
