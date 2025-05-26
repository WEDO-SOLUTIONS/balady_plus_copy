import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/driver/EditAdditionalRequest.dart';
import '../../data/model/ekram_attachment_response.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class EditAdditionalData extends UseCase<ResponseBodyModel<dynamic>, EditAdditionalRequest> {
  final EkramRepository repository;
  EditAdditionalData({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<dynamic>>> call(EditAdditionalRequest params) async {
    return await repository.editAdditionalData(params);
  }
}
