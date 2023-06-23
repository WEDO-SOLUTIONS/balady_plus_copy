import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../services_exports.dart'
    show ServiceCardEntity, ServiceCardParameter;

class ServiceCardDescription extends StatelessWidget {
  final ServiceCardEntity card;

  const ServiceCardDescription({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkSlateBlue6,
            offset: Offset(0, -4),
            blurRadius: 32,
          )
        ],
        color: AppColor.blackModern50Light,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DrawIconBasedTypeWidget(
                icon: IconPath.requests, //card.iconName,
              ),
              const SizedBox(width: 4),
              CustomTextWidget(
                card.title,
                textStyle: AppStyle.cardTitleTextStle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextWidget(
            card.description,
            textStyle: AppStyle.serviceCardDescriptionTextStyle,
            maxLines: 6,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ServiceCardParameter(
                title: 'rating'.tr(),
                iconName: IconPath.rating,
                value: card.rate.toString(),
              ),
              const SizedBox(width: 16),
              ServiceCardParameter(
                title: "${'duration'.tr()} ${'days'.tr()}",
                iconName: IconPath.duration,
                value: card.duration.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
