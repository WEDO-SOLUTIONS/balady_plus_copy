
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventsTitlePriceWidget extends StatelessWidget {
  const EventsTitlePriceWidget({
    super.key,
    required this.title,
    required this.address,
  });
  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(8),
          right: Radius.circular(8),
        ),
        gradient: LinearGradient(
          begin: Alignment(-0.00, 1.00),
          end: Alignment(0, -1),
          colors: [Color(0xFF131718), Color(0x00070D0E)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  title,
                  textStyle: AppStyle.eventsSectionTitleStyle,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      IconPath.eventsLocationIcon,
                    ),
                    CustomTextWidget(
                      address,
                      textStyle: AppStyle.eventsLocationTextStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
          /*  Row(
            children: [
              CustomTextWidget(
                '400_riyals'.tr(),
                textStyle: AppStyle.moneyStyleEvents,
              ),
              SizedBox(
                width: 2,
              ),
              CustomTextWidget(
                'sar'.tr(),
                textStyle: AppStyle.riyalEventStyle,
              ),
            ],
          )*/
        ],
      ),
    );
  }
}
