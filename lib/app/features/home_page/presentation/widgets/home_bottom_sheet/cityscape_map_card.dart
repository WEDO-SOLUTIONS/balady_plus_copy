import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../home_exports.dart';

class CityScapeMapCard extends StatelessWidget {
  const CityScapeMapCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel =
        Provider.of<MapViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        mapViewModel.navigateToCityScape();
      },
      child: Container(
        height: 228,
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Color(0xffF4FAF4),
          image: DecorationImage(
            image: AssetImage(ImagePath.cityScapeBg),
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
                      CustomTextWidget(
                        "city_scape_title".tr(),
                        fontColor: AppColor.blackModern800Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 110),
                        child: CustomTextWidget(
                          "city_scape_desc".tr(),
                          fontColor: AppColor.blackModern600Light,
                          fontWeight: AppFontWeight.bold,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          maxLines: null,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomElevatedButtonWidget(
                        btnColor: AppColor.primary900Light,
                        textStyle: AppStyle.elevatedButtonStyle.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        btnHeight: 40,
                        btnWidth: 157,
                        text: "city_scape".tr(),
                        onPressed: () async {
                          mapViewModel.navigateToCityScape();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
