import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../entities/addetional_activites_response.dart';

class GetAddetionalActivitesUc
    extends UseCase<List<AddetionalActivityItem>, String> {
  final ActivitesRepository repository;

  GetAddetionalActivitesUc({required this.repository});

  @override
  Future<Either<Failure, List<AddetionalActivityItem>>> call(
      String params) async {
    return await repository.getAddetionalActivites(params);
  }
}
