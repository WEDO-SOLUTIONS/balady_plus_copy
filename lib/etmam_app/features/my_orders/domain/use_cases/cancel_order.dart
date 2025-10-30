import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show UseCase;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/apigee_response.dart';

import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/cancel_order_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/cancel_order_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show MyOrdersRepository;
import '../../../../core/errors/errors_exports.dart' show Failure;

class CancelOrder
    extends UseCase<ApigeeResponse<CancelOrderResponse>, CancelOrderParams> {
  final MyOrdersRepository repository;

  CancelOrder({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<CancelOrderResponse>>> call(
      CancelOrderParams params) async {
    return await repository.cancelOrder(params: params);
  }
}
