import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/submit_renew_commercial_bloc/renew_commercial_license_bloc.dart';

class EjarServiceContract extends StatelessWidget {
  const EjarServiceContract({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
        return state.showEJARService()
            ? Container(
                height: 160,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColor.white),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(IconPath.vdSummuryDesc),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: CustomTextWidget(
                                  "electrnoic_contract".tr(),
                                  fontColor: AppColor.blackModern500Light,
                                  fontSize: 16,
                                  maxLines: 2,
                                  fontWeight: AppFontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              "location_proof_type".tr(),
                              fontColor: AppColor.primary900Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.bold,
                            ),
                            const CustomVerticalSpace(height: 8),
                            CustomTextWidget(
                              state.getContractName(),
                              fontColor: AppColor.blackModern600Light,
                              fontSize: 14,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              "contract_number".tr(),
                              fontColor: AppColor.primary900Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.bold,
                            ),
                            const CustomVerticalSpace(height: 8),
                            CustomTextWidget(
                              state
                                      .info
                                      ?.ownershipResponseDto
                                      ?.tenancyContractInfo
                                      ?.tenancyContractNumber ??
                                  "",
                              fontColor: AppColor.blackModern600Light,
                              fontSize: 14,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              "contract_expiry_date".tr(),
                              fontColor: AppColor.primary900Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.bold,
                            ),
                            const CustomVerticalSpace(height: 8),
                            CustomTextWidget(
                              state.info?.ownershipResponseDto
                                      ?.tenancyContractInfo?.contractEndDate ??
                                  "",
                              fontColor: AppColor.blackModern600Light,
                              fontSize: 14,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              "contract_version_no".tr(),
                              fontColor: AppColor.primary900Light,
                              fontSize: 12,
                              fontWeight: AppFontWeight.bold,
                            ),
                            const CustomVerticalSpace(height: 8),
                            CustomTextWidget(
                              state.info?.ownershipResponseDto
                                      ?.tenancyContractInfo?.versionNumber ??
                                  "",
                              fontColor: AppColor.blackModern600Light,
                              fontSize: 14,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
