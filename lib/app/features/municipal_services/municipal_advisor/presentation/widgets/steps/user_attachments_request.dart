import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart';

class UserAttachmentsRequest extends StatelessWidget {
  const UserAttachmentsRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${'CleaningMechanisms'.tr()}: ",
                style: AppStyle.tagStyle,
              ),
              TextSpan(
                text: state.selectedCleanMechanism?.name ?? '',
                style: AppStyle.tagStyle.copyWith(
                  color: AppColor.primary300Light,
                  height: 2,
                ),
              ),
              TextSpan(
                text: "\n${'municipalAdvisorAttachmentsBrand'.tr()}: ",
                style: AppStyle.tagStyle,
              ),
              TextSpan(
                text: (state.hasBrand ?? false) ? 'yes'.tr() : 'no'.tr(),
                style: AppStyle.tagStyle.copyWith(
                  color: AppColor.primary300Light,
                  height: 2,
                ),
              ),
              TextSpan(
                text: "\n${'municipalAdvisorOwnershipProof'.tr()}: ",
                style: AppStyle.tagStyle,
              ),
              TextSpan(
                text: state.selectedShopOwnership?.contractTypeName ?? '',
                style: AppStyle.tagStyle.copyWith(
                  color: AppColor.primary300Light,
                  height: 2,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.right,
        );
      },
    );
  }
}
