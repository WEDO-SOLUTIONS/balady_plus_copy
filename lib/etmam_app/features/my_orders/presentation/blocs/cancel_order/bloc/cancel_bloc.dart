import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart'
    show ServerFailure;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show IconPath;

import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/success_screen_args.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show CancelOrder, CancelOrderParams, CancelOrderResponse;
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/my_orders/my_orders_bloc.dart';

import '../../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../../../app/core/utils/enums/bloc_status.dart';

part 'cancel_event.dart';
part 'cancel_state.dart';

class CancelBloc extends Bloc<CancelEvent, CancelState> {
  final CancelOrder _cancelOrder;
  final Function? refresh;
  CancelBloc(
      {required CancelOrder cancelOrder,
      MyOrdersBloc? myOrdersBloc,
      this.refresh})
      : _cancelOrder = cancelOrder,
        super(CancelState()) {
    on<CancelEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CencelOrderEvent>(_cancelOrderHandler);
  }

  Future<void> _cancelOrderHandler(CencelOrderEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _cancelOrder(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        response: success.data?.result,
        errorMessage: "",
      ));

      if (refresh != null) {
        refresh!();
      }
      NavigationService.navigatorKey.currentState?.pushReplacementNamed(
          EtmamRoutesNames.successRoute,
          arguments: SuccessScreenArgs(
              idNumber: "",
              thanksMessage: success.data?.result?.successMessage,
              type: PageTypes.cancelOrder,
              icon: IconPath.successCancelIcon,
              iconHeight: 241,
              iconWidth: 176));
    });
  }
}
