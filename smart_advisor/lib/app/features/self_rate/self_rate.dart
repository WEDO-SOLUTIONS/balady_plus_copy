import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/self_rate/option_data.dart';
import '/app/features/self_rate/rate_data.dart';
import '/app/features/self_rate/widgets/rate_widget.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class SelfRate extends StatefulWidget {
  const SelfRate({super.key});

  @override
  State<SelfRate> createState() => _SelfRateState();
}

class _SelfRateState extends State<SelfRate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "التقيم الذاتي",
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "البند الرئيسي الأول",
              style: AppStyle.heading2BoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          RateWidget(
              rateData: RateData(
                  "الرخصة والنشاط يجب عدم ممارسة قبل الحصول على الرخصة", [
            OptionData("ممتثل", AppColor.statusPositiveColor),
            OptionData("غير ممتثل", AppColor.statusNegativeColor),
            OptionData("لاينطبق", AppColor.statusAttentionColor),
          ])),
          const SizedBox(
            height: 6,
          ),
          RateWidget(
              rateData: RateData(
                  "الرخصة والنشاط يجب عدم ممارسة قبل الحصول على الرخصة", [
            OptionData("ممتثل", Colors.green),
            OptionData("غير ممتثل", Colors.red),
            OptionData("لاينطبق", Colors.orange),
          ])),
          const SizedBox(
            height: 6,
          ),
          RateWidget(
              rateData: RateData(
                  "الرخصة والنشاط يجب عدم ممارسة قبل الحصول على الرخصة", [
            OptionData("ممتثل", Colors.green),
            OptionData("غير ممتثل", Colors.red),
            OptionData("لاينطبق", Colors.orange),
          ])),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "البند الرئيسي الثاني",
              style: AppStyle.heading2BoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RateWidget(
              rateData: RateData(
                  "الرخصة والنشاط يجب عدم ممارسة قبل الحصول على الرخصة", [
            OptionData("ممتثل", Colors.green),
            OptionData("غير ممتثل", Colors.red),
            OptionData("لاينطبق", Colors.orange),
          ])),
          const SizedBox(
            height: 6,
          ),
          RateWidget(
              rateData: RateData(
                  "الرخصة والنشاط يجب عدم ممارسة قبل الحصول على الرخصة", [
            OptionData("ممتثل", Colors.green),
            OptionData("غير ممتثل", Colors.red),
            OptionData("لاينطبق", Colors.orange),
          ])),
        ],
      ),
    );
  }
}
