import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../data/model/excavations.dart';
import '../../mvvm/map_view_model.dart';

class DiggingMapCard extends StatelessWidget {
  final Excavations data;
  final Function onClose;

  const DiggingMapCard({super.key, required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return GestureDetector(
      onTap: () {
        //   mapViewModel.getPointDetails(int.tryParse(data.id)!);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8)),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x1C77758D),
                  blurRadius: 22,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Stack(
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        ImagePath.diggingMapCard,
                        width: 60,
                        height: 60,
                      )),
                  CustomHorizontalSpace(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(
                          data.nameAr ?? "",
                          fontColor: AppColor.blackModern800Light,
                          fontSize: 16,
                          fontWeight: AppFontWeight.bold,
                          maxLines: 1,
                        ),
                        CustomVerticalSpace(height: 8),
                        CustomTextWidget(
                          data.siteName ?? "",
                          fontColor: AppColor.blackModern500Light,
                          fontSize: 12,
                          fontWeight: AppFontWeight.semiBold,
                          height: 1.3,
                          maxLines: 2,
                        ),
                        CustomVerticalSpace(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextWidget(
                              data.worksStartDate != null
                                  ? DateFormat("yyyy-MM-dd")
                                      .format(data.worksStartDate!)
                                  : "",
                              fontColor: AppColor.blackModern500Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.semiBold,
                              height: 1.3,
                              maxLines: 2,
                            ),
                            CustomTextWidget(
                              data.worksEndDate != null
                                  ? DateFormat("yyyy-MM-dd")
                                      .format(data.worksEndDate!)
                                  : "",
                              fontColor: AppColor.blackModern500Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.semiBold,
                              height: 1.3,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      onClose();
                    },
                    child: CircleIcon(
                      icon: Icons.close,
                      circleSize: 24,
                      iconColor: AppColor.primary600Light,
                      backgroundColor: AppColor.geyser.withOpacity(0.4),
                      iconSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            decoration: ShapeDecoration(
              color: AppColor.blue50Light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(
                IconPath.warningIcon,
                color: AppColor.blue800Light,
              ),
              CustomHorizontalSpace(width: 16),
              Text(data.streetCloseType ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFFCD5D1A),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.17,
                  )),
            ]),
          )
        ],
      ),
    );
  }
}
