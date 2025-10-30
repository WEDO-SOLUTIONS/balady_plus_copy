import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_orders/my_orders_bloc.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_requests/my_requests_bloc.dart';

class RequestDetailsPageParams {
  RequestDetailsResponse? response;
  String? requestTypeName;
  MyRequestsBloc myOrdersBloc;
  RequestDetailsPageParams(
      {required this.response,
      required this.myOrdersBloc,
      this.requestTypeName});
}
