import 'package:balady_plus/etmam_app/core/utils/enums/order_status.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show StatusTextWidget;
import 'package:flutter/material.dart';

class ProviderCardWidget extends StatelessWidget {
  const ProviderCardWidget(
      {Key? key,
      this.providerName,
      this.providerLogoUrl,
      this.onMoreAction,
      this.showMoreAction = true,
      this.statusText,
      required this.orderStatus})
      : super(key: key);
  final String? providerLogoUrl;
  final String? providerName;
  final Function? onMoreAction;
  final bool showMoreAction;
  final String? statusText;
  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 1,
            color: Color(0xffe4e4e4),
          )),
      padding:
          EdgeInsetsDirectional.only(start: 16, end: 8, top: 16, bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              EtmamProviderLogoIcon(
                imageUrl: providerLogoUrl ?? "",
                imageSize: 38,
              ),
              const CustomHorizontalSpace(width: 13),
              Expanded(
                  child: CustomTextWidget(
                providerName ?? "",
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: 16,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.start,
              )),
              if (showMoreAction && onMoreAction != null)
                CustomNewIconButtonWidget(
                  btnPressed: () => onMoreAction!(),
                  iconSvg: IconPath.moreDots,
                  iconSize: 24,
                  // iconColor: AppColorsTheme.primary700,
                )
            ],
          ),
          ProviderStatusWidget(
            orderStatus: orderStatus,
            statusText: statusText ?? "",
          )
        ],
      ),
    );
  }
}

class ProviderStatusWidget extends StatelessWidget {
  final String statusText;
  final OrderStatus orderStatus;

  const ProviderStatusWidget(
      {Key? key, required this.statusText, required this.orderStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: const EdgeInsetsDirectional.only(start: 43, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTextWidget(trans('etmam_order_status'),
              textAlign: TextAlign.start,
              fontColor: AppColor.black400,
              fontSize: 13,
              fontWeight: AppFontWeight.bold),
          CustomVerticalSpace(height: 4),
          StatusTextWidget(
            orderStatus: orderStatus,
            text: statusText,
          )
        ],
      ),
    );
  }
}
