import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class GetAccommodationTypes extends UseCase<List<LookupsModel>, NoParams> {
  final Repository repository;

  GetAccommodationTypes({required this.repository});
  @override
  Future<Either<Failure, List<LookupsModel>>> call(NoParams params) async {
    return await repository.getAccommodationTypes();
  }
}
