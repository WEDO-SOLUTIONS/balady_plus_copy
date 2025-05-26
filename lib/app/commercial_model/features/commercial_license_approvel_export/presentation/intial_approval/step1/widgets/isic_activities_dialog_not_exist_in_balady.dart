import 'package:balady_plus/app/commercial_model/features/commercial_license/commercial_license_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';
import '../../step2/widgets/map_widgets/warning_message.dart';
import '../bloc/step1_applicant_data_export_cubit.dart';


class IsicActivitiesDialogNotExistInBalady extends StatelessWidget {
  const IsicActivitiesDialogNotExistInBalady({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Step1ApplicantDataExportCubit, Step1ApplicantDataExportState>(
      buildWhen: (previous, current) =>
          previous.isicActivitiesNotExistInBalady !=
          current.isicActivitiesNotExistInBalady,
      listenWhen: (previous, current) =>
          previous.addIsicActivitiesStatus != current.addIsicActivitiesStatus,
      listener: (context, state) {
        if (state.addIsicActivitiesStatus.isSubmissionFailure) {
          CommonFunctions.showError(state.errorMessage);
        }
        if (state.addIsicActivitiesStatus.isSubmissionSuccess) {
          context.popDialog();
          context.popRoute();
          context.popRoute();
          context.popRoute();
          CommonFunctions.showSuccess("commerical_add_activity_sucessfull".tr());


        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            BottomSheetWithActions(
              action: Column(
                children: [

                  ElevatedButtonWidget.sendRequest(
                      onPressed: () => showMessage(context)),

                  const SizedBox(height: 16),

                  if (state.isicActivitiesExistInBalady.isNotEmpty)
                    ElevatedButtonWidget.issuing(onPressed: () {
                      context.popDialog();
                      sl<CommercialLicenseInitialAprrovalBloc>().add((const NextPageEvent()));
                    }),
                  const SizedBox(height: 16),
                ],
              ),
              title: '',
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomSvgIconWidget(IconPath.warning2),
                  const SizedBox(height: 16),
                  CustomTextWidget(
                    "cr_some_activity_does_not_exists".tr(),
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern700Light,
                    fontSize: 16,
                    height: 1.5,
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(height: 16),
                  CustomExpansionPanelWidget(
                    title: "cr_listed_activities".tr(),
                    arrowBg: AppColor.primary300Light,
                    leading: const CustomSvgIconWidget(
                      IconPath.boxTick,
                      iconColor: AppColor.primary900Light,
                      iconSize: 20,
                    ),
                    withShadow: true,
                    children: [
                      ListView.separated(
                        itemCount: state.isicActivitiesExistInBalady.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) => Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            color: AppColor.primary50Light.withOpacity(0.5),
                          ),
                          child: Row(
                            children: [
                              const CustomSvgIconWidget(IconPath.checked,
                                  iconSize: 10),
                              const SizedBox(width: 6),
                              Flexible(
                                child: CustomTextWidget(
                                  state.isicActivitiesExistInBalady[index].name,
                                  fontWeight: AppFontWeight.bold,
                                  fontColor: AppColor.blackModern700Light,
                                  fontSize: 14,
                                  height: 1.5,
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomExpansionPanelWidget(
                    title: "cr_not_listed_activities".tr(),
                    arrowBg: AppColor.blue300Light,
                    leading: const CustomSvgIconWidget(
                      IconPath.boxTick,
                      iconColor: AppColor.blue900Light,
                      iconSize: 20,
                    ),
                    withShadow: true,
                    children: [
                      ListView.separated(
                        itemCount: state.isicActivitiesNotExistInBalady.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) => Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            color: AppColor.blue50Light.withOpacity(0.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.close,
                                size: 10,
                                color: AppColor.blue900Light,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: CustomTextWidget(
                                  state.isicActivitiesNotExistInBalady[index]
                                      .name,
                                  fontWeight: AppFontWeight.bold,
                                  fontColor: AppColor.blackModern700Light,
                                  fontSize: 14,
                                  height: 1.5,
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (state.addIsicActivitiesStatus.isSubmissionLoading)
              const CustomCircularLoadingWidget(),
          ],
        );
      },
    );
  }

  void showMessage(BuildContext context) {
    BottomSheetDialog.showDraggableSheet(
        NavigationService.navigatorKey.currentContext!,
        child: BottomSheetWithActions(
          title: "cancelLicenseWarningTitleWord".tr(),
          action: Row(
            children: [
              Expanded(
                child: ElevatedButtonWidget.primaryCustom(
                    text: "agree".tr(),
                    onPressed: () {
                      context
                          .read<Step1ApplicantDataExportCubit>()
                          .addIsicActivities();
                    }),
              ),
            ],
          ),
          body: WarningMessage(message: "cr_acivity_not_exists".tr()),
        ));
  }
}
