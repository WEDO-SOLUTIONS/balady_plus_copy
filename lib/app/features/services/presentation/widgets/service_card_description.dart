import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../services_exports.dart'
    show ServiceCardParameter, ServiceCardsCubit, ServiceCardsState;

class ServiceCardDescription extends StatelessWidget {
  const ServiceCardDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCardsCubit, ServiceCardsState>(
      builder: (context, state) {
        final card = state.selectedCard;
        if (card == null) {
          return const SizedBox();
        }

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
                    title: 'duration'.tr(),
                    iconName: IconPath.duration,
                    value: '${card.duration} ${'days'.tr()}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
