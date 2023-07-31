import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CounterAthkarWidget extends StatefulWidget {
  const CounterAthkarWidget({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  State<CounterAthkarWidget> createState() => _CounterAthkarWidgetState();
}

class _CounterAthkarWidgetState extends State<CounterAthkarWidget> {
  int counter = 0;

  void _incrementCounter() {
    if (counter < widget.count) {
      setState(() {
        counter++;
      });
    }
  }

  void _resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: _incrementCounter,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (counter == widget.count)
                      ? AppColor.darkTurquoise
                      : AppColor.primary600Light),
              child: Center(
                child: Text(
                  '$counter',
                  style: AppStyle.countAthkarStyle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _resetCounter,
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
    );
  }
}
