import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../entities/objection_details.dart';

class GetObjectionDetails extends UseCase<ObjectionDetails, String> {
  final RequestsRepository repository;
  GetObjectionDetails({required this.repository});
  @override
  Future<Either<Failure, ObjectionDetails>> call(String params) async {
    return await repository.getObjectionDetails(params);
  }
}
