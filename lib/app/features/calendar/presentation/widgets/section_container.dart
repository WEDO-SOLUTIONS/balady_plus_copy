import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

class SectionContainer extends StatelessWidget {
  final String name;
  final String date;
  final String day;
  final String month;
  final Color color1;
  final Color color2;
  final String timer;
  final String? imageBackground;
  const SectionContainer(
      {super.key,
      required this.name,
      required this.date,
      required this.day,
      required this.color1,
      required this.color2,
      required this.month,
      required this.timer,
      this.imageBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4CE9EAF1),
            blurRadius: 40,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
        image: (imageBackground?.endsWith(".svg") ?? false)
            ? DecorationImage(
                image: svgProvider.Svg(
                  imageBackground ?? "",
                  source: svgProvider.SvgSource.network,
                ),
                fit: BoxFit.fill,
              )
            : DecorationImage(
                image: NetworkImage(imageBackground ?? ""),
                fit: BoxFit.fill,
              ),
      ),
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomTextWidget(
                        name,
                        fontSize: 14,
                        fontColor: Color(0xFF3F3F46),
                        fontWeight: AppFontWeight.bold,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ], //ImagePathCalendar.flag
                ),
                CustomVerticalSpace(height: 8),
                CustomTextWidget(
                  date,
                  fontSize: 12,
                  height: 1.4,
                  fontColor: Color(0x6B111111),
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: const Alignment(0.76, 0.64),
                  end: const Alignment(-0.76, -0.64),
                  colors: [color1, color2],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomTextWidget(
                        day,
                        fontSize: 16,
                        fontColor: AppColor.white,
                        fontWeight: AppFontWeight.bold,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomTextWidget(
                        month,
                        fontSize: 12,
                        fontColor: AppColor.white,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ],
                  ),
                  CustomTextWidget(
                    timer,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.white,
                    fontSize: 10.3,
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
