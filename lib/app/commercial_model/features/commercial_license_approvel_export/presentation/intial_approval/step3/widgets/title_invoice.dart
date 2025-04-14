import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

class TitleInvoice extends StatelessWidget {
  final String money, title;

  const TitleInvoice({
    super.key,
    required this.money,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextWidget(
              title,
              maxLines: 2,
              textStyle: AppStyle.serviceCardDescriptionTextStyle,
            ),
          ),
          //const Spacer(),
          CustomTextWidget(
            money,
            textStyle: AppStyle.serviceCardWarningTitleTextStyle,

          ),
        ],
      ),
    );
  }
}
