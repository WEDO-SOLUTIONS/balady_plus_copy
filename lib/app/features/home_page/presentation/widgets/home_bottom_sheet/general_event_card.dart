import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GeneralEventHomeCard extends StatelessWidget {
  const GeneralEventHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
                width: 343,
                height: 187,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Color(0x33034356), BlendMode.srcOver),
                      image: AssetImage(
                        IconPath.rockHomeEvents,
                      )),
                )),
          ),
          Positioned(
            top: 15,
            left: 18,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0x4CE8EFF1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(width: 15, IconPath.bookmarkHomeEvents),
              ),
            ),
          ),
          const Positioned(
            bottom: 10,
            right: 20,
            child: SizedBox(
              width: 270,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Date(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('صخرة الفيل',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'packages/balady_design_system/IBMPlexSansArabic',
                            fontWeight: FontWeight.w700,
                          )),
                      IconName(
                        icon: IconPath.locationHomeEvents,
                        name: 'الدرعية, السمحانية',
                        color: Color(0xFFE7E7E8),
                      ),
                    ],
                  ),
                  IconName(
                    icon: IconPath.planetRingedHomeEvents,
                    name: 'معلم',
                    color: Colors.white,
                  ),
                  IconName(
                    icon: IconPath.tagHomeEvents,
                    name: 'مجانا',
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
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
  const Date({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.secondary900Light,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          CustomTextWidget(
            '25',
            fontSize: 16,
            fontColor: AppColor.white,
            fontWeight: AppFontWeight.bold,
          ),
          CustomTextWidget(
            'Oct',
            fontSize: 8,
            fontColor: AppColor.white,
            fontWeight: AppFontWeight.medium,
          )
        ],
      ),
    );
  }
}
