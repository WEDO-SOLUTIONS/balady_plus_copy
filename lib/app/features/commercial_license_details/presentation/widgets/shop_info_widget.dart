import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class ShopInfoWidget extends StatelessWidget {
  final ShopInfo? shopInfo;

  const ShopInfoWidget({super.key, required this.shopInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'plaest_data_paintings'.tr(),
      icon: IconPath.editIcon,
      children: [
        CardParameter(
          title: 'shopName'.tr(),
          value: shopInfo?.shopName ?? '',
        ),
        CardParameter(
          // from whats
          title: 'shopUnitNumber'.tr(),
          value: shopInfo?.shopUnitNumber?.toString() ?? "",
        ),
        shopInfo?.blockNumber != null
            ? CardParameter(
                title: 'blockNumber'.tr(),
                value: shopInfo?.blockNumber?.toString() ?? "",
              )
            : const SizedBox(),
        CardParameter(
          title: 'holesCount'.tr(),
          value: shopInfo?.holesCount?.toString() ?? "",
        ),
        CardParameter(
          title: 'floorCount'.tr(),
          value: shopInfo?.floorCount?.toString() ?? "",
        ),
        CardParameter(
          title: 'noOfCameras'.tr(),
          value: shopInfo?.noOfCameras?.toString() ?? "",
        ),
        shopInfo?.hasElevator != null
            ? CardParameter(
                title: 'hasElevator'.tr(),
                value:
                    (shopInfo?.hasElevator ?? false) ? 'yes'.tr() : 'no'.tr(),
              )
            : const SizedBox(),
        shopInfo?.insidePetrolStation != null
            ? CardParameter(
                title: 'issue_commercial_shop_inside_petrol'.tr(),
                value: (shopInfo?.insidePetrolStation ?? false)
                    ? 'yes'.tr()
                    : 'no'.tr(),
              )
            : const SizedBox(),
        shopInfo?.existInMall != null
            ? CardParameter(
                title: 'issue_commercial_shop_inside_mall'.tr(),
                value:
                    (shopInfo?.existInMall ?? false) ? 'yes'.tr() : 'no'.tr(),
              )
            : const SizedBox(),
      ],
    );
  }
}
