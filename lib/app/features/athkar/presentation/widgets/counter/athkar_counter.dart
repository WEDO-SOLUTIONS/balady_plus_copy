import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CounterAthkarWidget extends StatefulWidget {
  const CounterAthkarWidget(
      {Key? key,
      required this.count,
      required this.countText,
      required this.counter,
      required this.incrementCounter,
      required this.reset})
      : super(key: key);

  final int count;
  final String countText;
  final int counter;
  final Function incrementCounter;
  final Function reset;

  @override
  State<CounterAthkarWidget> createState() => _CounterAthkarWidgetState();
}

class _CounterAthkarWidgetState extends State<CounterAthkarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 1,
                width: 82,
                decoration: BoxDecoration(color: AppColor.primary800Light),
              ),
              SizedBox(
                width: 18,
              ),
              CustomTextWidget(
                widget.countText,
                textStyle: AppStyle.countTextAthkarStyle,
              ),
              SizedBox(
                width: 18,
              ),
              Container(
                height: 1,
                width: 82,
                decoration: BoxDecoration(color: AppColor.primary800Light),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => widget.incrementCounter(),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.counter == widget.count)
                          ? AppColor.primary900Light
                          : AppColor.primary600Light),
                  child: Center(
                    child: Text(
                      '${widget.counter}',
                      style: AppStyle.countAthkarStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => widget.reset(),
                child: Row(children: [
                  const CustomSvgIconWidget(
                    IconPath.reset,
                    iconHeight: 30,
                    iconWidth: 30,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  CustomTextWidget(
                    'reset'.tr(),
                    textStyle: AppStyle.resetAthkarTextStyle,
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
