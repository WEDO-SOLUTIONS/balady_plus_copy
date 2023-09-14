import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, trans;
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/order_details/form_view_widget.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar, CustomLoadingWidget;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        ActionParams,
        OrderDetailsBloc,
        OrderDetailsPageParams,
        OrderDetailsState,
        OrderInfoSectionWidget,
        OtherInfoSectionWidget,
        ProviderSectionWidget,
        ServiceDetailsSectionWidget,
        ShowActionsEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/utils/enums/bloc_status.dart';
import '../../../submit_request/presentation/widgets/order_info/order_info_card_widget.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.OrderDetails);
  }

  @override
  Widget build(BuildContext context) {
    OrderDetailsPageParams args =
        ModalRoute.of(context)!.settings.arguments as OrderDetailsPageParams;

    return BlocProvider(
      create: (context) => OrderDetailsBloc(
          args: args,
          getServicesProvidersByService: sl(),
          getOrderDetails: sl(),
          getFormView: sl()),
      child: BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: trans('order_number')
                  .replaceAll("-", state.response?.number ?? ""),
              actionImg: (state.response?.actionsOnOrder != null &&
                      (state.response?.actionsOnOrder?.length ?? 0) > 0)
                  ? IconPath.moreDots
                  : "",
              actionOnPress: () {
                context.read<OrderDetailsBloc>().add(ShowActionsEvent(
                    params: ActionParams(
                        allowedActions: state.response?.actionsOnOrder,
                        orderId: state.response!.id!,
                        subServiceId: state.response!.serviceId!,
                        subServiceName: state.response!.serviceName ?? "")));
              },
            ),
            body: SingleChildScrollView(
                child: Stack(
              children: [
                Column(
                  children: [
                    OrderInfoSectionWidget(
                      orderStatusText: state.response?.status?.name ?? "",
                      orderStatus: CommonFunctions.getOrderStatus(
                          state.response?.status?.id),
                      orderDate: state.response?.getCreatedDate(),
                      orderService: state.response?.serviceName,
                      orderRefrenceNumber:
                          state.response?.platformReferenceNumber,
                    ),
                    ProviderSectionWidget(
                      providerServiceName: state.response?.providerName,
                      subServiceName: "",
                    ),
                    ServiceDetailsSectionWidget(),
                    WhiteCardWidget(
                      child: OtherInfoSectionWidget(
                        city: state.response?.cityName,
                        //  cancelPurpose: state.response?.pendingCancelRequest?.requestReason,
                      ),
                    ),
                    FormViewWidget(),
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
