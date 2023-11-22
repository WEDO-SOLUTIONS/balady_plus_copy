import 'package:balady_plus/etmam_app/core/services/local/use_case.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show MyOrdersRepository;
import '../../../../core/errors/errors_exports.dart' show Failure;

class GetRequestDetails extends UseCase<ApigeeResponse<RequestDetailsResponse>,
    OrderDetailsParams> {
  final MyOrdersRepository repository;

  GetRequestDetails({required this.repository});

  @override
  Future<Either<Failure, ApigeeResponse<RequestDetailsResponse>>> call(
      OrderDetailsParams params) async {
    return await repository.getRequestDetails(params: params);
  }
}
