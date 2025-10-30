import 'dart:math';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/domain/entities/categories/category_item.dart';
import '../../../vd/presentation/dialogs/qr_types_dialog.dart';
import '../../constants/constants.dart';
import '../../data/model/resturant_model.dart';
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import 'package:collection/collection.dart';

class ResturantMapCardWidget extends StatelessWidget {
  final ResturantModel data;

  final Function onClose;

  const ResturantMapCardWidget(
      {super.key, required this.data, required this.onClose});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel =
        Provider.of<MapViewModel>(context, listen: false);

    return GestureDetector(
        onTap: () async {
          NavigationService.navigatorKey.currentState!
              .pushNamed(RouteName.ResturantDetailsPage, arguments: data);
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomVerticalSpace(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 58,
                                      height: 58,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: ShapeDecoration(
                                          color: Color(0xffCD5D1A),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          )),
                                      child: SvgPicture.asset(
                                        Constants.restaurantLayerIcon,
                                        width: 16,
                                        height: 16,
                                      )),
                                  CustomHorizontalSpace(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsetsDirectional.only(
                                              end: 3),
                                          child: CustomTextWidget(
                                            data.TRADENAME ?? "",
                                            fontColor:
                                                AppColor.blackModern800Light,
                                            fontSize: 16,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontWeight: AppFontWeight.bold,
                                            maxLines: 2,
                                          ),
                                        ),
                                        CustomVerticalSpace(height: 8),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  Constants.restaurantLayerIcon,
                                                  color: Color(0xffBD591D),
                                                  height: 14,
                                                ),
                                                CustomHorizontalSpace(width: 4),
                                                CustomTextWidget(
                                                  data.ACTIVITY_DETAILED_DESCRIPTION ??
                                                      "",
                                                  fontColor: Color(0xff71717A),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            CustomHorizontalSpace(width: 16),
                                            /* if (data.getRating.isNotEmpty)
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    IconPath.qrRatingStarIcon,
                                                    color: Color(0xffBD591D),
                                                    height: 14,
                                                  ),
                                                  CustomHorizontalSpace(
                                                      width: 4),
                                                  Row(
                                                    children: [
                                                      CustomTextWidget(
                                                        data.getRating ?? "",
                                                        fontColor: AppColor
                                                            .blackModern500Light,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            AppFontWeight.bold,
                                                      ),
                                                      CustomHorizontalSpace(
                                                          width: 4),
                                                      if (data.getReviews
                                                          .isNotEmpty)
                                                        CustomTextWidget(
                                                          data.getReviews ?? "",
                                                          fontColor: AppColor
                                                              .blackModern500Light,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              AppFontWeight
                                                                  .bold,
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              )*/
                                          ],
                                        ),
                                        CustomVerticalSpace(height: 8),
                                        CustomTextWidget(
                                          data.getAddress,
                                          fontColor:
                                              AppColor.blackModern500Light,
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.semiBold,
                                          height: 1.3,
                                          maxLines: 2,
                                        ),
                                        CustomVerticalSpace(height: 8),
                                        /*        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomTextWidget(
                                                  data.getFirstShift ?? "",
                                                  fontColor: AppColor
                                                      .blackModern500Light,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                  height: 1.3,
                                                  maxLines: 2,
                                                ),
                                                CustomTextWidget(
                                                  data.OPENSTATUS ?? "",
                                                  textStyle: TextStyle(
                                                    color: Color(0xFFA7C587),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                )
                                              ],
                                            ),
                                            if ((data.getSecondShift ?? "")
                                                .isNotEmpty) ...[
                                              CustomVerticalSpace(height: 4),
                                              CustomTextWidget(
                                                data.getSecondShift ?? "",
                                                fontColor: AppColor
                                                    .blackModern500Light,
                                                fontSize: 12,
                                                fontWeight: AppFontWeight.bold,
                                                height: 1.3,
                                                maxLines: 2,
                                              )
                                            ],
                                            if ((data.getThirdhift ?? "")
                                                .isNotEmpty) ...[
                                              CustomVerticalSpace(height: 4),
                                              CustomTextWidget(
                                                data.getThirdhift ?? "",
                                                fontColor: AppColor
                                                    .blackModern500Light,
                                                fontSize: 12,
                                                fontWeight: AppFontWeight.bold,
                                                height: 1.3,
                                                maxLines: 2,
                                              ),
                                            ]
                                          ],
                                        )
                                   */
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              CustomVerticalSpace(height: 8),
                            ],
                          ),
                        ),
                      )
                    ]),
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
