import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/calculator/service_calculator_exports.dart'
    show
        CalculateCostResponse,
        CalculateCostV03Response,
        CalculateDiggingResponse,
        CostsInfo,
        ServiceCalculatorScreen;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/calculator_results_page_params.dart';

class ServiceCalculatorResultScreen extends StatefulWidget {
  ServiceCalculatorResultScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ServiceCalculatorResultScreenState createState() =>
      _ServiceCalculatorResultScreenState();
}

class _ServiceCalculatorResultScreenState
    extends State<ServiceCalculatorResultScreen> {
  bool isLoading = false;
  double? totalCost = 0.0;

  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.calculatorSuccess);
    CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceFeesCalculator);
  }

  @override
  Widget build(BuildContext context) {
    CalculatorResultsPageParams params = ModalRoute.of(context)
        ?.settings
        .arguments as CalculatorResultsPageParams;

    if (params.calculateCostV03Response != null) {
      totalCost = params.calculateCostV03Response?.totalCost;
    } else if (params.calculateCostResponse != null) {
      totalCost = params.calculateCostResponse?.totalCost;
    } else if (params.calculateDiggingResponse != null) {
      totalCost = params.calculateDiggingResponse?.totalCost;
    }

    return Scaffold(
        appBar: DefaultAppBarWidget(
          title: Helpers.translatingWord('lbl_final_cost'),
        ),
        body: body(params));
  }

  Widget body(CalculatorResultsPageParams params) {
    if (isLoading) {
      return const Center(child: CustomCircularLoadingWidget());
    } else {
      return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const CustomVerticalSpace(height: 20),
                      const CustomVerticalSpace(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomTextWidget(
                            totalCost.toString(),
                            maxLines: 1,
                            fontSize: 40,
                            fontColor: AppColor.primary900Light,
                            fontWeight: AppFontWeight.bold,
                            fontFamily: Constants.lucidaGrandFontType,
                          ),
                          const CustomHorizontalSpace(width: 4),
                          CustomTextWidget(
                            Helpers.translatingWord("lbl_SAR"),
                            maxLines: 1,
                            fontSize: 21,
                            fontColor: AppColor.primary900Light,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ],
                      ),
                      const CustomVerticalSpace(height: 16),
                      CustomTextWidget(
                        Helpers.translatingWord("lbl_total_price"),
                        maxLines: 1,
                        fontSize: 18,
                        fontColor: AppColor.blackModern600Light,
                        fontWeight: AppFontWeight.medium,
                      ),
                      const CustomVerticalSpace(height: 30),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: CustomTextWidget(
                          Helpers.translatingWord("lbl_devided_as"),
                          maxLines: 1,
                          fontSize: 14,
                          fontColor: AppColor.blackModern900Light,
                          fontWeight: AppFontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      CustomVerticalSpace(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            if (params.calculateCostV03Response != null)
                              ...?params.calculateCostV03Response?.costsInfo
                                  ?.map((title) => FeeWidget(info: title))
                                  .toList(),
                            if (params.calculateCostResponse != null)
                              ...othersFee(params),
                            if (params.calculateDiggingResponse != null)
                              ...diggingFees(params)
                          ],
                        ),
                      ),
                      CustomVerticalSpace(height: 16),
                      if (params.hideNote != true) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(IconPath.warningIcon),
                            CustomHorizontalSpace(width: 8),
                            Flexible(
                              child: CustomTextWidget(
                                "calculator_note1".tr(),
                                fontWeight: AppFontWeight.bold,
                                fontSize: 12,
                                maxLines: 20,
                                height: 1.6,
                                fontColor: AppColor.blackModern500Light,
                              ),
                            )
                          ],
                        ),
                        CustomVerticalSpace(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(IconPath.warningIcon),
                            CustomHorizontalSpace(width: 8),
                            Flexible(
                              child: CustomTextWidget(
                                "calculator_note2".tr(),
                                fontWeight: AppFontWeight.bold,
                                fontSize: 12,
                                maxLines: 20,
                                height: 1.6,
                                fontColor: AppColor.blackModern500Light,
                              ),
                            )
                          ],
                        )
                      ],
                      CustomVerticalSpace(height: 32),
                      _CalcualateOtherFeesButton()
                    ]),
              ),
            ],
          ));
    }
  }

  _CalcualateOtherFeesButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 5),
            child: EnhancedCustomElevatedButtonWidget(
              btnPressed: () {
                int count = 0;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => ServiceCalculatorScreen(),
                  ),
                  (_) => count++ >= 2,
                );
              },
              btnText: Helpers.translatingWord("lbl_calculate_other_fees"),
              btnTextSize: 16,
              btnTextWeight: AppFontWeight.medium,
              btnHeight: 56,
            )));
  }

  List<Widget> othersFee(CalculatorResultsPageParams params) {
    CostsInfo info1 = CostsInfo();
    info1.costItemValue = params.calculateCostResponse?.activtyCost;
    info1.costItemDescription = Helpers.translatingWord('activity_cost');
    CostsInfo info2 = CostsInfo();
    info2.costItemValue = params.calculateCostResponse?.visitFee;
    info2.costItemDescription = Helpers.translatingWord('visit_cost');
    List<Widget> children = [FeeWidget(info: info1), FeeWidget(info: info2)];
    return children;
  }

  List<Widget> diggingFees(CalculatorResultsPageParams params) {
    CostsInfo info1 = CostsInfo();
    info1.costItemValue = params.calculateDiggingResponse?.totalCost;
    info1.costItemDescription = Helpers.translatingWord('activity_cost');
    CostsInfo info2 = CostsInfo();
    info2.costItemValue = 0.0;
    info2.costItemDescription = Helpers.translatingWord('visit_cost');
    List<Widget> children = [FeeWidget(info: info1), FeeWidget(info: info2)];
    return children;
  }
}

class FeeWidget extends StatelessWidget {
  CostsInfo info;

  FeeWidget({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0xFFE6EFEF), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: CustomTextWidget(
                  info.costItemDescription!,
                  fontColor: AppColor.black,
                  textAlign: TextAlign.start,
                  fontWeight: AppFontWeight.medium,
                ),
              ),
              CustomTextWidget(
                info.costItemValue.toString(),
                maxLines: 1,
                fontSize: 15,
                fontFamily: Constants.lucidaGrandFontType,
                fontColor: AppColor.black,
                fontWeight: AppFontWeight.bold,
              ),
              const CustomHorizontalSpace(width: 5),
              CustomTextWidget(
                Helpers.translatingWord("lbl_SAR"),
                maxLines: 1,
                fontSize: 13,
                fontColor: AppColor.black500,
                fontWeight: AppFontWeight.medium,
              ),
            ],
          ),
        ),
        const CustomVerticalSpace(height: 20)
      ],
    );
  }
}
