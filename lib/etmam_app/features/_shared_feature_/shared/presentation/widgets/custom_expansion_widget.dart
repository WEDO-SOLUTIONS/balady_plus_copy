import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/expansion_arrow_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomSvgIconWidget,
        CustomTextWidget,
        DrawLineWidget;
import 'package:flutter/material.dart';

class ExpansionItemWidget extends StatefulWidget {
  String title;
  String subTitle;
  bool isExpanded;
  Color containerColor;

  ExpansionItemWidget(
      {Key? key,
      required this.title,
      required this.subTitle,
      this.isExpanded = false,
      this.containerColor = AppColor.lightGrey})
      : super(key: key);

  @override
  State<ExpansionItemWidget> createState() => _ExpansionItemWidgetState();
}

class _ExpansionItemWidgetState extends State<ExpansionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        //  color: widget.containerColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpansionItemHeaderWidget(
              title: widget.title,
              isExpanded: widget.isExpanded,
              onPress: () {
                setState(() {
                  widget.isExpanded = !widget.isExpanded;
                });
              }),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: widget.isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 16,
                    ),
                    child: CustomTextWidget(
                      widget.subTitle,
                      fontSize: 14,
                      fontColor: AppColor.greyText,
                      fontWeight: AppFontWeight.medium,
                    ),
                  )
                : const SizedBox(),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: child,
              );
            },
          ),
          DrawLineWidget()
        ],
      ),
    );
  }
}

class ExpansionItemHeaderWidget extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final Function onPress;

  const ExpansionItemHeaderWidget(
      {Key? key,
      required this.title,
      required this.onPress,
      required this.isExpanded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
            start: 12.0, top: 12, end: 17, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 4,
                width: 6,
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                    color: AppColor.greenishYellow500,
                    borderRadius: BorderRadius.circular(2))),
            const CustomHorizontalSpace(width: 6),
            Expanded(
              child: CustomTextWidget(
                title,
                fontSize: 17,
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.black,
              ),
            ),
            const CustomHorizontalSpace(width: 8),
            ExpansionArrowWidget(expanded: isExpanded),
          ],
        ),
      ),
    );
  }
}
