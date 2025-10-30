import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/group_item_response_model.dart';
import '../repositores/repository.dart';

class GetGroupItems extends UseCase<GroupItemResponseModel, NoParams> {
  final PostersRepository repository;
  GetGroupItems({required this.repository});
  @override
  Future<Either<Failure, GroupItemResponseModel>> call(NoParams params) async {
    return await repository.getGroupItems();
  }
}
