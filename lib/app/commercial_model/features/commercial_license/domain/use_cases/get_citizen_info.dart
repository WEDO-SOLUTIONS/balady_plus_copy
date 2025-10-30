import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/citizen_info_model.dart';
import '../entities/citizen_info_params.dart';

class GetCitizenInfo extends UseCase<CitizenInfoModel, CitizenInfoParams> {
  final CrRepository repository;

  GetCitizenInfo({required this.repository});
  @override
  Future<Either<Failure, CitizenInfoModel>> call(
      CitizenInfoParams params) async {
    return await repository.getCizenInfo(params: params);
  }
}
