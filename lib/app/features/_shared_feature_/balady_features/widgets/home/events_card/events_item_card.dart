import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/constants/paths/image_paths.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../events/domain/entities/search_events/search_events_item.dart';
import '../../../../presentation/widgets/custom_spaces_widgets.dart';
import '../../../../presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../presentation/widgets/texts/custom_text_widget.dart';

class EventItemCard extends StatelessWidget {
  final SearchEventsItem item;
  final double? width;
  final EdgeInsets? padding;
  const EventItemCard(
      {super.key, required this.item, this.width, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.eventsDetailsPage,
            arguments: item.id);
      },
      child: Container(
        height: 187,
        margin: padding ?? EdgeInsets.only(top: 16, left: 16, right: 16),
        width: width ?? MediaQuery.of(context).size.width - 32,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.bottomRight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetworkImageWidget(
                  item.logoImage ?? "",
                  imageWidth: MediaQuery.of(context).size.width,
                  imageHeight: 187,
                  placeHolderWidget:
                      SvgPicture.asset(ImagePath.calendarBackground),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    //   color: Color(0x3303435633),
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [Color(0x0000394A), Color(0xFF155F75)])),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 8, bottom: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Date(
                        day: item.getStartDay(),
                        month: item.getStartMonth(),
                      ),
                      CustomHorizontalSpace(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: CustomTextWidget(item.eventName ?? "",
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  )),
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
                                if (item.feesType != null &&
                                    item.feesType!.isNotEmpty)
                                  IconName(
                                    icon: IconPath.tagHomeEvents,
                                    name: item.feesType!,
                                    color: Colors.white,
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      width: 54,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFA7C587),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextWidget(
            day,
            fontSize: 16,
            fontColor: AppColor.white,
            fontWeight: AppFontWeight.bold,
          ),
          CustomVerticalSpace(
            height: 2,
          ),
          CustomTextWidget(
            month,
            fontSize: 12,
            fontColor: AppColor.white,
            fontWeight: AppFontWeight.medium,
          )
        ],
      ),
    );
  }
}
