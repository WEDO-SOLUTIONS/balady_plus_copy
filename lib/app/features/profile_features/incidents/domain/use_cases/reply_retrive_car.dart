import 'package:dartz/dartz.dart' show Either;

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/use_case.dart';
import '../entities/reply_retrive_car_params.dart';
import '../entities/reply_retrive_car_response.dart';
import '../repositories/repository.dart';

class ReplyReriveCar
    extends UseCase<ReplyRetriveCarResponse, ReplyRetriveCarParams> {
  final RequestsRepository repository;

  ReplyReriveCar({required this.repository});
  @override
  Future<Either<Failure, ReplyRetriveCarResponse>> call(
      ReplyRetriveCarParams params) async {
    return await repository.replyRetriveCar(params: params);
  }
}
