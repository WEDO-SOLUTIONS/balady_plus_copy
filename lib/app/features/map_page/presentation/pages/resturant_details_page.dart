import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/data/model/resturant_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/domain/entities/categories/category_item.dart';
import '../../constants/constants.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_sub_header.dart';

class ResturantDetailsPage extends StatelessWidget {
  const ResturantDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ResturantModel item =
        ModalRoute.of(context)!.settings.arguments as ResturantModel;
    return Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        body: Stack(
          children: [
            MapDetailsHeader(
              name: "",
              address: "",
              type: "",
              color: Color(0xffCD5D1A),
              image: Constants.restaurantLayerIcon,
            ),
            Container(
              margin: const EdgeInsets.only(top: 190),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                color: AppColor.scaffoldBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                // image: DecorationImage(image: AssetImage())
              ),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              item.TRADENAME ?? "",
                              fontColor: AppColor.blackModern800Light,
                              fontWeight: AppFontWeight.bold,
                              textAlign: TextAlign.start,
                              fontSize: 18,
                            ),
                            CustomVerticalSpace(height: 16),
                            CustomTextWidget(
                              item.getAddress,
                              fontColor: AppColor.blackModern500Light,
                              fontWeight: AppFontWeight.semiBold,
                              textAlign: TextAlign.start,
                              fontSize: 14,
                            )
                          ],
                        ),
                      ),
                      CustomVerticalSpace(height: 16),
                      MapDetailsSubHeader(
                          firstTitle: "نوع المنشأة",
                          firstSubTitle:
                              item.ACTIVITY_DETAILED_DESCRIPTION ?? "",
                          firstIcon: Constants.restaurantLayerIcon,
                          secondTitle: "", //"تقيم المنشأة",
                          secondSubTitle: "", //item.getRating,
                          secondIcon: null //IconPath.qrRatingStarIcon,
                          ),
                      CustomVerticalSpace(height: 24),
                      if (item.showWorkingHours) ...[
                        CustomTextWidget(
                          "تفاصيل العمل",
                          fontColor: AppColor.blackModern800Light,
                          fontWeight: AppFontWeight.bold,
                          textAlign: TextAlign.start,
                          fontSize: 18,
                        ),
                        CustomVerticalSpace(height: 16),
                        WorkingDayListWidget(
                          model: item,
                        ),
                        CustomVerticalSpace(height: 16),
                      ],
                      CustomTextWidget(
                        "تفاصيل الموقع",
                        fontColor: AppColor.blackModern800Light,
                        fontWeight: AppFontWeight.bold,
                        textAlign: TextAlign.start,
                        fontSize: 18,
                      ),
                      CustomVerticalSpace(height: 16),
                      MapDetailsField(
                        title: "العنوان",
                        subTitle: item.getAddress,
                      ),
                      CustomVerticalSpace(height: 32),
                      ElevatedButtonWidget.primaryCustom(
                        text: ('submit_incident').tr(),
                        onPressed: () async {
                          double? lat = item.latLng?.latitude;
                          double? long = item.latLng?.longitude;

                          bool isLocationAvailable =
                              await CommonFunctions.checkLocationSettings(
                                  context);
                          bool isCameraAllowed =
                              await CommonFunctions.checkCameraSettings(
                                  context);
                          if (isLocationAvailable && isCameraAllowed) {
                            NavigationService.navigatorKey.currentState!
                                .pushNamed(
                              RouteName.vdCameraPage,
                              arguments: CameraParamsPage(
                                lat: lat,
                                lon: long,
                                qrCodeFlow: true,
                                pageType: PAGE_TYPE.qrDialog,
                                selectedCategory: CategoryItem(
                                    categoryId: RemoteConfig.marketClass.first),
                                // isFromHome: false,
                              ),
                            );
                          }
                        },
                      ),
                      CustomVerticalSpace(height: 16),
                    ]),
              ),
            ),
          ],
        ));
  }
}

class WorkingDayListWidget extends StatefulWidget {
  final ResturantModel model;

  const WorkingDayListWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<WorkingDayListWidget> createState() => _WorkingDayListWidgetState();
}

class _WorkingDayListWidgetState extends State<WorkingDayListWidget> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          showAll = !showAll;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomSvgIconWidget(
                  IconPath.qrClockIcon,
                  iconSize: 16,
                  iconColor: AppColor.primary900Light,
                ),
                const CustomHorizontalSpace(width: 4),
                CustomTextWidget(
                  ('working_time').tr(),
                  fontColor: AppColor.black,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 13,
                  textAlign: TextAlign.start,
                ),
                Spacer(),
                Image.asset(
                  showAll ? IconPath.qrArrowUpIcon : IconPath.qrArrowDownIcon,
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            if (showAll)
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: showAll ? 7 : 0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return WorkingTimeWidget(
                        dayName: widget.model.getDayByNameIndex(index) ?? "",
                        firstShift:
                            widget.model.getFirstShiftByIndex(index) ?? "",
                        secondShift:
                            widget.model.getSecondShiftByIndex(index) ?? "",
                        thirdShift:
                            widget.model.getThirdShiftByIndex(index) ?? "",
                        showAll: showAll && index != ((7) - 1),
                      );
                    }),
              ),
            // const CustomVerticalSpace(height: 24)
          ],
        ),
      ),
    );
  }
}

class WorkingTimeWidget extends StatelessWidget {
  final String dayName;
  final String? firstShift;
  final String? secondShift;
  final String? thirdShift;
  final bool showAll;

  const WorkingTimeWidget({
    Key? key,
    required this.dayName,
    this.firstShift,
    this.secondShift,
    this.thirdShift,
    this.showAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextWidget(
                  dayName,
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  fontColor: AppColor.black500,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      firstShift ?? "",
                      fontSize: 16,
                      fontWeight: AppFontWeight.regular,
                      fontColor: AppColor.black500,
                      maxLines: 3,
                    ),
                    if (secondShift != null) ...[
                      const CustomVerticalSpace(height: 5),
                      CustomTextWidget(
                        secondShift ?? "",
                        fontSize: 16,
                        fontWeight: AppFontWeight.regular,
                        fontColor: AppColor.black500,
                        maxLines: 3,
                      )
                    ],
                    if (thirdShift != null) ...[
                      const CustomVerticalSpace(height: 5),
                      CustomTextWidget(
                        thirdShift ?? "",
                        fontSize: 16,
                        fontWeight: AppFontWeight.regular,
                        fontColor: AppColor.black500,
                        maxLines: 3,
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
          if (showAll)
            const DrawLineWidget(
              verticalMargin: 8,
              lineColor: AppColor.kGray230,
            )
        ],
      ),
    );
  }

  String getTime(String time) {
    return CommonFunctions.getFormattedTime(time);
  }
}
