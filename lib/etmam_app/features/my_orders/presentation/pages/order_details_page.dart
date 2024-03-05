import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, trans;
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AppColor, BlocStatus;

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
        ProviderCardWidget,
        ProviderSectionWidget,
        ServiceDetailsSectionWidget,
        ShowActionsEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../app/features/_shared_feature_/shared_feature_exports.dart';
import '../../../../../app/features/objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import '../../../submit_request/presentation/widgets/order_info/order_info_card_widget.dart';
import '../../../submit_request/presentation/widgets/order_info/order_title_and_desc_widget.dart';
import '../widgets/order_details/form_view_widget.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.OrderDetails);
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
        getFormView: sl(),
      ),
      child: BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: "${"request".tr()} ${state.response?.number}#",
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
            ),
            // appBar: CustomAppBar(
            //   title: trans('order_number')
            //       .replaceAll("-", state.response?.number ?? ""),
            // actionImg: (state.response?.actionsOnOrder != null &&
            //         (state.response?.actionsOnOrder?.length ?? 0) > 0)
            //     ? IconPath.moreDots
            //     : "",
            //   actionOnPress: () {
            //     context.read<OrderDetailsBloc>().add(ShowActionsEvent(
            //         params: ActionParams(
            //             allowedActions: state.response?.actionsOnOrder,
            //             orderId: state.response!.id!,
            //             subServiceId: state.response!.serviceId!,
            //             subServiceName: state.response!.serviceName ?? "")));
            //   },
            // ),
            body: SingleChildScrollView(
                child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CustomSvgIconWidget(
                                  IconPath.calendar,
                                  iconSize: 24,
                                  iconColor: AppColor.primary600Light,
                                ),
                                const SizedBox(width: 6),
                                CustomTextWidget(
                                  state.response?.getCreatedDate() ?? '',
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.bold,
                                  fontColor: AppColor.blackModern500Light,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                color: AppColor.white,
                              ),
                              child: Row(
                                children: [
                                  CustomTextWidget(
                                    state.response?.status?.name ?? "",
                                    fontSize: 11,
                                    fontWeight: AppFontWeight.bold,
                                    fontColor: AppColor.primary900Light,
                                  ),
                                  // SizedBox(width: 8),
                                  // Icon(
                                  //   Icons.arrow_drop_down_sharp,
                                  //   size: 16,
                                  //   color: AppColor.primary900Light,
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomExpansionPanelWidget(
                        leading: const CustomSvgIconWidget(
                          IconPath.edit,
                          iconColor: AppColor.primary600Light,
                          iconSize: 20,
                        ),
                        title: trans("request_data"),
                        children: [
                          FieldData(
                            title: "order_services".tr(),
                            subTitle: state.response?.serviceName,
                          ),
                          if (state.response?.platformReferenceNumber != null)
                            FieldData(
                              title: trans('order_refrence_number'),
                              subTitle: state.response?.platformReferenceNumber,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomExpansionPanelWidget(
                        leading: const CustomSvgIconWidget(
                          IconPath.edit,
                          iconColor: AppColor.primary600Light,
                          iconSize: 20,
                        ),
                        title: trans("order_info_provider_office"),
                        children: [
                          FieldData(
                            title: "order_info_office_name".tr(),
                            subTitle: state.response?.providerName,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomExpansionPanelWidget(
                        leading: const CustomSvgIconWidget(
                          IconPath.edit,
                          iconColor: AppColor.primary600Light,
                          iconSize: 20,
                        ),
                        title: "addetional_services".tr(),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.response?.subOrders?.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) => Column(
                              children: [
                                OrderTitleAndDescWidget(
                                  spaceBetweenTitleAndDesc: 0,
                                  title: "",
                                  descWidget: ProviderCardWidget(
                                    providerName: state.response
                                            ?.subOrders?[index].providerName ??
                                        "",
                                    showMoreAction: (state
                                                .response
                                                ?.subOrders?[index]
                                                .actionsOnOrder !=
                                            null &&
                                        (state.response?.subOrders?[index]
                                                    .actionsOnOrder?.length ??
                                                0) >
                                            0),
                                    onMoreAction: () {
                                      context.read<OrderDetailsBloc>().add(
                                          ShowActionsEvent(
                                              params: ActionParams(
                                                  allowedActions:
                                                      state
                                                          .response
                                                          ?.subOrders?[index]
                                                          .actionsOnOrder,
                                                  orderId: state.response!
                                                      .subOrders![index].id!,
                                                  subServiceId: state
                                                      .response!
                                                      .subOrders![index]
                                                      .serviceId!,
                                                  subServiceName: state
                                                          .response!
                                                          .subOrders?[index]
                                                          .serviceName ??
                                                      "")));
                                    },
                                    providerLogoUrl: state
                                            .response
                                            ?.subOrders?[index]
                                            .providerLogoUrl ??
                                        "",
                                    statusText: state.response
                                        ?.subOrders?[index].status?.name,
                                    orderStatus: CommonFunctions.getOrderStatus(
                                        state.response?.subOrders?[index].status
                                            ?.id),
                                  ),
                                ),
                                const CustomVerticalSpace(height: 16)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomExpansionPanelWidget(
                        leading: const CustomSvgIconWidget(
                          IconPath.edit,
                          iconColor: AppColor.primary600Light,
                          iconSize: 20,
                        ),
                        title: "other_details".tr(),
                        children: [
                          FieldData(
                            title: "city".tr(),
                            subTitle: state.response?.cityName,
                          ),
                        ],
                      ),
                      FormViewWidget(),
                    ],
                  ),
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
