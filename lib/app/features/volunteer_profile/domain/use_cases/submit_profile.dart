import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repository/volunteer_profile_repository.dart';

class SubmitProfile extends UseCase<void, SubmitProfileParams> {
  final VolunteerProfileRepository repository;

  SubmitProfile({required this.repository});

  @override
  Future<Either<Failure, void>> call(SubmitProfileParams params) async =>
      repository.submitProfile(params.profileData, params.profileId);
}

class SubmitProfileParams extends Equatable {
  final Map<String, dynamic> profileData;
  final String profileId;

  const SubmitProfileParams({
    required this.profileData,
    required this.profileId,
  });

  @override
  List<Object> get props => [profileData, profileId];
}
