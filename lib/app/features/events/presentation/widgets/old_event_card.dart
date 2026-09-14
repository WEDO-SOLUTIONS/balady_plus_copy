import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;

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
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.bottomRight,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CustomNetworkImageWidget(
                item.logoImage ?? "",
                imageWidth: MediaQuery.of(context).size.width,
                imageHeight: 187,
                placeHolderWidget: SvgPicture.asset(ImagePath.calendarBackground),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                //   color: Color(0x3303435633),
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [Color(0x0000394A), AppColor.primary900Light],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 8, bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /* Date(
                      day: item.getStartDay(),
                      month: item.getStartMonth(),
                    ),*/
                    // CustomHorizontalSpace(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: CustomTextWidget(
                              item.eventName ?? "",
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                          CustomVerticalSpace(height: 6),
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
                              CustomHorizontalSpace(width: 8),
                              if (item.feesType != null && item.feesType!.isNotEmpty)
                                IconName(icon: IconPath.tagHomeEvents, name: item.feesType!, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0x8F4CA5B4),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [CustomTextWidget(item.getFormatDate(), fontSize: 12, fontWeight: AppFontWeight.medium)],
                ),
              ),
            ),
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
  const IconName({super.key, required this.name, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 12),
        const SizedBox(width: 4),
        CustomTextWidget(name, fontColor: color, fontSize: 12, fontWeight: AppFontWeight.medium),
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
      width: 54,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: AppColor.secondary900Light, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextWidget(day, fontSize: 16, fontColor: AppColor.white, fontWeight: AppFontWeight.bold),
          CustomVerticalSpace(height: 2),
          CustomTextWidget(month, fontSize: 12, fontColor: AppColor.white, fontWeight: AppFontWeight.medium),
        ],
      ),
    );
  }
}

DecorationImage calendarImage(String? url, String? defaultImage) => (url?.isEmpty ?? true)
    ? (defaultImage ?? "").endsWith(".svg")
          ? DecorationImage(
              image: svg_provider.Svg(defaultImage ?? "", source: svg_provider.SvgSource.asset),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.darken),
            )
          : DecorationImage(
              image: AssetImage(defaultImage ?? ""),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.darken),
            )
    : (url!.endsWith(".svg"))
    ? DecorationImage(
        image: svg_provider.Svg(url, source: svg_provider.SvgSource.network),
        fit: BoxFit.fill,
        colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.darken),
      )
    : DecorationImage(
        image: NetworkImage(url),
        fit: BoxFit.fill,
        colorFilter: ColorFilter.mode(Color(0x33034356), BlendMode.darken),
      );
