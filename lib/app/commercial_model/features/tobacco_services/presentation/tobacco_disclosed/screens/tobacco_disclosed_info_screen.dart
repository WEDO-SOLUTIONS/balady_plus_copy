import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/mvvm/tobacco_disclosed_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/widgets/card_desc_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TobaccoDisclosedInfoScreen extends StatelessWidget {
  const TobaccoDisclosedInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TobaccoDisclosedViewModel provider =
        context.watch<TobaccoDisclosedViewModel>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  CustomEnhancedExpansionPanelWidget(
                    title: 'establishment_data'.tr(),
                    isExpanded: true,
                    backgroundColor: AppColor.blackModern50Light,
                    leading: const DrawIconBasedTypeWidget(
                      icon: IconPath.clipboard,
                    ),
                    children: [
                      CardParameter(
                        title: 'establsihment_name'.tr(),
                        value:
                            provider.disclosureRequest.facility.facilityName ??
                                '',
                      ),
                      CardParameter(
                        title: 'unified_license_number'.tr(),
                        value: provider
                                .disclosureRequest.facility.baladyLicenseNo ??
                            '',
                      ),
                      CardParameter(
                        title: 'certificate_number'.tr(),
                        value: provider.disclosureRequest.facility
                                .registrationNumber ??
                            '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomEnhancedExpansionPanelWidget(
                    title: 'applicants_status_data'.tr(),
                    backgroundColor: AppColor.blackModern50Light,
                    leading: const DrawIconBasedTypeWidget(
                      icon: IconPath.profile,
                    ),
                    children: [
                      CardParameter(
                        title: 'name'.tr(),
                        value: CommonProperties.selectedDelegator?.entityName ??
                            CommonProperties.userInfo!.arName ??
                            '',
                      ),
                      CardParameter(
                        title: 'id_number'.tr(),
                        value: CommonProperties.selectedDelegator?.id ??
                            CommonProperties.userInfo!.idNo ??
                            '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomEnhancedExpansionPanelWidget(
                    title: 'additional_data_attachments'.tr(),
                    backgroundColor: AppColor.blackModern50Light,
                    leading: const DrawIconBasedTypeWidget(
                      icon: IconPath.clipboard,
                    ),
                    children: [
                      CardParameter(
                        title: 'lbl_attachments'.tr(),
                        value: provider.fileUploaded!.fileName ?? '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CardDescWidget(
                    icon: IconPath.saveIcon,
                    title: 'pledges'.tr(),
                    description:
                        '${'pledges_submit_disclosure1'.tr()} ${'month${provider.disclosureRequest.disclosureSchedule.month}'.tr()} ${'the_years'.tr()} ${provider.disclosureRequest.disclosureSchedule.year} ${'pledges_submit_disclosure2'.tr()} ${provider.disclosureRequest.disclosureAmount ?? 0} ${'pledges_submit_disclosure3'.tr()} ${(provider.disclosureRequest.disclosureAmount ?? 0 * (provider.disclosureRequest.disclosureSchedule.percentage / 100))} ${'pledges_submit_disclosure4'.tr()}',
                    widget: Selector<TobaccoDisclosedViewModel, bool>(
                      selector: (_, provider) => provider.acknowledgePledge,
                      builder: (context, acknowledgePledge, child) {
                        return InkWell(
                          onTap: () {
                            provider.setAcknowledgePledge(!acknowledgePledge);
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: acknowledgePledge,
                                onChanged: (bool? value) {
                                  provider.setAcknowledgePledge(
                                    !acknowledgePledge,
                                  );
                                },
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  'acknowledge_pledge'.tr(),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: Column(
            children: [
              Consumer<TobaccoDisclosedViewModel>(
                // selector: (_, provider) => provider.isLoading,
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? const ShimmerEffectWidget(
                          height: 60,
                          borderRadius: 8,
                        )
                      : EnhancedCustomElevatedButtonWidget(
                          btnColor: !provider.acknowledgePledge
                              ? AppColor.black200
                              : AppColor.primary900Light,
                          btnTextColor: !provider.acknowledgePledge
                              ? AppColor.black400
                              : AppColor.white,
                          btnPressed: !provider.acknowledgePledge
                              ? null
                              : () async {
                                  var data = await provider.uploadDisclosure();
                                  if (data != null) {
                                    Navigator.popAndPushNamed(
                                      context,
                                      CommercialRouteName.submitDisclosedSuccessfully,
                                      // arguments: data,
                                    );
                                  }
                                },
                          btnRadius: 8,
                          btnText: "submit_order".tr(),
                          btnTextSize: 16,
                          btnTextWeight: AppFontWeight.bold,
                          btnHeight: 56,
                        );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
