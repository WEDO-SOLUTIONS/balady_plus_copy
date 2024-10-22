import '../../../../core/utils/enums/enums.dart';
import '../../presentation/blocs/driver_request_bloc/transport_requests_bloc.dart';

class EkramSuccessPageParams {
  String? msg;
  EkramType type;
  TransportRequestsBloc? ekramBloc;

  EkramSuccessPageParams({this.msg, required this.type, this.ekramBloc});
}
