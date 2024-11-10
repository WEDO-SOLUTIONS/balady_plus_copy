import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/driver/deceased_identical_item.dart';
import '../../ekram_exports.dart';
import '../repositories/ekram_repository.dart';
import 'package:dartz/dartz.dart' show Either;

class GetIdenticalListRequest
    extends UseCase<ResponseBodyModel<List<DeceasedIdenticalItem>>, int> {
  final EkramRepository repository;

  GetIdenticalListRequest({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<DeceasedIdenticalItem>>>> call(
      int params) async {
    return await repository.getidenticalList(params);
  }
}
