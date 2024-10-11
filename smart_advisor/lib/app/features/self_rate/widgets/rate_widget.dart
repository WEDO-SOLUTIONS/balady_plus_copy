import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/self_rate/rate_data.dart';
import 'package:flutter/material.dart';

class RateWidget extends StatefulWidget {
  final RateData rateData;
  const RateWidget({super.key, required this.rateData});

  @override
  State<RateWidget> createState() => _RateWidgetState();
}

class _RateWidgetState extends State<RateWidget> {
  int i = -1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Container(
        height: 144,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.surfaceSecondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.rateData.title,
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      List.generate(widget.rateData.options.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          i = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: i == index
                                    ? widget.rateData.options[index].color
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        //margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(4),

                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 4, bottom: 8),
                          child: Center(
                            child: Row(
                              children: [
                                (i == index)
                                    ? Icon(
                                        Icons.check_box,
                                        color: widget
                                            .rateData.options[index].color,
                                        size: 23,
                                      )
                                    : const SizedBox.shrink(),
                                Text(
                                  widget.rateData.options[index].title,
                                  style: TextStyle(
                                      fontFamily: "Bold",
                                      fontSize: 14,
                                      color: i == index
                                          ? widget.rateData.options[index].color
                                          : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
