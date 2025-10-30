import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart' show CrRepository;
import '../entities/save_shop_details_request.dart';

class SaveShopDetails extends UseCase<dynamic, SaveShopDetailsRequest> {
  final CrRepository repository;

  SaveShopDetails({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(SaveShopDetailsRequest params) async {
    return await repository.saveShopDetails(params: params);
  }
}
