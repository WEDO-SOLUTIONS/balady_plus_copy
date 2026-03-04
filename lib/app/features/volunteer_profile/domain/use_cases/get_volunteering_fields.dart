import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:dartz/dartz.dart';
import '../../data/model/volunteer_lookup.dart';
import '../../domain/repository/volunteer_profile_repository.dart';

class GetVolunteeringFields extends UseCase<List<VolunteerLookup>, NoParams> {
  final VolunteerProfileRepository repository;

  GetVolunteeringFields({required this.repository});
  @override
  Future<Either<Failure, List<VolunteerLookup>>> call(NoParams params) async => repository.getVolunteeringFields();
}
