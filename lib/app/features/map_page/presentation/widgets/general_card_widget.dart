import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/map_page/extensions/week_day_ext.dart';
import 'package:balady_plus/app/features/map_page/extensions/week_time_interval_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import 'package:collection/collection.dart';

class GeneralMapCardWidget extends StatelessWidget {
  final PointViewModel pointViewModel;
  final String icon;
  final Color color;

  final Function onClose;

  const GeneralMapCardWidget(
      {super.key,
      required this.pointViewModel,
      required this.icon,
      required this.color,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel =
        Provider.of<MapViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        /*if (mapViewModel.selectedCategory.value != null) {
          DirectoryObjectMessage? message = pointViewModel.dataPoint.value;
          if (message != null &&
              mapViewModel.selectedCategory.value ==
                  SearchCategoryMessage.mousques)
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return MosqueDetailsPage(
                item: (message!, icon, color),
              );
            }));
          else if (message != null &&
              mapViewModel.selectedCategory.value ==
                  SearchCategoryMessage.gasStations)
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return StationDetailsPage(
                item: (message!, icon, color),
              );
            }));
          else if (message != null &&
              mapViewModel.selectedCategory.value ==
                  SearchCategoryMessage.parks)
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return ParksDetailsPage(
                item: (message!, icon, color),
              );
            }));
        } else {*/
        DirectoryObjectMessage? message = pointViewModel.dataPoint.value;

        if (message != null &&
            mapViewModel.selectedCategory.value ==
                SearchCategoryMessage.gasStations) {
          String? qr = pointViewModel.dataPoint.value?.externalIds?.join(" ");
          if (qr != null) {}
        }
        // }
      },
      child: ValueListenableBuilder<bool?>(
          valueListenable: pointViewModel.isLoadingData,
          builder: (_, isLoading, __) {
            return ValueListenableBuilder<DirectoryObjectMessage?>(
                valueListenable: pointViewModel.dataPoint,
                builder: (_, dataPoint, __) {
                  print("is loading $isLoading");
                  return (isLoading ?? false)
                      ? const ShimmerEffectWidget(
                          height: 120,
                        )
                      : Column(
                          children: [
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadows: [
                                  const BoxShadow(
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
                                    child: Column(
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 58,
                                                height: 58,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: ShapeDecoration(
                                                    color: color,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    )),
                                                child: Image.asset(
                                                  icon,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                              const CustomHorizontalSpace(
                                                  width: 8),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(end: 16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const CustomVerticalSpace(
                                                          height: 8),
                                                      CustomTextWidget(
                                                        dataPoint?.title ?? "",
                                                        fontColor: AppColor
                                                            .blackModern800Light,
                                                        fontSize: 16,
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        fontWeight:
                                                            AppFontWeight.bold,
                                                        maxLines: 2,
                                                      ),
                                                      const CustomVerticalSpace(
                                                          height: 8),
                                                      CustomTextWidget(
                                                        dataPoint
                                                                ?.makeAddress() ??
                                                            "",
                                                        fontColor: AppColor
                                                            .blackModern500Light,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            AppFontWeight
                                                                .semiBold,
                                                        height: 1.3,
                                                        maxLines: 2,
                                                      ),
                                                      const CustomVerticalSpace(
                                                        height: 8,
                                                      ),
                                                      /* GestureDetector(
                                                        onTap: () =>
                                                            CommonFunctions.openMap(
                                                                dataPoint!
                                                                    .markerPosition!
                                                                    .latitude,
                                                                dataPoint
                                                                    .markerPosition!
                                                                    .longitude),
                                                        child: Row(
                                                          children: [
                                                            CustomTextWidget(
                                                              "go_to_location".tr(),
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
                                        const CustomVerticalSpace(height: 16),
                                        Row(
                                          children:
                                              dataPoint?.openingHours?.values
                                                      .where((e) =>
                                                          e!.values.isNotEmpty)
                                                      .map(
                                                        (e) => Expanded(
                                                          child: Column(
                                                            children: [
                                                              CustomTextWidget(
                                                                e!
                                                                    .values[0]!
                                                                    .startTime
                                                                    .weekDay
                                                                    .displayName(),
                                                                fontColor: AppColor
                                                                    .blackModern800Light,
                                                                fontSize: 12,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    AppFontWeight
                                                                        .bold,
                                                                maxLines: 2,
                                                              ),
                                                              ...e.values
                                                                  .map((e) => [
                                                                        const CustomVerticalSpace(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          e!.displayTime(),
                                                                          fontColor:
                                                                              AppColor.blackModern500Light,
                                                                          fontSize:
                                                                              8,
                                                                          textOverflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontWeight:
                                                                              AppFontWeight.bold,
                                                                          maxLines:
                                                                              3,
                                                                          textDirection:
                                                                              TextDirection.ltr,
                                                                        ),
                                                                      ])
                                                                  .toList()
                                                                  .flattened,
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                      .toList() ??
                                                  [],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: CustomTextWidget(
                                      dataPoint?.workStatus?.isOpen == true
                                          ? "open".tr()
                                          : "".tr(),
                                      textStyle: const TextStyle(
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
                                        backgroundColor:
                                            AppColor.geyser.withOpacity(0.4),
                                        iconSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                });
          }),
    );
  }
}
