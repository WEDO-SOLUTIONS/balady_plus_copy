import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class SanctionCalc extends StatefulWidget {
  final String price;
  final int index;
  final bool isCritical;
  final Function onChangeOccurence;
  final String? correction;
  final int? noOfOccurences;
  const SanctionCalc(
      {super.key,
      required this.price,
      required this.onChangeOccurence,
      required this.isCritical,
      required this.index,
      required this.correction,
      required this.noOfOccurences});

  @override
  State<SanctionCalc> createState() => _SanctionCalcState();
}

class _SanctionCalcState extends State<SanctionCalc> {
  var list = [
    {"title": "اول مرة", "times": 1},
    {"title": "ثاني مرة", "times": 2},
    {"title": "ثالث مرة", "times": 3},
    {"title": "رابع مرة", "times": 4},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) {
                return InkWell(
                  onTap: () {
                    widget.onChangeOccurence(list[i]["times"]);
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 2, right: 2),
                    decoration: BoxDecoration(
                        color: widget.index == i
                            ? AppColor.statusAccentColor
                            : AppColor.surfaceSecondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    //margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(4),

                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          list[i]["title"] as String,
                          style: AppStyle.footNoteBoldStyle.copyWith(
                              color: widget.index == i
                                  ? Colors.white
                                  : AppColor.textSecondaryColor),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.surfaceSecondaryColor),
          child: ListTile(
              title: Text(
                "قيمة الغرامة",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
              trailing: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ((widget.price == "0" &&
                              widget.isCritical ==
                                  false) /*||
                              (widget.correction == "true" &&
                                  widget.noOfOccurences == 1)*/
                          )
                          ? "إنذار"
                          : widget.price,
                      style: AppStyle.calloutBoldStyle,
                    ),
                    if (!((widget.price == "0" &&
                            widget.isCritical ==
                                false) /*||
                        (widget.correction == "true" &&
                            widget.noOfOccurences == 1)*/
                        ))
                      TextSpan(
                        text: ' ريال / للرخصة ',
                        style: AppStyle.captionRomanStyle
                            .copyWith(color: AppColor.textPrimaryColor),
                      ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}
