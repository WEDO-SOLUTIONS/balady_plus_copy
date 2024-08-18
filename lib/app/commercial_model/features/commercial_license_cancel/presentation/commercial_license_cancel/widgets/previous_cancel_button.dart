import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'widget_title_invoice.dart';

class PreviousCancelButtons extends StatelessWidget {
  const PreviousCancelButtons({
    Key? key,
    required this.isBtnDisabled,
    this.onPressed,
  }) : super(key: key);

  final bool isBtnDisabled;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    CommercialLicenseCancelBloc bloc =
        context.read<CommercialLicenseCancelBloc>();
    return BlocBuilder<CommercialLicenseCancelBloc,
        CommercialLicenseCancelState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: Column(
            children: [
              Container(
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
                            "تكلفة الرسوم الإجمالية",
                            textStyle: AppStyle.serviceListTitleTextStyle,
                          ),
                        ),
                        CustomTextButtonWidget(
                          text: " اظهار التفاصيل".tr(),
                        ),
                      ],
                    ),
                    ///////////////////////////////////////////////////////////
                    Row(
                      children: [
                        CustomTextWidget(
                          "500",
                          textStyle: AppStyle.boardingTitle
                              .copyWith(color: AppColor.primary900Light),
                        ),
                        const SizedBox(width: 3),
                        CustomTextWidget(
                          "ر.س",
                          textStyle: AppStyle.tagTextStyle,
                        ),
                      ],
                    ),

                    /////////////////////////////////////////////////////////
                    const Column(
                      children: [
                        SizedBox(height: 8),
                        WidgetTitleInvoice(
                          money: '500 ر.س',
                          title: 'النشاط',
                        ),
                        SizedBox(height: 2),
                        WidgetTitleInvoice(
                          money: '500 ر.س',
                          title: 'النشاط',
                        ),
                        SizedBox(height: 2),
                        WidgetTitleInvoice(
                          money: '500 ر.س',
                          title: 'الكشفية',
                        ),
                        SizedBox(height: 2),
                        WidgetTitleInvoice(
                          money: '500 ر.س',
                          title: ' لوحة إعلانية',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              EnhancedCustomElevatedButtonWidget(
                btnColor: isBtnDisabled
                    ? AppColor.black200
                    : AppColor.primary900Light,
                btnTextColor:
                    isBtnDisabled ? AppColor.black400 : AppColor.white,
                btnPressed: isBtnDisabled
                    ? null
                    : () {
                        bloc.add(const SubmitCancelRequestPage());
                      },
                btnRadius: 8,
                btnText: "submit_order".tr(),
                btnTextSize: 16,
                btnTextWeight: AppFontWeight.bold,
                btnHeight: 56,
              ),
            ],
          ),
        );
      },
    );
  }
}
