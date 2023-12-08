import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase, NoParams;
import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/etmam_entry_point_exports.dart'
    show EtmamEntryPointRepository;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/domain/entities/profile.dart';
import '../../../../core/errors/errors_exports.dart' show Failure;

class CheckProfile extends UseCase<Profile, NoParams> {
  final EtmamEntryPointRepository repository;

  CheckProfile({required this.repository});
  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await repository.checkProfile();
  }
}
