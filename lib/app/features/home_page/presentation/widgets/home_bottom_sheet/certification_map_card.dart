import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../home_exports.dart';

class CertificationMapCard extends StatelessWidget {
  const CertificationMapCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: AssetImage(ImagePath.certificationMapBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 18, right: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextWidget(
                      "خريطة شهادة الإمتثال",
                      fontColor: AppColor.blackModern800Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 110),
                      child: CustomTextWidget(
                        "تعرف على الطرق المستهدفة لتطبيق شهادة الامتثال من خلال الخريطة",
                        fontColor: AppColor.blackModern600Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                        maxLines: null,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButtonWidget(
                            btnColor: AppColor.primary900Light,
                            textStyle: AppStyle.elevatedButtonStyle.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            btnHeight: 40,
                            btnRadius: 7,
                            btnPadding: EdgeInsets.all(8),
                            text: "complinace_isue".tr(),
                            onPressed: () async {
                              NavigationService.navigatorKey.currentState!
                                  .pushNamed(RouteName.createCompliancePage);
                            },
                          ),
                        ),
                        const CustomHorizontalSpace(width: 8),
                        Expanded(
                          child: CustomElevatedButtonWidget(
                            btnColor: AppColor.white,
                            btnRadius: 7,
                            btnPadding: EdgeInsets.all(8),
                            btnBorderColor: AppColor.primary900Light,
                            textStyle: AppStyle.elevatedButtonStyle.copyWith(
                              color: AppColor.primary900Light,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            btnHeight: 40,
                            text: "self_rating".tr(),
                            onPressed: () async {
                              NavigationService.navigatorKey.currentState!
                                  .pushNamed(RouteName.selfRatingMainPage);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  color: AppColor.white.withOpacity(0.6),
                ),
                child: Row(
                  children: [
                    CustomTextWidget(
                      "to_know_more".tr(),
                      fontWeight: AppFontWeight.bold,
                      fontSize: 10,
                      fontColor: AppColor.blackModern900Light,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(RouteName.QAPage,arguments: RemoteConfig.MunicipalServicesIDs["create_complianceLocation"]["id"]);
                      },
                      child: CustomTextWidget(
                        "check_faq".tr(),
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        fontColor: AppColor.primary900Light,
                      ),
                    ),
                    const SizedBox(width: 6),
                    CustomTextWidget(
                      "or".tr(),
                      fontWeight: AppFontWeight.bold,
                      fontSize: 12,
                      fontColor: AppColor.blackModern500Light,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        await BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName: DialogName.buildingComplianceDialog,
                          currentRouteName: "HomePage",
                          child: BuildingRequirementsDialog(),
                        );
                      },
                      child: CustomTextWidget(
                        "home_view_condition".tr(),
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        fontColor: AppColor.primary900Light,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          PositionedDirectional(
            end: 8,
            top: 12,
            child: GestureDetector(
              onTap: () {
                MapViewModel mapViewModel =
                    Provider.of<MapViewModel>(context, listen: false);

                mapViewModel.navigateToImtethal();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary900Light,
                ),
                child: const CustomSvgIconWidget(IconPath.map, iconSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
