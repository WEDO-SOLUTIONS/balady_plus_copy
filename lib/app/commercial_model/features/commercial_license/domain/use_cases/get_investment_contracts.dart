import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart'
    show InvestmentContractRequest, InvestmentContractResponse, CrRepository;

class GetInvestmentContracts
    extends UseCase<InvestmentContractResponse, InvestmentContractRequest> {
  final CrRepository repository;

  GetInvestmentContracts({required this.repository});
  @override
  Future<Either<Failure, InvestmentContractResponse>> call(
      InvestmentContractRequest params) async {
    return await repository.getInvestmentContracts(params);
  }
}
