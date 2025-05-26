import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/driver/trip_details_model.dart';
import '../repositories/ekram_repository.dart';

class EditTrip extends UseCase<ResponseBodyModel,List<dynamic>> {
  final EkramRepository repository;
  EditTrip({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel>> call(List<dynamic> parms) async {
    return await repository.editTrip(parms[0],parms[1]);
  }
}
