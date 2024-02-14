import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../licenses_exports.dart' show LicenseEntity, LicenseParameter;

class LicensesListItem extends StatelessWidget {
  final LicenseEntity license;

  const LicensesListItem({
    super.key,
    required this.license,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DrawIconBasedTypeWidget(icon: IconPath.licenses),
              const SizedBox(width: 4),
              CustomTextWidget(
                'license'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#${license.licenseNumber}'.tr(),
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: license.licenseStatusName,
                backgroundColor: AppColor.secondary100Light,
              ),
            ],
          ),
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
                LicenseParameter(
                  title: 'license_type'.tr(),
                  value: license.licenseTypeName,
                ),
                LicenseParameter(
                  title: 'request_type'.tr(),
                  value: license.requestTypeName,
                ),
                LicenseParameter(
                  title: 'municipality'.tr(),
                  value: license.municipalityName,
                ),
                LicenseParameter(
                  title: 'sub_municipality'.tr(),
                  value: license.subMunicipalityName,
                ),
                LicenseParameter(
                  title: 'license_end_date'.tr(),
                  value: DateFormat.yMd().format(license.licenseEndDate),
                ),
                if (license.updateTime != null)
                  LicenseParameter(
                    title: 'last_operation'.tr(),
                    value: DateFormat.yMd().format(license.updateTime!),
                  ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(
            onPressed: () async {
              String screenName = getScreenName(
                ScreenTage.license.name,
                typeId: int.parse(license.requestMainTypeId!),
              );
              if (screenName == RouteName.inappWebview) {
                CommonFunctions.openBaldyWithRefreshCookie(
                  license.redirectUrl,
                );
              } else {
                NavigationService.navigatorKey.currentState!.pushNamed(
                  screenName,
                  arguments: {
                    "licenseNumber": license.licenseNumber.toString(),
                    // Send requestNumber when go to HealthLicenseDetailsScreen
                    "requestNumber": license.requestNumber.toString(),
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
