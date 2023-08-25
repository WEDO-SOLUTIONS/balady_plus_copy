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
import '../mvvm/map_view_model.dart';
import '../mvvm/point_view_model.dart';
import 'package:collection/collection.dart';

import '../pages/mosque_details_page.dart';
import '../pages/parks_details_page.dart';
import '../pages/station_details_page.dart';

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
                      ? ShimmerEffectWidget(
                          height: 120,
                        )
                      : Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            )),
                                        child: Image.asset(
                                          icon,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      CustomHorizontalSpace(width: 8),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  end: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomVerticalSpace(height: 8),
                                              CustomTextWidget(
                                                dataPoint?.title ?? "",
                                                fontColor: AppColor
                                                    .blackModern800Light,
                                                fontSize: 16,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                fontWeight: AppFontWeight.bold,
                                                maxLines: 2,
                                              ),
                                              CustomVerticalSpace(height: 8),
                                              CustomTextWidget(
                                                dataPoint?.makeAddress() ?? "",
                                                fontColor: AppColor
                                                    .blackModern500Light,
                                                fontSize: 12,
                                                fontWeight:
                                                    AppFontWeight.semiBold,
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
                                  dataPoint?.workStatus?.isOpen == true
                                      ? "open".tr()
                                      : "".tr(),
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
                                    backgroundColor:
                                        AppColor.geyser.withOpacity(0.4),
                                    iconSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                });
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
