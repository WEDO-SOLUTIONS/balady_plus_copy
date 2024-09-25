import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permit_submit_response_model.dart';
import '../repositores/repository.dart';

class AddIndividualRequests extends UseCase<bool, int> {
  final PostersRepository repository;
  AddIndividualRequests({required this.repository});
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.addIndivisualRequests(params: params);
  }
}
