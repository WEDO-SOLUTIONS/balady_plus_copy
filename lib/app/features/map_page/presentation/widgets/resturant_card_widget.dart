import 'dart:math';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/map_utils.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../facility_qr/presentation/core/view_models/facility_details_view_model.dart';
import '../../../facility_qr/presentation/dialogs/facility_dialog.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/domain/entities/categories/category_item.dart';
import '../../../vd/presentation/dialogs/qr_types_dialog.dart';
import '../../constants/constants.dart';
import '../../data/model/resturant_model.dart';
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import 'package:collection/collection.dart';

import '../pages/mosque_details_page.dart';
import '../pages/parks_details_page.dart';
import '../pages/station_details_page.dart';

class ResturantMapCardWidget extends StatelessWidget {
  final ResturantModel data;
  final String icon;
  final Color color;

  final Function onClose;

  const ResturantMapCardWidget(
      {super.key,
      required this.data,
      required this.icon,
      required this.color,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel =
        Provider.of<MapViewModel>(context, listen: false);

    return GestureDetector(
        onTap: () async {
          // }
        },
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(16.0),
                        decoration: ShapeDecoration(
                            color: color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                        child: icon.isNotEmpty
                            ? Image.asset(
                                icon,
                                width: 24,
                                height: 24,
                              )
                            : Container(),
                      ),
                      CustomHorizontalSpace(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomVerticalSpace(height: 8),
                              CustomTextWidget(
                                data.TRADENAME ?? "",
                                fontColor: AppColor.blackModern800Light,
                                fontSize: 16,
                                textOverflow: TextOverflow.ellipsis,
                                fontWeight: AppFontWeight.bold,
                                maxLines: 2,
                              ),
                              CustomVerticalSpace(height: 8),
                              CustomTextWidget(
                                data.STREET_NAME ?? "",
                                fontColor: AppColor.blackModern500Light,
                                fontSize: 12,
                                fontWeight: AppFontWeight.semiBold,
                                height: 1.3,
                                maxLines: 2,
                              ),
                              CustomVerticalSpace(height: 8),
                              /* GestureDetector(
                                          onTap: () =>
                                              CommonFunctions.openUber(
                                                  dataPoint!
                                                      .markerPosition!
                                                      .latitude,
                                                  dataPoint
                                                      .markerPosition!
                                                      .longitude),
                                          child: Row(
                                            children: [
                                              CustomTextWidget(
                                                "فتح تطبيق أوبر".tr(),
                                                fontWeight:
                                                    AppFontWeight.bold,
                                                fontSize: 12,
                                                fontColor: AppColor
                                                    .primary800Light,
                                              ),
                                              CustomHorizontalSpace(
                                                  width: 8),
                                              SvgPicture.asset(
                                                  Constants.goToLocation),
                                            ],
                                          ),
                                        )*/

                              /*  CustomVerticalSpace(height: 16),
                                CustomTextWidget(
                                  dataPoint?.externalIds?.join(" ") ?? "[]",
                                  fontColor: AppColor.blackModern500Light,
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.semiBold,
                                  height: 1.3,
                                  maxLines: 2,
                                ),*/
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomTextWidget(
                  data.OPENSTATUS ?? "",
                  textStyle: TextStyle(
                    color: Color(0xFFA7C587),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
        ));
  }
}
