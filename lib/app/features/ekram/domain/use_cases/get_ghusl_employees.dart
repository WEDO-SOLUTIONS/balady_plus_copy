import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/driver/GhuslEmploye.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class GetGhuslEmployees extends UseCase<ResponseBodyModel<List<GhuslEmploye>>, int> {
  final EkramRepository repository;

  GetGhuslEmployees({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<GhuslEmploye>>>> call(
      int requestId) async {
    return await repository.getGhuslEmployees(requestId);
  }
}
