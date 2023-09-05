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

class ServiceCardFlowWidget extends StatelessWidget {
  const ServiceCardFlowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCardsCubit, ServiceCardsState>(
        builder: (context, state) {
      final card = state.selectedCard;
      if (card == null) {
        return const SizedBox();
      }

      return Expanded(
        child: Container(
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
          child: SingleChildScrollView(
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
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: card.flow?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: 32,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: AppColor.blackModern50Light,
                        ),
                        child: CustomEnhancedExpansionPanelWidget(
                          title: card.flow?[index].title ?? "",
                          isExpanded: true,
                          //  leading: SvgPicture.asset(IconPath.serviceCardDesc),
                          backgroundColor: Color(0x80E6EFEF),
                          //   leadingWidth: 40,
                          children: [
                            ...card.flow![index].steps!
                                .map((e) => Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      padding: const EdgeInsets.all(16),
                                      // width:
                                      //     MediaQuery.of(context).size.width * 0.6,
                                      // height: 100,
                                      /*  decoration: const BoxDecoration(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(16)),
                                            color: AppColor.blackModern50Light,
                                          ),*/
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 3,
                                            width: 3,
                                            margin: EdgeInsets.only(top: 8),
                                            decoration: BoxDecoration(
                                                color: AppColor.black,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3))),
                                          ),
                                          CustomHorizontalSpace(width: 8),
                                          Flexible(
                                            child: CustomTextWidget(
                                              e,
                                              maxLines: 30,
                                              fontColor:
                                                  AppColor.blackModern500Light,
                                              fontSize: 14,
                                              height: 1.3,
                                              fontWeight: AppFontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList()
                          ],
                        ),

                        /*    Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(IconPath.serviceCardDesc),
                                CustomHorizontalSpace(width: 4),
                                Flexible(
                                  child: CustomTextWidget(
                                    card.flow?[index].title ?? "",
                                    maxLines: 1,
                                    fontSize: 15,
                                    fontWeight: AppFontWeight.bold,
                                    fontColor: AppColor.blackModern600Light,
                                  ),
                                ),
                              ],
                            ),
                            const CustomVerticalSpace(height: 18),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...card.flow![index].steps!
                                    .map((e) => Container(
                                          margin: const EdgeInsets.only(left: 16),
                                          padding: const EdgeInsets.all(16),
                                          // width:
                                          //     MediaQuery.of(context).size.width * 0.6,
                                          // height: 100,
                                          /*  decoration: const BoxDecoration(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(16)),
                                            color: AppColor.blackModern50Light,
                                          ),*/
                                          child: CustomTextWidget(
                                            e,
                                            maxLines: 30,
                                            fontColor: AppColor.blackModern500Light,
                                            fontSize: 14,
                                            height: 1.3,
                                            fontWeight: AppFontWeight.bold,
                                          ),
                                        ))
                                    .toList()
                              ],
                            )
                          ],
                        ),*/
                      );
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
