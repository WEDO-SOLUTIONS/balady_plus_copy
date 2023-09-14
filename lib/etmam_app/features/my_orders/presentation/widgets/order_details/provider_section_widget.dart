import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        CommonFunctions,
        OrderStatus,
        PrimaryIcons,
        trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomTextWidget,
        CustomVerticalSpace,
        DrawLineWidget,
        SectionTitleWidget;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        ActionParams,
        OrderDetailsBloc,
        OrderDetailsState,
        ProviderCardWidget,
        ShowActionsEvent,
        StatusTextWidget;
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart'
    show
        EtmamCustomReadOnlyTextWidget,
        OrderTitleAndDescWidget,
        OrderTitleGreyAndDescWidget,
        WhiteCardWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderInfoSectionWidget extends StatelessWidget {
  final String? orderDate;
  final String? orderService;
  final OrderStatus orderStatus;
  final String orderStatusText;
  final String? orderRefrenceNumber;
  final String? requestType;

  const OrderInfoSectionWidget(
      {Key? key,
      this.orderDate,
      this.orderService,
      required this.orderStatus,
      required this.orderStatusText,
      this.orderRefrenceNumber,
      this.requestType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: new BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
              color: Color(0x26000000),
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: CustomTextWidget(
                trans('etmam_order_status'),
                fontColor: AppColor.black,
                fontWeight: AppFontWeight.bold,
                fontSize: 17,
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
            ),
            Flexible(
              flex: 2,
              child: StatusTextWidget(
                orderStatus: orderStatus,
                text: orderStatusText,
                maxLines: 1,
              ),
            )
          ]),
          DrawLineWidget(
            lineColor: Color(0xff979797).withOpacity(0.2000000029802322),
            verticalMargin: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OrderTitleGreyAndDescWidget(
                title: trans('etmam_order_date'),
                desc: orderDate ?? "",
              ),
              if (requestType != null && requestType!.isNotEmpty)
                OrderTitleGreyAndDescWidget(
                  title: trans('etmam_order_type'),
                  desc: requestType ?? "",
                ),
            ],
          ),
          const CustomVerticalSpace(height: 14),
          OrderTitleGreyAndDescWidget(
            title: trans('order_services'),
            desc: orderService ?? "",
          ),
          if (orderRefrenceNumber != null) ...[
            const CustomVerticalSpace(height: 16),
            OrderTitleGreyAndDescWidget(
              title: trans('order_refrence_number'),
              desc: orderRefrenceNumber,
            )
          ],
        ],
      ),
    );
  }
}

class ProviderSectionWidget extends StatelessWidget {
  final String? providerServiceName;
  final String? subServiceName;

  const ProviderSectionWidget(
      {Key? key, this.providerServiceName, this.subServiceName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteCardWidget(
      child: Column(
        children: [
          SectionTitleWidget(
            title: trans('order_info_provider_office'),
            primaryIcon: PrimaryIcons.providerOfficeIcon,
          ),
          EtmamCustomReadOnlyTextWidget(
              label: trans('order_info_office_name'),
              text: providerServiceName ?? ""),
          // const CustomVerticalSpace(height: 16),
          // OrderTitleAndDescWidget(
          //   title: trans('order_info_service'),
          //   desc: subServiceName ?? "",
          // )
        ],
      ),
    );
  }
}

class ServiceDetailsSectionWidget extends StatelessWidget {
  const ServiceDetailsSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        return state.response?.subOrders != null &&
                state.response!.subOrders!.isNotEmpty
            ? WhiteCardWidget(
                child: Column(
                  children: [
                    SectionTitleWidget(
                      title: trans('order_extra_services'),
                      primaryIcon: PrimaryIcons.extraServicesIcon,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.response?.subOrders?.length ?? 0,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) => Column(
                        children: [
                          OrderTitleAndDescWidget(
                            spaceBetweenTitleAndDesc: 8,
                            title:
                                state.response?.subOrders?[index].serviceName ??
                                    "",
                            descWidget: ProviderCardWidget(
                              providerName: state.response?.subOrders?[index]
                                      .providerName ??
                                  "",
                              showMoreAction: (state.response?.subOrders?[index]
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
                                            allowedActions: state
                                                .response
                                                ?.subOrders?[index]
                                                .actionsOnOrder,
                                            orderId: state.response!
                                                .subOrders![index].id!,
                                            subServiceId: state.response!
                                                .subOrders![index].serviceId!,
                                            subServiceName: state
                                                    .response!
                                                    .subOrders?[index]
                                                    .serviceName ??
                                                "")));
                              },
                              providerLogoUrl: state.response?.subOrders?[index]
                                      .providerLogoUrl ??
                                  "",
                              statusText: state
                                  .response?.subOrders?[index].status?.name,
                              orderStatus: CommonFunctions.getOrderStatus(
                                  state.response?.subOrders?[index].status?.id),
                            ),
                          ),
                          CustomVerticalSpace(height: 16)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
