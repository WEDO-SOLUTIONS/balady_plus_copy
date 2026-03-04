import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:dartz/dartz.dart';
import '../../data/model/profile_model/profile_model.dart';
import '../../domain/repository/volunteer_profile_repository.dart';

class GetProfile extends UseCase<ProfileModel, NoParams> {
  final VolunteerProfileRepository repository;

  GetProfile({required this.repository});

  @override
  Future<Either<Failure, ProfileModel>> call(NoParams params) async => await repository.getProfile();
}
