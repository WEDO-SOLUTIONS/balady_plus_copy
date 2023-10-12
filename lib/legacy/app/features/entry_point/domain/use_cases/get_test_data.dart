import 'package:balady_plus/app/features/entry_point/data/models/test_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

class GetTestData extends UseCase<TestModel, NoParams> {
  final EntryPointRepository repository;

  GetTestData({required this.repository});
  @override
  Future<Either<Failure, TestModel>> call(NoParams params) async {
    return await repository.getDataTest();
  }
}
