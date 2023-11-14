import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/establishment_size_response.dart';
import '../repository/violation_repository.dart';

class GetEstablishmentSize
    extends UseCase<EstablishmentSizeResponse, NoParams> {
  final ViolationGuideRepository repository;
  GetEstablishmentSize({required this.repository});
  @override
  Future<Either<Failure, EstablishmentSizeResponse>> call(
      NoParams params) async {
    return await repository.getEstablishmentSize();
  }
}
