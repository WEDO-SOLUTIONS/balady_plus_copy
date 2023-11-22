import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_requests/my_requests_bloc.dart';

class OrderDetailsPageParams {
  OrderDetailsResponse? response;
  MyRequestsBloc myOrdersBloc;
  OrderDetailsPageParams({required this.response, required this.myOrdersBloc});
}
