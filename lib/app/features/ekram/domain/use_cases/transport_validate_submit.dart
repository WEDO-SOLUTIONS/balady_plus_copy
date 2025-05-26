import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/ekram_repository.dart';

class EkramTransportValidateSubmit extends UseCase<ResponseBodyModel, List<dynamic>> {
  final EkramRepository repository;
  EkramTransportValidateSubmit({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel>> call(List<dynamic> parms) async {
    return await repository.ekramTransportValidateSubmit(parms[0], parms[1]);
  }
}
