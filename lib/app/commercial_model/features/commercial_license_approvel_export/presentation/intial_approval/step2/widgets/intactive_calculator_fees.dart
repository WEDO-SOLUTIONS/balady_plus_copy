import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step3/widgets/title_invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../data/models/calculate_fees_response_model.dart';


class IntactiveCalculatorFees extends StatefulWidget {
  final CalculateFeesResponseModel model;
  const IntactiveCalculatorFees({super.key,required this.model});

  @override
  State<IntactiveCalculatorFees> createState() => _IntactiveCalculatorFeesState();
}

class _IntactiveCalculatorFeesState extends State<IntactiveCalculatorFees> {


  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
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
                          widget.model.totalCost.toString() ?? "",
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
                  children: ( widget.model.costsInfo ??
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
  }
}