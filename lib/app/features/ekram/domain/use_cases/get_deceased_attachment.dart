import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/driver/GhuslEmploye.dart';
import '../../data/model/driver/deceased_attachment.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

class GetDeceasedAttachment extends UseCase<ResponseBodyModel<List<DeceasedAttachment>>, int> {
  final EkramRepository repository;

  GetDeceasedAttachment({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<DeceasedAttachment>>>> call(
      int requestId) async {
    return await repository.getDeceasedAttachment(requestId);
  }
}
