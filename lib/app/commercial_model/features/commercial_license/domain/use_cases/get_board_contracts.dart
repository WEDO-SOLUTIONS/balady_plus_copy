import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/board_contract_response.dart';

class GetBoardContracts extends UseCase<BoardContractResponse, int> {
  final CrRepository repository;

  GetBoardContracts({required this.repository});
  @override
  Future<Either<Failure, BoardContractResponse>> call(int params) async {
    return await repository.getBoardContracts(params: params);
  }
}
