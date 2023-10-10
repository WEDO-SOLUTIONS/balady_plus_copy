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
      this.serviceName,
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
  final String? serviceName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColor.white3.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                providerName ?? '',
                maxLines: 1,
                fontSize: 12,
                fontColor: AppColor.primary900,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.start,
              ),
              const SizedBox(width: 12),
              if (showMoreAction && onMoreAction != null)
              GestureDetector(
                onTap: () => onMoreAction!(),
                child: const CustomSvgIconWidget(
                  IconPath.settings2,
                  iconSize: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: AppColor.white,
            ),
            child: Row(
              children: [
                EtmamProviderLogoIcon(
                  imageUrl: providerLogoUrl ?? "",
                  imageSize: 58,
                ),
                const CustomHorizontalSpace(width: 13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      serviceName ?? "",
                      maxLines: 1,
                      fontColor: AppColor.black800,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 12),
                    ProviderStatusWidget(
                      orderStatus: orderStatus,
                      statusText: statusText ?? "",
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    return StatusTextWidget(
      orderStatus: orderStatus,
      text: statusText,
    );
  }
}
