import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/edit_bidding_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_page_params.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/blocs/request_details/request_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/offer_page/action_bottom_widget.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/request_details/form_view_widget.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/request_details/replies_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../app/core/utils/constants/route_names.dart';
import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';

class RequestDetailsPage extends StatefulWidget {
  const RequestDetailsPage({super.key});

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    RequestDetailsPageParams args =
        ModalRoute.of(context)!.settings.arguments as RequestDetailsPageParams;

    return BlocProvider(
      create: (context) => RequestDetailsBloc(
          args: args,
          getOrderDetails: sl(),
          getFormView: sl(),
          submitOrder: sl(),
          cancelRequest: sl()),
      child: BlocConsumer<RequestDetailsBloc, RequestDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: trans('order_number')
                  .replaceAll("-", state.response?.requestNumber ?? ""),
            ),
            /* appBar: DefaultAppBarWidget(
              title: "طلب ${state.response?.requestNumber}#",
              actions: [
                if ((state.response?.actionsOnOrder != null &&
                    (state.response?.actionsOnOrder?.length ?? 0) > 0))
                  GestureDetector(
                    onTap: () {
                      context.read<OrderDetailsBloc>().add(ShowActionsEvent(
                          params: ActionParams(
                              allowedActions: state.response?.actionsOnOrder,
                              orderId: state.response!.id!,
                              subServiceId: state.response!.serviceId!,
                              subServiceName:
                                  state.response!.serviceName ?? "")));
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16),
                      child: Image.asset(
                        IconPath.settings,
                        width: 42,
                        height: 42,
                      ),
                    ),
                  )
              ],
            ),*/
            body: SingleChildScrollView(
                child: Stack(
              children: [
                Column(
                  children: [
                    OrderInfoSectionWidget(
                      orderStatusText:
                          state.response?.calculatedStatus?.name ?? "",
                      orderStatus: CommonFunctions.getOrderStatus(
                          state.response?.requestStatusId),
                      orderDate: state.response?.getCreatedDate(),
                      orderService: state.response?.subServiceName,
                      requestType: args.requestTypeName,
                      //   orderRefrenceNumber:
                      //     state.response?.platformReferenceNumber,
                    ),
                    RepliesWidget(),
                    FormViewWidget(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ActionBottomWidget(
                        onDelete: () {
                          context
                              .read<RequestDetailsBloc>()
                              .add(CancelRequestEvent());
                        },
                        onEdit: () {
                          NavigationService.navigatorKey.currentState
                              ?.pushNamed(EtmamRoutesNames.editBiddingForm,
                                  arguments: EditBiddingPageParams(
                                      formId: state.response?.formId,
                                      requestId: state.response?.requestId));
                        },
                        onSend: () {
                          context
                              .read<RequestDetailsBloc>()
                              .add(SubmitOrderEvent());
                        },
                        deleteText: state.response?.deleteAction()?.name,
                        sendText: state.response?.delegateAction()?.name,
                        editText: state.response?.editAction()?.name,
                        showSend: state.response?.delegateAction() != null,
                        showEdit: state.response?.editAction() != null,
                        showDelete: state.response?.deleteAction() != null,
                      ),
                    )
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  const CustomLoadingWidget(),
              ],
            )),
          );
        },
      ),
    );
  }
}
