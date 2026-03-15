import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../data/model/volunteer_lookup.dart';
import '../../domain/repository/volunteer_profile_repository.dart';

class GetCities extends UseCase<List<VolunteerLookup>, String> {
  final VolunteerProfileRepository repository;

  GetCities({required this.repository});
  @override
  Future<Either<Failure, List<VolunteerLookup>>> call(String params) async =>
      repository.getCities(params);
}
