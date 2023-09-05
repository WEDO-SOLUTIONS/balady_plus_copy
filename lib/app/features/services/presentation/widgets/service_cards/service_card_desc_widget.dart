import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../cubit/service_cards_cubit/service_cards_cubit.dart';
import '../service_card_parameter.dart';

class ServiceCardDescWidget extends StatelessWidget {
  const ServiceCardDescWidget({super.key});

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
                DrawIconBasedTypeWidget(
                  icon: card.iconName,
                ),
                const SizedBox(width: 4),
                CustomTextWidget(
                  card.title,
                  textStyle: AppStyle.cardTitleTextStle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                CustomTextWidget(
                  card.description,
                  textStyle: AppStyle.serviceCardDescriptionTextStyle,
                  maxLines: 6,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (card.fees != null)
                      ServiceCardParameter(
                        title: 'fees'.tr(),
                        iconName: IconPath.walletNoFees,
                        value: card.fees == 0
                            ? "service_card_no_fees".tr()
                            : card.fees.toString(),
                      ),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
