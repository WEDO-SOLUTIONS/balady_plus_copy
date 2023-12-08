import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/request_details/request_details_bloc.dart';

class RequestOffersPageParams {
  RequestDetailsResponse requestDetails;
  RequestDetailsBloc requestDetailsBloc;

  RequestOffersPageParams(
      {required this.requestDetails, required this.requestDetailsBloc});
}
