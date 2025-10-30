import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../../data/models/find_cemetry_response_model.dart';

class CemetryDetailsItemWidget extends StatelessWidget {
  final FindCemetryItem item;
  const CemetryDetailsItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                RequestParameter(
                  title: 'city'.tr(),
                  value: item.cityName ?? "",
                ),
                RequestParameter(
                  title: 'cemeteryName'.tr(),
                  value: item.cemeteryName ?? "",
                ),
                RequestParameter(
                  title: 'district'.tr(),
                  value: item.districtName ?? "",
                ),
                RequestParameter(
                  title: 'municipality'.tr(),
                  value: item.municipalityName ?? "",
                ),
                RequestParameter(
                  title: 'sub_municipality'.tr(),
                  value: item.submunicipalityName ?? "",
                ),
                RequestParameter(
                  title: 'street'.tr(),
                  value: item.streetName ?? "",
                ),
                RequestParameter(
                  title: 'ekram_laundry_exists'.tr(),
                  value: item.laundryExist == true ? "yes".tr() : "no".tr(),
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.primaryCustom(
              onPressed: () {
                Navigator.of(NavigationService.navigatorKey.currentContext!)
                    .pushNamed(
                  RouteName.inappWebview,
                  arguments: (
                    requestNum: ''.tr(),
                    url: item.locationViewerUrl,
                    isObjections: false
                  ),
                );
              },
              text: "location".tr())
        ],
      ),
    );
  }
}
