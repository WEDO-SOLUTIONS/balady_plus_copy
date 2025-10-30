import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

import '../../../objections/domain/entities/objection_details.dart';
import '../../objections_exports.dart';

class GetObjectionDetails extends UseCase<ObjectionDetails, String> {
  final RequestsRepository repository;
  GetObjectionDetails({required this.repository});
  @override
  Future<Either<Failure, ObjectionDetails>> call(String params) async {
    return await repository.getObjectionDetails(params);
  }
}
