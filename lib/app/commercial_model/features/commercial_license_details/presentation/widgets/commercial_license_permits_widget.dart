import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/commercial_license_permits.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/commercial_license_permits_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class CommercialLicensePermitsWidget extends StatelessWidget {
  const CommercialLicensePermitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CommercialLicensePermitsViewModel provider =
        context.watch<CommercialLicensePermitsViewModel>();
    return Selector<CommercialLicensePermitsViewModel,
        List<CommercialLicensePermits>?>(
      builder: (context, permits, child) {
        return ExpandableCard(
          title: 'permits'.tr(),
          icon: IconPath.element_3Icon,
          children: permits != null
              ? permits
                  .map((permit) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const DrawIconBasedTypeWidget(
                                    icon: IconPath.documentCopy,
                                    iconSize: 24,
                                  ),
                                  CustomTextWidget(
                                    'permit'.tr(),
                                    textStyle: AppStyle.cardTitleTextStle,
                                  ),
                                  const Spacer(),
                                  CustomTextWidget(
                                    '# ${permit.permitNumber}',
                                    textStyle: AppStyle.dateTextStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          "permitName".tr(),
                                          textStyle: AppStyle.tagTextStyle,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomTextWidget(
                                          permit.permitType,
                                          textStyle:
                                              AppStyle.costTitleTextStyle,
                                          maxLines: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          "expirationDate".tr(),
                                          textStyle: AppStyle.tagTextStyle,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomTextWidget(
                                          permit.expirationDate,
                                          textStyle:
                                              AppStyle.costTitleTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList()
              : [
                  Center(
                    child: CustomTextWidget(
                      ('data_not_have_permits').tr(),
                      fontSize: 14,
                      fontColor: AppColor.primary900Light,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
        );
      },
      selector: (_, provider) => provider.permits,
    );
  }
}
