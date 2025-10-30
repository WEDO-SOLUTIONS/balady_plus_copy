import '../../../../core/utils/enums/enums.dart';
import '../../presentation/blocs/ekram_requests_bloc/ekram_requests_bloc.dart';

class EkramSuccessPageParams {
  String? msg;
  EkramType type;
  EkramRequestsBloc? ekramBloc;

  EkramSuccessPageParams({this.msg, required this.type, this.ekramBloc});
}
