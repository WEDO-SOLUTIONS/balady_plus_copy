import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart'
    show CrRepository, InvestmentContractRequest, InvestmentContractResponse, InvestmentContractResponseModel;

class GetInvestmentContracts
    extends UseCase<InvestmentContractResponseModel, InvestmentContractRequest> {
  final CrRepository repository;

  GetInvestmentContracts({required this.repository});
  @override
  Future<Either<Failure, InvestmentContractResponseModel>> call(
      InvestmentContractRequest params) async {
    return await repository.getInvestmentContracts(params);
  }
}
