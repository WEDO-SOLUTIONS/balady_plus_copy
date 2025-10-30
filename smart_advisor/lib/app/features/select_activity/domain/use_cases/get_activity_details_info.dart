import '../../data/models/activity_details_info.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetActivityDetailsInfo extends UseCase<ActivityDetailsInfo, int> {
  final ActivitesRepository repository;

  GetActivityDetailsInfo({required this.repository});

  @override
  Future<Either<Failure, ActivityDetailsInfo>> call(int params) async {
    return await repository.getActivityInfo(params);
  }
}
