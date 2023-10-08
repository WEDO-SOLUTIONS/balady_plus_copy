import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../domain/entities/search_events/search_events_item.dart';

class OldEventHomeCard extends StatelessWidget {
  final SearchEventsItem item;
  const OldEventHomeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 187,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x03435633),
            blurRadius: 40,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
        image: calendarImage(item.logoImage, ImagePath.calendarBackground),
      ),
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: 20, bottom: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Date(
              day: item.getStartDay(),
              month: item.getStartMonth(),
            ),
            CustomHorizontalSpace(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.eventName ?? "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Arabic UI Display',
                      fontWeight: FontWeight.w700,
                    )),
                CustomVerticalSpace(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconName(
                      icon: IconPath.locationHomeEvents,
                      name: item.city ?? "",
                      color: Color(0xFFE7E7E8),
                    ),
                    CustomHorizontalSpace(width: 8),
                    IconName(
                      icon: IconPath.planetRingedHomeEvents,
                      name: item.category ?? "",
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),

            /* IconName(
              icon: IconPath.tagHomeEvents,
              name: 'مجانا',
              color: Colors.white,
            ),*/
          ],
        ),
      ),
    );
  }
}

class IconName extends StatelessWidget {
  final String name;
  final String icon;
  final Color color;
  const IconName(
      {super.key, required this.name, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 12,
        ),
        const SizedBox(
          width: 4,
        ),
        CustomTextWidget(
          name,
          fontColor: color,
          fontSize: 12,
          fontWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}

class Date extends StatelessWidget {
  final String day;
  final String month;
  const Date({super.key, required this.day, required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFA7C587),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomTextWidget(
            day,
            fontSize: 16,
            fontColor: AppColor.white,
            fontWeight: AppFontWeight.bold,
          ),
          CustomTextWidget(
            month,
            fontSize: 8,
            fontColor: AppColor.white,
            fontWeight: AppFontWeight.medium,
          )
        ],
      ),
    );
  }
}

DecorationImage calendarImage(String? url, String? defaultImage) => (url
            ?.isEmpty ??
        true)
    ? (defaultImage ?? "").endsWith(".svg")
        ? DecorationImage(
            image: svgProvider.Svg(defaultImage ?? "",
                source: svgProvider.SvgSource.asset),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.srcOver),
          )
        : DecorationImage(
            image: AssetImage(defaultImage ?? ""),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.srcOver),
          )
    : (url!.endsWith(".svg"))
        ? DecorationImage(
            image: svgProvider.Svg(
              url,
              source: svgProvider.SvgSource.network,
            ),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.srcOver),
          )
        : DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.srcOver),
          );
