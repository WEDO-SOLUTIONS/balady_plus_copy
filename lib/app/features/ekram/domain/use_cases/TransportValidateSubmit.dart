import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/ekram_repository.dart';

class TransportValidateSubmit extends UseCase<ResponseBodyModel, int> {
  final EkramRepository repository;
  TransportValidateSubmit({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel>> call(int requestId) async {
    return await repository.ekramTransportValidateSubmit(requestId);
  }
}