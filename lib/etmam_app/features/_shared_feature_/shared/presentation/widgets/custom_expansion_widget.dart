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
        color: AppColor.primary50.withOpacity(0.9),
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
                        left: 12, right: 12, bottom: 16, top: 8),
                    child: CustomTextWidget(
                      widget.subTitle,
                      fontSize: 12,
                      height: 2,
                      fontColor: AppColor.black600,
                      fontWeight: AppFontWeight.bold,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColor.primary50,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHorizontalSpace(width: 6),
            Expanded(
              child: CustomTextWidget(
                title,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black700,
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
