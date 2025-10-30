import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../bloc/cr_step6_establishment_data_cubit.dart';

class ManagerInfoCard extends StatelessWidget {
  const ManagerInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CRStep6EstablishmentCubit, CRStep6EstablishmentState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: AppColor.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomSvgIconWidget(IconPath.clipboard),
                  SizedBox(width: 4),
                  Flexible(
                    child: CustomTextWidget(
                      "managerLocation".tr(),
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          "name".tr(),
                          fontColor: AppColor.primary700Light,
                          fontSize: 10,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        SizedBox(height: 8),
                        CustomTextWidget(
                          state.managerInfo?.fullName ?? "",
                          fontColor: AppColor.blackModern600Light,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          "personal_gender".tr(),
                          fontColor: AppColor.primary700Light,
                          fontSize: 10,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        SizedBox(height: 8),
                        CustomTextWidget(
                          state.managerInfo?.sexDescription ?? "",
                          fontColor: AppColor.blackModern600Light,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          "nationality".tr(),
                          fontColor: AppColor.primary700Light,
                          fontSize: 10,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        SizedBox(height: 8),
                        CustomTextWidget(
                          state.managerInfo?.nationalityDescription ?? "",
                          fontColor: AppColor.blackModern600Light,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          "job".tr(),
                          fontColor: AppColor.primary700Light,
                          fontSize: 10,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                        SizedBox(height: 8),
                        CustomTextWidget(
                          state.managerInfo?.occupationDescription ?? "",
                          fontColor: AppColor.blackModern600Light,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
