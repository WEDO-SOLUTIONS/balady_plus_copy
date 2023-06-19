import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../licenses_exports.dart' show LicenseEntity, LicenseParameter;

class LicensesListItem extends StatelessWidget {
  final LicenseEntity request;

  const LicensesListItem({
    super.key,
    required this.request,
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
                  '#${request.licenseNumber}'.tr(),
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: request.licenseStatusName,
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
                  value: request.licenseTypeName,
                ),
                LicenseParameter(
                  title: 'request_type'.tr(),
                  value: request.requestTypeName,
                ),
                LicenseParameter(
                  title: 'munipality'.tr(),
                  value: request.municipalityName,
                ),
                LicenseParameter(
                  title: 'sub_munipality'.tr(),
                  value: request.subMunicipalityName,
                ),
                LicenseParameter(
                  title: 'license_end_date'.tr(),
                  value: DateFormat.yMd().format(request.licenseEndDate),
                ),
                LicenseParameter(
                  title: 'last_update'.tr(),
                  value: DateFormat.yMd().format(request.updateTime),
                ),
              ],
            ),
          ),
          ElevatedButtonWidget.details(onPressed: () {}),
        ],
      ),
    );
  }
}
