/*import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
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
*/
