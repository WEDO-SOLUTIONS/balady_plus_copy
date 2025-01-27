import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step3/widgets/title_invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../bloc/step3_conclusion_cubit.dart';

class CalcualtorFees extends StatefulWidget {
  const CalcualtorFees({super.key});

  @override
  State<CalcualtorFees> createState() => _CalcualtorFeesState();
}

class _CalcualtorFeesState extends State<CalcualtorFees> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Step3ConclusionCubit, Step3ConclusionState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Color(0x80E6EFEF),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                // padding: const EdgeInsets.all(16),
                // decoration: const BoxDecoration(
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(16),
                //     topRight: Radius.circular(16),
                //   ),
                //   boxShadow: [
                //     BoxShadow(
                //       color: AppColor.darkSlateBlue6,
                //       offset: Offset(0, -4),
                //       blurRadius: 32,
                //     )
                //   ],
                //   color: AppColor.blackModern50Light,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: CustomTextWidget(
                            "lbl_total_price".tr(),
                            fontColor: AppColor.blackModern900Light,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            CustomTextWidget(
                              state.issueCommercialConculsionEntity?.calculateStandardFees
                                  ?.totalCost
                                  .toString() ??
                                  "",
                              textStyle: AppStyle.boardingTitle
                                  .copyWith(color: AppColor.primary900Light),
                            ),
                            const SizedBox(width: 3),
                            CustomTextWidget(
                              "sar_text".tr(),
                              textStyle: AppStyle.tagTextStyle,
                            ),
                          ],
                        ),

                      ],
                    ),

                    /////////////////////////////////////////////////////////

                    Column(
                      children: ( state.issueCommercialConculsionEntity?.calculateStandardFees?.costsInfo ??
                          [])
                          .map(
                            (costsInfo) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TitleInvoice(
                            money:
                            '${costsInfo.costItemValue} ${"sar_text".tr()}',
                            title:
                            costsInfo.costItemDescription ?? "",
                          ),
                        ),
                      )
                          .toList(),
                    ),

                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}