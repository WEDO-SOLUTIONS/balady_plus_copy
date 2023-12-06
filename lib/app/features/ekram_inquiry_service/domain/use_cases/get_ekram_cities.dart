import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../repositories/ekram_repository.dart';

class GetEkramCities extends UseCase<List<LookUpItem>, NoParams> {
  final EkramServicesRepository repository;

  GetEkramCities({required this.repository});

  @override
  Future<Either<Failure, List<LookUpItem>>> call(NoParams params) async {
    return await repository.getCities();
  }
}
