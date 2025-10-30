import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomTextWidget, CustomVerticalSpace;
import 'package:flutter/material.dart';

class OrderTitleAndDescWidget extends StatelessWidget {
  final String title;
  final String? desc;
  final Widget? descWidget;
  final double spaceBetweenTitleAndDesc;

  const OrderTitleAndDescWidget(
      {Key? key,
      required this.title,
      this.desc,
      this.descWidget,
      this.spaceBetweenTitleAndDesc = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          CustomTextWidget(title,
              fontColor: AppColor.baladyDarkGreen2,
              fontSize: 13,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold),
        //TitleWidget(title: title),
        if (title.isNotEmpty)
          CustomVerticalSpace(height: spaceBetweenTitleAndDesc),
        if (desc != null)
          CustomTextWidget(
            desc ?? "",
            fontColor: AppColor.hunterGreen,
            fontWeight: AppFontWeight.w600,
            fontSize: 14,
            textAlign: TextAlign.start,
          ),
        if (descWidget != null) descWidget ?? const Center()
      ],
    );
  }
}

class OrderTitleGreyAndDescWidget extends StatelessWidget {
  final String title;
  final String? desc;
  final Widget? descWidget;
  final double spaceBetweenTitleAndDesc;

  const OrderTitleGreyAndDescWidget(
      {Key? key,
      required this.title,
      this.desc,
      this.descWidget,
      this.spaceBetweenTitleAndDesc = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(title,
            fontColor: const Color(0xffa3a3a3),
            fontSize: 11,
            textAlign: TextAlign.start,
            fontWeight: AppFontWeight.bold),
        //TitleWidget(title: title),
        CustomVerticalSpace(height: spaceBetweenTitleAndDesc),
        if (desc != null)
          CustomTextWidget(
            desc ?? "",
            fontColor: AppColor.hunterGreen,
            fontWeight: AppFontWeight.bold,
            fontSize: 16,
            textAlign: TextAlign.start,
          ),
        if (descWidget != null) descWidget ?? const Center()
      ],
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          color: AppColor.purpleColor,
          margin: const EdgeInsetsDirectional.only(end: 8),
        ),
        Expanded(
          child: CustomTextWidget(
            title,
            fontColor: AppColor.purpleColor,
            fontWeight: AppFontWeight.medium,
            fontSize: 14,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }
}

class EtmamCustomReadOnlyTextWidget extends StatelessWidget {
  final String label;
  final String text;
  final Color labelColor;
  final double labelSize;
  final TextAlign labelTextAlign;
  final Widget? endWidget;

  final double borderWidth;
  final Color borderColor;

  final TextAlign textAlign;
  final TextStyle? textStyle;
  final double spacerSize;

  const EtmamCustomReadOnlyTextWidget(
      {Key? key,
      required this.label,
      required this.text,
      this.labelColor = AppColor.black700,
      this.labelSize = 16,
      this.labelTextAlign = TextAlign.start,
      this.borderWidth = 1.0,
      this.borderColor = AppColor.black200,
      this.textStyle,
      this.textAlign = TextAlign.start,
      this.spacerSize = 20.0,
      this.endWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        if (label.isNotEmpty)
          CustomTextWidget(label,
              fontColor: labelColor,
              fontSize: labelSize,
              textAlign: labelTextAlign,
              fontWeight: AppFontWeight.bold),
        // Container(
        //   padding: const EdgeInsets.symmetric(vertical: 12),
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     border: Border(
        //       bottom: BorderSide(width: borderWidth, color: borderColor),
        //     ),
        //   ),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: CustomTextWidget(
        //           text,
        //           fontColor: AppColor.black,
        //           fontSize: 16,
        //           fontWeight: AppFontWeight.medium,
        //         ),
        //       ),
        //       if (endWidget != null) endWidget!
        //     ],
        //   ),
        // ),
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: AppColor.white6.withOpacity(0.5),
          ),
          child: CustomTextWidget(
            text,
            fontColor: AppColor.black700,
            fontSize: 14,
            maxLines: 3,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
