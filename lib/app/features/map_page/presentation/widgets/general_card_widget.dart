import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/map_page/extensions/contact_info_ext.dart';
import 'package:balady_plus/app/features/map_page/extensions/week_day_ext.dart';
import 'package:balady_plus/app/features/map_page/extensions/week_time_interval_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../facility_qr/facility_qr_exports.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/presentation/dialogs/qr_types_dialog.dart';

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
          if (qr != null) {
            final FacilityQRDetailsViewModel viewModel =
                locator<FacilityQRDetailsViewModel>();

            bool isLicenseFound = false;

            isLicenseFound = await viewModel.getFacilityData(qr);
            if (isLicenseFound) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => FacilityDialog(
                        address: viewModel.getCityAndStreet(),
                        facilityImg: viewModel.getCoverPhotoUrl(),
                        rate: viewModel.getFacilityAvrageRating(),
                        facilityName: viewModel.getFacilityName(),
                        reviewers: viewModel.getFacilityTotalRatingCount(),
                        onDetailsScreen: () {
                          /* NavigationService.navigatorKey.currentState!.pushNamed(
                        RoutesNames.facilityScreenRoute,
                        arguments: viewModel.facilityRespoonse);*/
                        },
                        onRatingScreen: () {
                          /*NavigationService.navigatorKey.currentState!.pushNamed(
                        RoutesNames.facilityRatingRoute,
                        arguments: viewModel.facilityRespoonse);*/
                        },
                        onIncidentScreen: () async {
                          bool isLocationAvailable =
                              await CommonFunctions.checkLocationSettings(
                                  context);
                          bool isCameraAllowed =
                              await CommonFunctions.checkCameraSettings(
                                  context);
                          if (isLocationAvailable && isCameraAllowed) {
                            double? lat = viewModel
                                .facilityRespoonse
                                ?.data
                                ?.result
                                ?.comLicenseInfo
                                ?.locationInfo
                                ?.latitude;
                            double? long = viewModel
                                .facilityRespoonse
                                ?.data
                                ?.result
                                ?.comLicenseInfo
                                ?.locationInfo
                                ?.longitude;

                            if (lat != null && long != null) {
                              await BottomSheetDialog.showDraggableSheet(
                                  context,
                                  dialogKeyName: DialogName.vdTypesDialog,
                                  currentRouteName: "HomePage",
                                  child: BottomSheetWithActions(
                                    title: "اختر نوع البلاغ".tr(),
                                    body: QrTypesDialog(
                                      cmeraParamsPage: CameraParamsPage(
                                          lat: lat,
                                          lon: long,
                                          qrCodeFlow: true,
                                          pageType: PAGE_TYPE.qrDialog,
                                          isFromHome: false),
                                    ),
                                  ));
                            }
                          }
                        },
                      ));
            }
          }
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
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                child: icon.isNotEmpty
                                                    ? Image.asset(
                                                        icon,
                                                        width: 24,
                                                        height: 24,
                                                      )
                                                    : Container(),
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
                                                      CustomTextWidget(
                                                        dataPoint?.address
                                                                ?.buildingName ??
                                                            dataPoint?.title ??
                                                            "",
                                                        fontColor: AppColor
                                                            .blackModern800Light,
                                                        fontSize: 16,
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        fontWeight:
                                                            AppFontWeight.bold,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const CustomVerticalSpace(
                                                        height: 11,
                                                      ),
                                                      if (dataPoint?.workStatus
                                                              ?.isOpen ==
                                                          true)
                                                        CustomTextWidget(
                                                          "open".tr(),
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFFA7C587),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      if (dataPoint?.workStatus
                                                              ?.isOpen ==
                                                          true)
                                                        const CustomVerticalSpace(
                                                          height: 10,
                                                        ),
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
                                                        textAlign:
                                                            TextAlign.start,
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
                                        /* Row(
                                          children:
                                              dataPoint?.openingHours?.values
                                                      .where((e) =>
                                                          e!.values.isNotEmpty)
                                                      .map(
                                                        (e) => Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomTextWidget(
                                                                e!
                                                                    .values[0]!
                                                                    .startTime
                                                                    .weekDay
                                                                    .displayName(),
                                                                fontColor: AppColor
                                                                    .blackModern800Light,
                                                                fontSize: 10,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    AppFontWeight
                                                                        .bold,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                              ...e.values
                                                                  .map((e) => [
                                                                        const CustomVerticalSpace(
                                                                          height:
                                                                              6,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          e!.displayStartTime(),
                                                                          fontColor:
                                                                              AppColor.blackModern500Light,
                                                                          fontSize:
                                                                              6,
                                                                          textOverflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontWeight:
                                                                              AppFontWeight.bold,
                                                                          maxLines:
                                                                              5,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          textDirection:
                                                                              TextDirection.ltr,
                                                                        ),
                                                                        CustomTextWidget(
                                                                          e!.displayFinishTime(),
                                                                          fontColor:
                                                                              AppColor.blackModern500Light,
                                                                          fontSize:
                                                                              6,
                                                                          textOverflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontWeight:
                                                                              AppFontWeight.bold,
                                                                          maxLines:
                                                                              5,
                                                                          textAlign:
                                                                              TextAlign.start,
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
                                        ),*/

                                        if ((dataPoint?.contactInfos
                                                    .phoneNumber() !=
                                                null) &&
                                            (dataPoint!.contactInfos
                                                .phoneNumber()!
                                                .isNotEmpty)) ...[
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          CustomTextWidget(
                                            dataPoint?.contactInfos
                                                    .phoneNumber() ??
                                                "",
                                            fontColor:
                                                AppColor.blackModern800Light,
                                            fontSize: 16,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontWeight: AppFontWeight.bold,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                        ]
                                      ],
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
