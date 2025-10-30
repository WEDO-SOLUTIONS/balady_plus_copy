import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../repositories/ekram_repository.dart';

class GetEkramDistricts extends UseCase<List<LookUpItem>, int> {
  final EkramServicesRepository repository;

  GetEkramDistricts({required this.repository});

  @override
  Future<Either<Failure, List<LookUpItem>>> call(int params) async {
    return await repository.getDistrcits(params: params);
  }
}
