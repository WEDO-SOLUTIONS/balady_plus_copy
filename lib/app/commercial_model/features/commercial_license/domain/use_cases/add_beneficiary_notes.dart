import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class AddBeneficiaryNotes extends UseCase<int, CrAddNotesRequest> {
  final CrRepository repository;

  AddBeneficiaryNotes({required this.repository});
  @override
  Future<Either<Failure, int>> call(CrAddNotesRequest params) async {
    return await repository.addBeneficiaryNotes(params: params);
  }
}
