import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomTextButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        DrawLineWidget;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;

Future<T> showDialogWidget<T>(BuildContext context,
    {required Widget dialogBody,
    bool isFullHeight = true,
    double? height,
    String? headerText,
    bool? haveBottomLine}) async {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenStatusBarHeight = MediaQuery.of(context).padding.top + 40;
  return (await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        builder: (context) => isFullHeight
            ? CustomFullHeightDialogWidget(
                header: headerText,
                haveBottomLine: haveBottomLine ?? true,
                dialogHeight: screenHeight - screenStatusBarHeight,
                child: dialogBody,
              )
            : CustomDialogWidget(
                header: headerText,
                haveBottomLine: haveBottomLine ?? true,
                child: dialogBody,
              ),
      )) ??
      false;
}

class CustomDialogWidget extends StatelessWidget {
  final Widget child;
  final String? header;
  final bool haveBottomLine;

  const CustomDialogWidget(
      {Key? key, required this.child, this.header, this.haveBottomLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: AppColor.white),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 5,
              right: 16,
              left: 16,
              top: 12),
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null && header!.isNotEmpty)
                DialogHeader(
                  title: header ?? "",
                  haveBottomLine: haveBottomLine,
                ),
              child
            ],
          )),
        ),
      ],
    );
  }
}

class CustomFullHeightDialogWidget extends StatelessWidget {
  final Widget child;
  final String? header;
  final bool haveBottomLine;
  final double dialogHeight;

  const CustomFullHeightDialogWidget(
      {Key? key,
      required this.child,
      this.header,
      this.haveBottomLine = true,
      required this.dialogHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dialogHeight,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          color: AppColor.white),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 5,
          right: 16,
          left: 16,
          top: 12),
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null && header!.isNotEmpty)
            DialogHeader(
              title: header ?? "",
              haveBottomLine: haveBottomLine,
            ),
          Expanded(child: child)
        ],
      )),
    );
  }
}

class DialogHeader extends StatelessWidget {
  final String title;
  final bool haveBottomLine;

  const DialogHeader(
      {Key? key, required this.title, this.haveBottomLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //     width: 64,
        //     height: 4,
        //     decoration: const BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(4)),
        //         color: AppColor.bottomNavigationShadow)),
        // const CustomVerticalSpace(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // close button
            CustomTextButtonWidget(
              btnPressed: () => Navigator.of(context).pop(),
              btnText: trans(
                "closeButton",
              ),
              btnTextColor: AppColor.grey1000,
              btnTextSize: 17.0,
              btnTextWeight: AppFontWeight.medium,
            ),
            //  const CustomHorizontalSpace(width: 44),
            Expanded(
              child: CustomTextWidget(
                title,
                textAlign: TextAlign.center,
                fontSize: 18,
                fontWeight: AppFontWeight.w600,
              ),
            ),
            const CustomHorizontalSpace(width: 65),
            // CustomNewIconButtonWidget(
            //   btnPressed: () => Navigator.pop(context),
            //   iconSvg: IconPath.close,
            //   iconSize: 12,
            // ),
          ],
        ),
        const CustomVerticalSpace(height: 12),
        if (haveBottomLine) ...[
          const DrawLineWidget(
            lineColor: AppColor.black200,
          ),
          const CustomVerticalSpace(height: 20),
        ]
      ],
    );
  }
}
