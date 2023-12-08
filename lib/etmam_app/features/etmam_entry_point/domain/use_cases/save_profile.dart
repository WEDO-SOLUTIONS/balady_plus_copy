import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show EtmamEntryPointRepository;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class SaveProfile extends UseCase<bool, Profile> {
  final EtmamEntryPointRepository repository;

  SaveProfile({required this.repository});
  @override
  Future<Either<Failure, bool>> call(Profile params) async {
    return await repository.saveProfile(params);
  }
}
