import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class CardCostInfoWidget extends StatelessWidget {
  const CardCostInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CommercialLicenseCancelBloc bloc =
        context.watch<CommercialLicenseCancelBloc>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: CustomTextWidget(
                  "lbl_total_price".tr(),
                  textStyle: AppStyle.serviceListTitleTextStyle,
                ),
              ),
              CustomTextButtonWidget(
                text:
                    bloc.showCostInfo ? "hide_info".tr() : "show_details".tr(),
                onPressed: () {
                  bloc.add(ShowCostInfo(!bloc.showCostInfo));
                },
              ),
            ],
          ),
          Row(
            children: [
              CustomTextWidget(
                bloc.saveCancellationReasonResponse!.calculatorResponse
                    .totalCost
                    .toString(),
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
          /////////////////////////////////////////////////////////

          BlocBuilder<CommercialLicenseCancelBloc,
              CommercialLicenseCancelState>(
            builder: (context, state) {
              return bloc.showCostInfo
                  ? Column(
                      children: bloc.saveCancellationReasonResponse!
                          .calculatorResponse.costsInfo
                          .map(
                            (costsInfo) => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: WidgetTitleInvoice(
                                money:
                                    '${costsInfo.costItemValue} ${"sar_text".tr()}',
                                title: costsInfo.costItemDescription,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
