import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../report_damaged_car/presentation/widgets/create_dc_request/details_widgets/plate_widget.dart';
import '../../domain/entities/create_retrive_page_params.dart';
import '../../domain/entities/veichle_card_model.dart';

class VechicleCardWidget extends StatelessWidget {
  final VehicleCard item;
  const VechicleCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        /* boxShadow: const [
          BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 0)
        ],*/
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 24, start: 16, end: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomVerticalSpace(height: 20),
                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomNetworkImageWidget("",
                        placeHolderWidget: Image.asset(IconPath.carIcon,
                            height: 70, width: 300)),
                  ],
                ),*/
                FittedBox(
                  child: HomeTag(
                    title: item.carStatus,
                    height: 32,
                    backgroundColor: AppColor.secondary100Light,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlateWidget(
                      enNumbers: item.plateEnNumber,
                      arNumbers: item.plateArNumber,
                      enLetters: CommonFunctions.getCarPlateEnlgishLetters(
                          item.plateLetters),
                      arLetters: CommonFunctions.getCarPlateArabicLetters(
                          item.plateLetters),
                    ),
                  ],
                ),
                CustomVerticalSpace(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColor.primary50Light50,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  item.carModel,
                                  fontColor: AppColor.black,
                                  fontSize: 14,
                                  fontWeight: AppFontWeight.semiBold,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                                //MM  Expanded(child: StatusWidget(status: item.carStatus)),
                              ],
                            ),
                            CustomVerticalSpace(height: 8),
                            CustomTextWidget(
                              item.plateNumber,
                              fontColor: AppColor.blackModern500Light,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: ElevatedButtonWidget.retriveCar(onPressed: () {
                            NavigationService.navigatorKey.currentState
                                ?.pushNamed(RouteName.CreateRetriveDetailsPage,
                                    arguments: CreateRetrivePageParams(
                                        item: item.item,
                                        type: "OnBehalfOfMyself"));
                          }))
                    ],
                  ),
                ),
                CustomVerticalSpace(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  TitleAndSubtitleWidget(
                    //       subTitle: item.plateNumber,
                    //        title: ("dc_plate_number").tr()),
                  ],
                ),
              ],
            ),
          ),
          /*Column(
            children: [
              DrawLineWidget(
                lineColor: AppColor.black200.withOpacity(0.2000000029802322),
              ),
              // go to details button
              CustomGoToDetailsButtonWidget(
                onPressed: () {
                  NavigationService.pushNamed(
                      routeName: RoutesNames.CreateRetriveDetailsPage,
                      args: CreateRetrivePageParams(
                          item: item.item, type: "OnBehalfOfMyself"));
                },
                label: Helpers.translatingWord(
                  "dc_recovery_request",
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
