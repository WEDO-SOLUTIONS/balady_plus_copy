import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_orders/my_orders_bloc.dart';

class OrderDetailsPageParams {
  OrderDetailsResponse? response;
  MyOrdersBloc myOrdersBloc;
  OrderDetailsPageParams({required this.response, required this.myOrdersBloc});
}
