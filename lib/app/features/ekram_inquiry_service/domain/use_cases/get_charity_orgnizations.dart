import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/orgnization_charity_list.dart';
import '../repositories/ekram_repository.dart';

class GetCharityOrgnizations
    extends UseCase<EkramCharityOrgnizationResponse, int> {
  final EkramServicesRepository repository;

  GetCharityOrgnizations({required this.repository});

  @override
  Future<Either<Failure, EkramCharityOrgnizationResponse>> call(
      int params) async {
    return await repository.getCharityOrgnizations(params: params);
  }
}
