import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/commercial_license_permits.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/request_details/presentation/mvvm/selected_permits_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

//CommercialLicensePermitsWidget :
//import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/commercial_license_permits_widget.dart';
// need Set One Widget to the list of Permits
class SelectedCommercialLicensePermitsWidget extends StatelessWidget {
  const SelectedCommercialLicensePermitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SelectedPermitsViewModel provider =
        context.watch<SelectedPermitsViewModel>();

    return Selector<SelectedPermitsViewModel, List<CommercialLicensePermits>?>(
      builder: (context, permits, child) {
        return ExpandableCard(
          title: 'permits'.tr(),
          icon: IconPath.element_3Icon,
          children: permits != null && permits.isNotEmpty
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
                                  const SizedBox(width: 2),
                                  CustomTextWidget(
                                    '# ${permit.permitNumber}',
                                    textStyle: AppStyle.dateTextStyle,
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColor.primary800Light,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          CustomTextWidget(
                                            'ACTIVE'.tr(),
                                            textStyle: AppStyle.riyalEventStyle,
                                          ),
                                        ],
                                      ),
                                    ),
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
                                          "permitType".tr(),
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
