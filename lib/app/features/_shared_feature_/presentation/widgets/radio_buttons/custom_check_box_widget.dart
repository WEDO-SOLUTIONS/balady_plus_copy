import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, GeneralKey;
import '../texts/custom_text_widget.dart';

class CustomCheckBoxWidget extends StatefulWidget {
  final double height;
  final double width;
  final Color borderColor;
  final Color borderSelectedColor;
  final double borderRadius;
  final void Function(bool?)? onSelected;
  final Color backgroundColor;
  final Color containerBackgroundColor;
  final Color backgroundSelectedColor;
  final double space;
  final EdgeInsetsGeometry? padding;
  final double horizontalPadding;
  final double verticalPadding;
  final double checkboxSize;
  final Color checkboxSelectedColor;
  final Color checkboxUnSelectedColor;
  final bool checkboxValue;
  final String title;
  final Color titleColor;
  final double titleSize;
  final AppFontWeight titleFontWeight;
  final double titleHeight;
  final AlignmentDirectional checkBoxAlignment;

  const CustomCheckBoxWidget({
    super.key,
    this.height = 60.0,
    this.width = double.infinity,
    this.borderColor = Colors.transparent,
    this.borderSelectedColor = AppColor.primary900Light,
    this.borderRadius = 4.0,
    required this.onSelected,
    this.backgroundColor = AppColor.black100,
    this.containerBackgroundColor = Colors.transparent,
    this.backgroundSelectedColor = AppColor.duckEggBlue,
    this.space = 4.0,
    this.padding,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 0.0,
    this.checkboxSize = 1.15,
    this.checkboxSelectedColor = AppColor.primary900Light,
    this.checkboxUnSelectedColor = AppColor.white,
    required this.checkboxValue,
    required this.title,
    this.titleColor = AppColor.black,
    this.titleSize = 14.0,
    this.titleFontWeight = AppFontWeight.medium,
    this.titleHeight = 25.0,
    this.checkBoxAlignment = AlignmentDirectional.centerStart,
  });

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidgetState();
}

class _CustomCheckBoxWidgetState extends State<CustomCheckBoxWidget> {
  late ValueNotifier<bool> _checkBoxValue;

  @override
  void initState() {
    super.initState();
    _checkBoxValue = ValueNotifier<bool>(widget.checkboxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.height,
      // width: widget.width,
      alignment: widget.checkBoxAlignment,
      margin: const EdgeInsets.only(bottom: GeneralKey.semiMediumPadding),
      decoration: BoxDecoration(
        border: Border.all(color: widget.checkboxValue ? widget.borderSelectedColor : widget.borderColor),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.containerBackgroundColor,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _checkBoxValue,
        builder: (context, value, child) {
          return ListTile(
            onTap: () {
              _checkBoxValue.value = !value;
              widget.onSelected!(_checkBoxValue.value);
            },
            selected: widget.checkboxValue,
            tileColor: widget.backgroundColor,
            selectedTileColor: widget.backgroundSelectedColor,
            horizontalTitleGap: widget.space,
            minLeadingWidth: 0.0,
            minVerticalPadding: 0.0,
            contentPadding:
                widget.padding ??
                EdgeInsets.symmetric(horizontal: widget.horizontalPadding, vertical: widget.verticalPadding),
            leading: Transform.scale(
              scale: widget.checkboxSize,
              child: Checkbox(
                value: value,
                activeColor: widget.checkboxSelectedColor,
                onChanged: (newVal) {
                  _checkBoxValue.value = newVal!;
                  widget.onSelected!(_checkBoxValue.value);
                },
              ),
            ),
            title: Container(
              // color: Colors.blue,
              //  height: widget.titleHeight,
              alignment: AlignmentDirectional.centerStart,
              child: CustomTextWidget(
                widget.title,
                fontWeight: widget.titleFontWeight,
                fontColor: widget.titleColor,
                textAlign: TextAlign.start,
                fontSize: widget.titleSize,
                height: 1.3,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomCheckBoxTopStartWidget extends StatefulWidget {
  final double height;
  final double width;
  final Color borderColor;
  final Color borderSelectedColor;
  final double borderRadius;
  final void Function(bool?)? onSelected;
  final Color backgroundColor;
  final Color containerBackgroundColor;
  final Color backgroundSelectedColor;
  final double space;
  final EdgeInsetsGeometry? padding;
  final double horizontalPadding;
  final double verticalPadding;
  final double checkboxSize;
  final Color checkboxSelectedColor;
  final Color checkboxUnSelectedColor;
  final bool checkboxValue;
  final String title;
  final Color titleColor;
  final double titleSize;
  final AppFontWeight titleFontWeight;
  final double titleHeight;
  final AlignmentDirectional checkBoxAlignment;

  const CustomCheckBoxTopStartWidget({
    super.key,
    this.height = 60.0,
    this.width = double.infinity,
    this.borderColor = Colors.transparent,
    this.borderSelectedColor = AppColor.primary900Light,
    this.borderRadius = 4.0,
    required this.onSelected,
    this.backgroundColor = AppColor.black100,
    this.containerBackgroundColor = Colors.transparent,
    this.backgroundSelectedColor = AppColor.duckEggBlue,
    this.space = 4.0,
    this.padding,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 0.0,
    this.checkboxSize = 1.15,
    this.checkboxSelectedColor = AppColor.primary900Light,
    this.checkboxUnSelectedColor = AppColor.white,
    required this.checkboxValue,
    required this.title,
    this.titleColor = AppColor.black,
    this.titleSize = 14.0,
    this.titleFontWeight = AppFontWeight.medium,
    this.titleHeight = 25.0,
    this.checkBoxAlignment = AlignmentDirectional.centerStart,
  });

  @override
  State<CustomCheckBoxTopStartWidget> createState() => _CustomCheckBoxTopStartWidget();
}

class _CustomCheckBoxTopStartWidget extends State<CustomCheckBoxTopStartWidget> {
  late ValueNotifier<bool> _checkBoxValue;

  @override
  void initState() {
    super.initState();
    _checkBoxValue = ValueNotifier<bool>(widget.checkboxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.checkBoxAlignment,
      margin: const EdgeInsets.only(bottom: GeneralKey.semiMediumPadding),
      decoration: BoxDecoration(
        border: Border.all(color: widget.checkboxValue ? widget.borderSelectedColor : widget.borderColor),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.containerBackgroundColor,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _checkBoxValue,
        builder: (context, value, child) {
          return InkWell(
            onTap: () {
              _checkBoxValue.value = !value;
              widget.onSelected!(_checkBoxValue.value);
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                      alignment: AlignmentDirectional.topStart,
                      scale: widget.checkboxSize,
                      child: Checkbox(
                        value: value,
                        activeColor: widget.checkboxSelectedColor,
                        onChanged: (newVal) {
                          _checkBoxValue.value = newVal!;
                          widget.onSelected!(_checkBoxValue.value);
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: CustomTextWidget(
                          widget.title,
                          fontWeight: widget.titleFontWeight,
                          fontColor: widget.titleColor,
                          textAlign: TextAlign.start,
                          fontSize: widget.titleSize,
                          height: 1.3,
                          maxLines: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
