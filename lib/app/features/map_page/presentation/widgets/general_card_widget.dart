import 'dart:math';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../mvvm/point_view_model.dart';
import 'package:collection/collection.dart';

class GeneralMapCardWidget extends StatelessWidget {
  final PointViewModel pointViewModel;
  final String icon;
  final Function onClose;

  const GeneralMapCardWidget(
      {super.key,
      required this.pointViewModel,
      required this.icon,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //   mapViewModel.getPointDetails(int.tryParse(data.id)!);
      },
      child: ValueListenableBuilder<DirectoryObjectMessage?>(
          valueListenable: pointViewModel.dataPoint,
          builder: (_, dataPoint, __) {
            return Container(
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
                            padding: const EdgeInsets.all(6.0),
                            decoration: ShapeDecoration(
                                color: AppColor.secondary900Light,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            child: SvgPicture.asset(
                              icon,
                              width: 24,
                              height: 24,
                              color: AppColor.white,
                            ),
                          ),
                          CustomHorizontalSpace(width: 8),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomVerticalSpace(height: 8),
                                  CustomTextWidget(
                                    dataPoint?.title ?? "",
                                    fontColor: AppColor.blackModern800Light,
                                    fontSize: 16,
                                    textOverflow: TextOverflow.ellipsis,
                                    fontWeight: AppFontWeight.bold,
                                    maxLines: 2,
                                  ),
                                  CustomVerticalSpace(height: 8),
                                  CustomTextWidget(
                                    dataPoint?.address?.components
                                            ?.firstWhereOrNull(
                                              (element) =>
                                                  element?.streetAddress !=
                                                  null,
                                            )
                                            ?.streetAddress
                                            ?.street ??
                                        "",
                                    fontColor: AppColor.blackModern500Light,
                                    fontSize: 12,
                                    fontWeight: AppFontWeight.semiBold,
                                    height: 1.3,
                                    maxLines: 2,
                                  ),
                                  CustomVerticalSpace(height: 16),
                                  CustomTextWidget(
                                    dataPoint?.externalIds?.join(" ") ?? "[]",
                                    fontColor: AppColor.blackModern500Light,
                                    fontSize: 12,
                                    fontWeight: AppFontWeight.semiBold,
                                    height: 1.3,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomTextWidget(
                      dataPoint?.workStatus?.isOpen == true
                          ? "open".tr()
                          : "open".tr(),
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
            );
          }),
    );

    return GestureDetector(
      onTap: () {
        // Navigator.of(context)
        //      .pushNamed(RouteName.MapDetailsPage, arguments: pointViewModel);
      },
      child: Container(
        decoration: ShapeDecoration(
            color: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(6.0),
                decoration: ShapeDecoration(
                    color: AppColor.secondary900Light,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
                child: SvgPicture.asset(
                  icon,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 6,
              child: ValueListenableBuilder<DirectoryObjectMessage?>(
                valueListenable: pointViewModel.dataPoint,
                builder: (_, dataPoint, __) {
                  print(dataPoint);
                  return dataPoint == null
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataPoint?.title ?? "",
                              style: AppStyle.mainTextStyle,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dataPoint.address?.components
                                      ?.firstWhereOrNull(
                                        (element) =>
                                            element?.streetAddress != null,
                                      )
                                      ?.streetAddress
                                      ?.street ??
                                  'Address',
                              style: AppStyle.serviceDescriptionStyle,
                            ),
                            const CustomVerticalSpace(height: 8),
                            Row(
                              children: [
                                CustomTextWidget(
                                  "",
                                  textStyle: AppStyle.serviceDescriptionStyle,
                                ),
                                CustomTextWidget(
                                  dataPoint?.workStatus?.isOpen == true
                                      ? "open".tr()
                                      : "",
                                  textStyle: AppStyle.serviceDescriptionStyle,
                                ),
                              ],
                            ),
                            const CustomVerticalSpace(height: 16),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                      "License type",
                                      textStyle: AppStyle
                                          .serviceDescriptionStyle
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CustomTextWidget(
                                      dataPoint?.tradeLicense?.type ?? "No",
                                      textStyle:
                                          AppStyle.serviceDescriptionStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    CustomTextWidget(
                                      "License",
                                      textStyle: AppStyle
                                          .serviceDescriptionStyle
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CustomTextWidget(
                                      dataPoint?.tradeLicense?.license ?? "No",
                                      textStyle:
                                          AppStyle.serviceDescriptionStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    CustomTextWidget(
                                      "Legal form",
                                      textStyle: AppStyle
                                          .serviceDescriptionStyle
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CustomTextWidget(
                                      dataPoint?.tradeLicense?.legalForm ??
                                          "No",
                                      textStyle:
                                          AppStyle.serviceDescriptionStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    CustomTextWidget(
                                      "End date",
                                      textStyle: AppStyle
                                          .serviceDescriptionStyle
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CustomTextWidget(
                                      dataPoint?.tradeLicense?.endDate ?? "No",
                                      textStyle:
                                          AppStyle.serviceDescriptionStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const CustomVerticalSpace(height: 16),
                            Row(
                              children: [
                                CustomTextWidget(
                                  "externalIds",
                                  textStyle:
                                      AppStyle.serviceDescriptionStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                CustomTextWidget(
                                  dataPoint?.externalIds?.join(" ") ?? "[]",
                                  textStyle: AppStyle.serviceDescriptionStyle,
                                ),
                              ],
                            )
                            /* const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 15),
                                const SizedBox(width: 6),
                                Text(
                                  '+9550029202',
                                  style: AppStyle
                                      .personalInfoParameterTitleTextStyle
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )*/
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
