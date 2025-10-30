import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:flutter/material.dart' hide Action;

import '../../../../../app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../core/utils/enums/order_status.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppStyle, IconPath, trans;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomGoToDetailsButtonWidget,
        CustomHorizontalSpace,
        CustomNewIconButtonWidget,
        CustomVerticalSpace,
        DetailsInfoWithImg,
        DrawLineWidget,
        HeaderWithDescription,
        showDialogWidget;

class OrderCardWidget extends StatelessWidget {
  String? date;
  String? orderNo;
  String? orderType;
  String? orderServices;
  String orderId;
  OrderStatus? orderStatus;
  final String? statusText;
  final List<Action>? actions;

  //final Function? refresh;
  final Function? onSelectMore;
  final Function? onPress;
  final Tag? tag;

  OrderCardWidget(
      {Key? key,
      required this.orderId,
      this.date,
      this.orderNo,
      this.orderServices,
      this.orderType,
      this.actions,
      this.tag,
      this.statusText,
      this.orderStatus,
      // this.refresh,
      this.onPress,
      this.onSelectMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 342,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                  color: AppColor.greyShadow.withOpacity(0.08),
                  offset: const Offset(-2, 4),
                  blurRadius: 8,
                  spreadRadius: 0)
            ]),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsetsDirectional.only(top: 9, start: 16, end: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      (actions != null && (actions?.length ?? 0) > 0)
                          ? MoreIconWidget(
                              actions: actions,
                              orderId: orderId,
                              //   refresh: refresh,
                              onPress: onSelectMore)
                          : const SizedBox(
                              height: 20,
                            )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: HeaderWithDescription(
                          details: orderNo ?? "",
                          header: trans("request_no"),
                        ),
                      ),
                      const CustomHorizontalSpace(width: 2),
                      Expanded(
                        child: HeaderWithDescription(
                          details: ((statusText ?? "")),
                          header: trans("request_status"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: HeaderWithDescription(
                          details: (orderType ?? ""),
                          header: trans('etmam_order_type'),
                        ),
                      ),
                      const CustomHorizontalSpace(width: 2),
                      Expanded(
                        child: HeaderWithDescription(
                          details: orderServices ?? "",
                          header: trans('order_services'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: HeaderWithDescription(
                          details: date ?? "",
                          header: trans("order_date"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (tag != null && tag?.value != null)
                    TagWidget(
                      text: tag!.value!,
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomElevatedButtonWidget(
                btnColor: AppColor.primary900,
                textStyle: AppStyle.mainTextStyle.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                btnHeight: 40,
                text: trans('order_details'),
                onPressed: () {
                  if (onPress != null) onPress!();
                  /*NavigationService.pushNamed(
                          routeName: RouteName.etmam_orderDetailsRoute);*/
                },
              ),
            ),
            // CustomGoToDetailsButtonWidget(
            //   onPressed: () {
            //     if (onPress != null) onPress!();
            //     /*NavigationService.pushNamed(
            //         routeName: RouteName.etmam_orderDetailsRoute);*/
            //   },
            //   label: trans('order_details'),
            // )
          ],
        ));
  }
}

class MoreIconWidget extends StatelessWidget {
  final List<Action>? actions;
  final String orderId;

  // final Function? refresh;
  final Function? onPress;

  const MoreIconWidget(
      {Key? key,
      this.actions,
      required this.orderId,
      //  this.refresh,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomNewIconButtonWidget(
      btnPressed: () {
        if (actions != null && actions!.isNotEmpty) {
          showDialogWidget(context,
              headerText: trans('order_more_dialog_header'),
              dialogBody: MoreDialog(
                actions: actions!,
                orderId: orderId,
                //   refresh: refresh,
                onSelect: onPress,
              ));
        }
      },
      iconSvg: IconPath.moreDots,
      iconSize: 24,
      //  iconColor: AppColorsTheme.primary700,
    );
  }
}
