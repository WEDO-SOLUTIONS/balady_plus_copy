import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class AdditionalInformation extends StatelessWidget {
  const AdditionalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '9. ${'municipalAdvisorOtherData'.tr()}\n',
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: '${'municipalAdvisorLicenseYears'.tr()}:\n',
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: '- ${state.maxYears} ${'year'.tr()}\n\n',
                style: AppStyle.lightTextStyle,
              ),
              TextSpan(
                text: '${'municipalAdvisorMunicipalRequirements'.tr()}:\n',
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: '${'municipalAdvisorDownloadRequirements'.tr()}\n\n',
                style: AppStyle.lightTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    CommonFunctions.externalLaunch(
                      state.conditionsUrls!.baladyConditionsUrl,
                    );
                  },
              ),
              if (state.fastflowConditions.isNotEmpty) ...[
                TextSpan(
                  text: '${'municipalAdvisorMunicipalInspection'.tr()}:\n',
                  style: AppStyle.textFieldTitleTextStyle.copyWith(
                    color: AppColor.primary900Light,
                  ),
                ),
                TextSpan(
                  text: '${'municipalAdvisorMunicipalInspectionList'.tr()}\n\n',
                  style: AppStyle.lightTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      final List<String> items = state.fastflowConditions
                          .map((e) => e.conditionName)
                          .toList();
                      BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.municipainspectionDialog,
                        currentRouteName: RouteName.municipalAdvisor,
                        child: BottomSheetList(
                          title: "municipalAdvisorMunicipalInspectionListTitle"
                              .tr(),
                          items: items,
                          onTap: null,
                          searchable: false,
                        ),
                      );
                    },
                ),
              ],
              TextSpan(
                text: '${'municipalAdvisorBoards'.tr()}:\n',
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: '${'municipalAdvisorBoardsRequirements'.tr()}\n\n',
                style: AppStyle.lightTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    CommonFunctions.externalLaunch(
                      state.conditionsUrls!.boardsUrl,
                    );
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}
