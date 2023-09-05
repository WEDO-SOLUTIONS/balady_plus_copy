import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../cubit/service_cards_cubit/service_cards_cubit.dart';
import '../service_card_parameter.dart';

class ServiceCardReqWidget extends StatelessWidget {
  const ServiceCardReqWidget({super.key});

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
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: card.requirements?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.checked),
                              CustomHorizontalSpace(width: 4),
                              Flexible(
                                child: CustomTextWidget(
                                  card.requirements?[index] ?? "",
                                  fontColor: AppColor.blackModern600Light,
                                  fontSize: 14,
                                  maxLines: 10,
                                  height: 1.4,
                                  fontWeight: AppFontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const CustomVerticalSpace(height: 8),
                          const DrawLineWidget(
                            lineColor: Color(0x0F0B7E47),
                          ),
                          const CustomVerticalSpace(height: 8),
                        ],
                      );
                    })
              ],
            )
          ],
        ),
      );
    });
  }
}
